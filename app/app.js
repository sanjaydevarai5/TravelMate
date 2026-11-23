// Import express.js
const path = require('path');
const express = require('express');

// Create express app
var app = express();

// Configure Pug views and static files
app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, '..', 'static')));

// Get the functions in the db.js file to use
const db = require('./services/db');

// Helpers used by the read-only dashboard and trip detail routes
const planStatuses = ['Draft', 'Shared', 'Approved'];
const sortOptions = {
    recent: 'p.updated_at DESC, p.plan_id DESC',
    start_soon: 'p.start_date ASC, p.plan_id DESC',
    cost_low: 'p.estimated_total ASC, p.plan_id DESC',
    cost_high: 'p.estimated_total DESC, p.plan_id DESC'
};

function cleanText(value, maxLength) {
    return typeof value === 'string' ? value.trim().slice(0, maxLength) : '';
}

function cleanDate(value) {
    const date = cleanText(value, 10);
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) return '';
    const parsed = new Date(`${date}T00:00:00Z`);
    return !Number.isNaN(parsed.getTime()) && parsed.toISOString().slice(0, 10) === date ? date : '';
}

function cleanBudget(value) {
    if (typeof value !== 'string' || value.trim() === '') return '';
    const amount = Number(value);
    return Number.isFinite(amount) && amount >= 0 && amount <= 1000000 ? amount.toFixed(2) : '';
}

function cleanId(value) {
    const id = cleanText(value, 12);
    return /^[1-9]\d*$/.test(id) ? id : '';
}

function displayMoney(amount, currency) {
    return new Intl.NumberFormat('en-GB', {
        style: 'currency',
        currency: currency || 'GBP'
    }).format(Number(amount || 0));
}

// Create a route for root - /
app.get('/', function(req, res) {
    res.render('home');
});

app.get('/about', function(req, res) {
    res.render('about');
});

app.get('/contact', function(req, res) {
    res.render('contact');
});

// Login and registration are UI only; no authentication is performed.
app.get('/login', function(req, res) {
    res.render('login');
});

app.get('/register', function(req, res) {
    res.render('register');
});

