# Dev Postgres with pgvector

This directory provides a Postgres container with the `pgvector` extension for development.

## Start

- From this folder: `docker compose up -d`
- Optionally copy `.env.example` to `.env` to override defaults.

The container exposes `localhost:5432`.

## Connect from Rails

Use `DATABASE_URL` or set host/user/password in `config/database.yml`.

Let Rails handle DB creation/migrations/extensions with its commands, e.g.:

- `bin/rails db:create`
- `bin/rails db:migrate`
- In a migration: `enable_extension 'vector'`

Example env for development:

```
DATABASE_URL=postgres://postgres:postgres@localhost:5432/api_development
```

## Stop / Remove

- Stop: `docker compose down`
- Clean data: `docker compose down -v` (removes the volume)

Data persists in the `db_data` Docker volume across restarts.
