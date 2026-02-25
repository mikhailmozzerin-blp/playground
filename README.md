# Personal Playground

This repository is just a personal playground for trying SQL/KPI ideas and schema experiments.

## BLP KPI Query Pack (MySQL 8 + SQLFluff Jinja vars)

## What is included
- `queries/*.sql` - one KPI query per file, using Jinja variables like `{{ from_ts }}`

### Connection defaults
- host: 127.0.0.1
- port: 3307 (override via `MYSQL_PORT` env var)
- user/pass: blp/blp
- db: blp_kpi


https://dbdiagram.io/d/Analytics-db-v2_ext-699c2bd7bd82f5fce281a648