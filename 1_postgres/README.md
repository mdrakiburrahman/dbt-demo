# DBT with Postgres Container

``` PowerShell
# Python setup
python -m venv env # Create venv
& env\Scripts\Activate.ps1 # Activate venv
pip install -r requirements.txt

# Validate install
dbt --version
# installed version: 1.0.3
#    latest version: 1.0.3

# Up to date!

# Plugins:
#   - postgres: 1.0.3 - Up to date!
docker --version
# Docker version 20.10.12, build e91ed57
pgcli --version
# Version: 3.4.0

# deactivate # Deactivate venv
```

Spin up Postgres container from WSL (for mount):
```bash
cd '1_postgres'
docker-compose up -d
```

Connect from PowerShell:
```PowerShell
$env:PGPASSWORD="password1234"
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
