# Portfolio Management Microservices Platform

A runnable portfolio-management demo containing independent Portfolio, Transaction,
and Pricing services plus a JavaScript dashboard.

## Stack
- Python (FastAPI)
- Java (Spring Boot)
- JavaScript (HTML/CSS/JS)
- PostgreSQL-ready SQL schema
- Docker / Docker Compose
- REST APIs

## Run
```bash
docker compose up --build
```

Services:
- Portfolio: http://localhost:8001
- Transaction: http://localhost:8002
- Pricing: http://localhost:8003
- Dashboard: http://localhost:8080

The services use an in-memory demo store by default so the project can be run
without installing PostgreSQL. `db/schema.sql` contains the PostgreSQL schema,
indexes, and sample data for database-backed deployment.

For a quick local run without Docker:
```bash
pip install -r services/portfolio/requirements.txt
uvicorn app:app --app-dir services/portfolio --port 8001
```
Run the transaction and pricing services similarly on ports 8002 and 8003.