// Read-only dashboard: search and filters are applied to MySQL data.
app.get('/dashboard', async function(req, res) {
    const filters = {
        search: cleanText(req.query.search, 100),
        status: planStatuses.includes(req.query.status) ? req.query.status : '',
        destination: cleanText(req.query.destination, 160),
        travellerId: cleanId(req.query.traveller),
        agentId: cleanId(req.query.agent),
        startAfter: cleanDate(req.query.start_after),
        startBefore: cleanDate(req.query.start_before),
        budgetMax: cleanBudget(req.query.budget_max),
        sort: Object.prototype.hasOwnProperty.call(sortOptions, req.query.sort) ? req.query.sort : 'recent'
    };

    const conditions = [];
    const values = [];

    if (filters.search) {
        const term = `%${filters.search.replace(/[\\%_]/g, '\\$&')}%`;
        conditions.push('(p.reference_code LIKE ? OR p.title LIKE ? OR p.destination LIKE ? OR t.display_name LIKE ? OR a.display_name LIKE ?)');
        values.push(term, term, term, term, term);
    }
    if (filters.status) {
        conditions.push('p.status = ?');
        values.push(filters.status);
    }
    if (filters.destination) {
        conditions.push('p.destination = ?');
        values.push(filters.destination);
    }
    if (filters.travellerId) {
        conditions.push('p.traveller_id = ?');
        values.push(filters.travellerId);
    }
    if (filters.agentId) {
        conditions.push('p.agent_id = ?');
        values.push(filters.agentId);
    }
    if (filters.startAfter) {
        conditions.push('p.start_date >= ?');
        values.push(filters.startAfter);
    }
    if (filters.startBefore) {
        conditions.push('p.start_date <= ?');
        values.push(filters.startBefore);
    }
    if (filters.budgetMax) {
        conditions.push('p.estimated_total <= ?');
        values.push(filters.budgetMax);
    }

    const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
    const plansSql = `
        SELECT
            p.plan_id,
            p.reference_code,
            p.title,
            p.destination,
            p.start_date,
            p.end_date,
            DATE_FORMAT(p.start_date, '%d %b %Y') AS start_date_label,
            DATE_FORMAT(p.end_date, '%d %b %Y') AS end_date_label,
            DATEDIFF(p.end_date, p.start_date) + 1 AS duration_days,
            p.status,
            p.estimated_total,
            p.currency,
            DATE_FORMAT(p.updated_at, '%d %b %Y, %H:%i') AS updated_at_label,
            t.display_name AS traveller_name,
            a.display_name AS agent_name,
            (SELECT COUNT(*) FROM tour_days d WHERE d.plan_id = p.plan_id) AS day_count,
            (SELECT COUNT(*) FROM activities ac JOIN tour_days d ON d.day_id = ac.day_id WHERE d.plan_id = p.plan_id) AS activity_count
        FROM tour_plans p
        JOIN travellers t ON t.traveller_id = p.traveller_id
        JOIN travel_agents a ON a.agent_id = p.agent_id
        ${where}
        ORDER BY ${sortOptions[filters.sort]}
        LIMIT 100`;

    try {
        const [plans, groupedStatuses, destinations, travellers, agents] = await Promise.all([
            db.query(plansSql, values),
            db.query('SELECT status, COUNT(*) AS count FROM tour_plans GROUP BY status', []),
            db.query('SELECT DISTINCT destination FROM tour_plans ORDER BY destination', []),
            db.query('SELECT traveller_id, display_name FROM travellers ORDER BY display_name', []),
            db.query('SELECT agent_id, display_name FROM travel_agents ORDER BY display_name', [])
        ]);

        const countByStatus = Object.fromEntries(groupedStatuses.map(function(row) {
            return [row.status, Number(row.count)];
        }));
        const statusTotals = [
            { name: 'All plans', count: groupedStatuses.reduce(function(total, row) { return total + Number(row.count); }, 0) },
            ...planStatuses.map(function(name) {
                return { name: name, count: countByStatus[name] || 0 };
            })
        ];

        res.render('dashboard', {
            filters: filters,
            plans: plans.map(function(plan) {
                return Object.assign({}, plan, {
                    estimated_total_label: displayMoney(plan.estimated_total, plan.currency)
                });
            }),
            destinations: destinations.map(function(row) { return row.destination; }),
            travellers: travellers,
            agents: agents,
            statusTotals: statusTotals,
            loadError: ''
        });
    } catch (error) {
        console.error('Dashboard database read failed:', error.message);
        res.status(503).render('dashboard', {
            filters: filters,
            plans: [],
            destinations: [],
            travellers: [],
            agents: [],
            statusTotals: [
                { name: 'All plans', count: 0 },
                ...planStatuses.map(function(name) { return { name: name, count: 0 }; })
            ],
            loadError: 'The database is unavailable. Start MySQL and import sd2-db.sql to load the dashboard.'
        });
    }
});

app.get('/health', async function(req, res) {
    try {
        await db.query('SELECT 1', []);
        res.status(200).json({ status: 'ok', database: 'connected' });
    } catch (error) {
        res.status(503).json({ status: 'unavailable', database: 'disconnected' });
    }
});

// Create a route for testing the db (example from the project scaffold)
app.get('/db_test', function(req, res) {
    const sql = 'select * from test_table';
    db.query(sql, []).then(function(results) {
        console.log(results);
        res.send(results);
    }).catch(function(error) {
        console.error('Database example route failed:', error.message);
        res.status(503).send('Database unavailable');
    });
});

// Create a route for /goodbye
// Responds to a 'GET' request
app.get('/goodbye', function(req, res) {
    res.send('Goodbye world!');
});

// Create a dynamic route for /hello/<name>, where name is any value provided by user
// At the end of the URL
// Responds to a 'GET' request
app.get('/hello/:name', function(req, res) {
    console.log(req.params);
    res.send('Hello ' + req.params.name);
});

// Start server on port 3000
const port = Number(process.env.PORT || 3000);
app.listen(port, function() {
    console.log(`Server running at http://127.0.0.1:${port}/`);
});
