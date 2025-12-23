# DBT with Postgres Container

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/1_postgres"

python -m venv env
source env/bin/activate
pip install -r requirements.txt

dbt --version
# Core:
#   - installed: 1.11.2
#   - latest:    1.11.2 - Up to date!
# 
# Plugins:
#   - postgres: 1.10.0 - Up to date!

docker --version
# Docker version 29.1.3, build f52814d

pgcli --version
# Version: Version: 4.3.0

# deactivate # Deactivate venv
```

Spin up Postgres container from WSL (for mount):
```bash
docker-compose up -d
```

Connect from terminal:

```bash
export PGPASSWORD="password1234"
pgcli -h localhost -U dbt -p 5432 -d dbt

# Server: PostgreSQL 13.6 (Debian 13.6-1.pgdg110+1)
# Version: 3.4.0
# Home: http://pgcli.com
# dbt@localhost:dbt> SELECT * FROM warehouse.customers LIMIT 5;
# +-------------+---------+-----------------------+------------+---------------------+---------------------+
# | customer_id | zipcode | city                  | state_code | datetime_created    | datetime_updated    |
# |-------------+---------+-----------------------+------------+---------------------+---------------------|
# | 1           | 14409   | franca                | SP         | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
# | 2           | 09790   | sao bernardo do campo | SP         | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
# | 3           | 01151   | sao paulo             | SP         | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
# | 4           | 08775   | mogi das cruzes       | SP         | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
# | 5           | 13056   | campinas              | SP         | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
# +-------------+---------+-----------------------+------------+---------------------+---------------------+
```
