# TravelMate — Agent-Assisted Trip Planner

Software Development 2 group project by **Avengers Assemble**, University of Roehampton.

## Current implementation
Read-only Sprint 3 proof of concept using Node.js, Express, Pug, MySQL and Docker. Includes a homepage, database-backed trip listing, a six-day Japan itinerary with activities and cost breakdown, and a health endpoint.

**This is not the completed Sprint 4 application.** Authentication, role-specific permissions, feedback, approval workflow, full CRUD, booking and payments are not implemented. The sample itinerary and prices are illustrative.

## Quick start
Install Docker Desktop and run:
```bash
git clone https://github.com/sanjaydevarai5/TravelMate.git
cd TravelMate
docker compose up --build -d
docker compose ps
```
Visit http://localhost:3000, http://localhost:3000/trips, http://localhost:3000/trips/1.

## Tests
Install Node.js, run `npm install`, then `npm test`. These are source-level checks, not a substitute for running the full application and database.

## Guides
- [Sprint 3 evidence and responsibilities](docs/sprint-3/README.md)
- [Step-by-step deployment](docs/DEPLOYMENT.md)
- [Manual test checklist](docs/TEST_PLAN.md)
- [Local SQL schema and seed](sql/sprint3.sql)
- [Managed MySQL import SQL](sql/railway-init.sql)

## Team contributions
All team members should make their own genuine commits and document tested features. AI-generated starting code does not constitute five members' contributions.
