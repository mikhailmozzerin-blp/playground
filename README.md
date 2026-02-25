# BLP KPI Query Pack (MySQL 8 + SQLFluff Jinja vars)

## What is included
- `queries/*.sql` - one KPI query per file, using Jinja variables like `{{ from_ts }}`
- `.sqlfluff_vars` - default variables used for linting + test execution
- `scripts/run_query.py` - renders Jinja + executes query against MySQL

## Run a query (recommended)
1. Create venv + install deps:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install pymysql pyyaml jinja2 tabulate
   ```
2. Run:
   ```bash
   python scripts/run_query.py queries/zero_touch_rate.sql --show-sql
   ```

### Connection defaults
- host: 127.0.0.1
- port: 3307 (override via `MYSQL_PORT` env var)
- user/pass: blp/blp
- db: blp_kpi
