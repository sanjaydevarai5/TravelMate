const pool=require('../config/db');
class Trip {
 static async all(){const [rows]=await pool.query(`SELECT t.id,t.title,t.destination,t.start_date,t.end_date,t.status,t.estimated_total, u.name AS traveller_name FROM trips t JOIN users u ON u.id=t.traveller_id ORDER BY t.id DESC`);return rows;}
 static async find(id){const [[trip]]=await pool.query('SELECT t.*,u.name AS traveller_name FROM trips t JOIN users u ON u.id=t.traveller_id WHERE t.id=?',[id]);if(!trip)return null;const [days]=await pool.query('SELECT d.id,d.day_number,d.title,d.description FROM itinerary_days d WHERE d.trip_id=? ORDER BY d.day_number',[id]);for(const day of days){const [activities]=await pool.query('SELECT title,location,notes FROM activities WHERE day_id=? ORDER BY id',[day.id]);day.activities=activities;}trip.days=days;const [costs]=await pool.query('SELECT category,amount FROM cost_items WHERE trip_id=? ORDER BY id',[id]);trip.costs=costs;return trip;}
}
module.exports=Trip;
