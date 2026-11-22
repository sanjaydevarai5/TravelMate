# TravelMate — Sprint 3 prototype
Official assessment brief: working proof-of-concept with MySQL database, pre-filled records, static Pug pages, and dynamic database data displayed through Express/Pug. Deadline: 25 November 2026, 2:00 PM UK. All five team members should contribute genuine code and attend the review.

## Run with Docker (recommended)
Install Docker Desktop. From repository root run `docker compose up --build`, then visit http://localhost:3000. On first run, MySQL initialises from `sql/sprint3.sql`. The app may need a few seconds for the database to finish starting.

## Run without Docker
Create MySQL database by importing `sql/sprint3.sql`. Copy `.env.example` to `.env` and edit credentials. Run `npm install` and `npm start`. Open http://localhost:3000.

## Demo
Home -> Trips -> Japan Discovery -> view six itinerary days and GBP cost breakdown. To demonstrate dynamic rendering, change a trip title in MySQL, refresh /trips and observe the updated title. Sample data is illustrative and does not represent real prices or bookings.

## Scope and limits
This is a **read-only Sprint 3 proof of concept**; no user authentication, feedback submission, CRUD forms, or booking. It does not claim to implement all Sprint 2 user stories. The Docker Compose configuration is intended for local development, not production deployment.

## Review evidence
- Database schema and seeded sample data: `sql/sprint3.sql`.
- Express server: `app.js`; model/controller: `models/Trip.js`, `controllers/tripController.js`.
- Pug templates: `views/*.pug`.
- Responsive styles: `public/css/style.css`.
- Screenshots and individual commit evidence should be collected by actual team members after running and testing.

## Team contribution guidance
Sanjay: integration/demo; Sri Vishnu: traveller UI; Janardhan: controllers; Harsha: schema/data; Dinakar: agent-facing list/testing. These are planned assignments, not claims of completed work.
