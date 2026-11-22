# TravelMate — local to live deployment

## Important
This repository currently contains a **read-only prototype** with publicly visible sample trips. It has no user authentication, no booking, and no payments. Do not add real traveller personal data until proper authentication, authorisation, session security, and privacy protections are implemented. Railway may charge for services.

## Local development (Docker Desktop)
1. Install Docker Desktop and Git.
2. Clone this repository and run `docker compose up --build -d`.
3. Open `http://localhost:3000`, `/trips`, `/trips/1`, and `/health`.
4. Inspect logs with `docker compose logs -f app`.
5. Run `npm test` for static checks (requires Node.js).

## Railway (application + managed MySQL)
1. Sign into Railway and create a project.
2. Deploy the GitHub repository as an application service; choose the Dockerfile builder.
3. Add a managed MySQL service in the same Railway project.
4. Configure app environment variables `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, and `DB_NAME` using Railway's MySQL service reference variables. Set `NODE_ENV=production`. Railway supplies the HTTP `PORT`.
5. **Initialise the database separately** using a MySQL client. The local Compose SQL volume mapping does not automatically run on managed Railway MySQL. See `sql/railway-init.sql` for an import script that uses the already-selected database.
6. Generate a public HTTPS domain in the app service networking settings.
7. Verify `/health`, `/trips`, and `/trips/1`; inspect Railway logs if any route fails.
8. Do not expose MySQL publicly if private networking is available; do not commit passwords or secrets.

## MySQL import
Use Railway's supplied connection credentials. Example from a machine with the MySQL client:
```bash
mysql -h HOST -P PORT -u USER -p DATABASE < sql/railway-init.sql
```
The command above is for Bash. On Windows PowerShell, open the MySQL interactive client with the same connection details and execute `source C:/path/to/TravelMate/sql/railway-init.sql;`. Check the Railway service documentation for database connection instructions.

## Database troubleshooting
The Compose seed script runs only on the **first creation of the MySQL volume**. Re-running `docker compose up` does not overwrite existing data. `docker compose down -v` irreversibly deletes local database data.

## What is not done
No verified deployment has been made by the assistant. A user must authorise/connect Railway and GitHub in Railway, configure billing if required, and deploy. The current app is a demonstrator, not a production-ready authenticated service.
