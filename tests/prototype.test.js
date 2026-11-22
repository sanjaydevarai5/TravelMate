const test=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const root=path.join(__dirname,'..');
test('required application files exist',()=>{
 for(const file of ['app.js','config/db.js','models/Trip.js','controllers/tripController.js','views/home.pug','views/dashboard.pug','views/trip.pug','sql/sprint3.sql','Dockerfile','docker-compose.yml']){
  assert.ok(fs.existsSync(path.join(root,file)),file);
 }
});
test('Pug templates include dynamic content',()=>{
 const dashboard=fs.readFileSync(path.join(root,'views/dashboard.pug'),'utf8');
 const detail=fs.readFileSync(path.join(root,'views/trip.pug'),'utf8');
 assert.match(dashboard,/each trip in trips/);
 assert.match(detail,/each day in trip.days/);
 assert.match(detail,/each cost in trip.costs/);
});
test('SQL contains relational tables and prefilled itinerary',()=>{
 const sql=fs.readFileSync(path.join(root,'sql/sprint3.sql'),'utf8');
 for(const name of ['users','trips','itinerary_days','activities','cost_items'])assert.match(sql,new RegExp('CREATE TABLE IF NOT EXISTS '+name));
 assert.match(sql,/Tokyo/);
});
