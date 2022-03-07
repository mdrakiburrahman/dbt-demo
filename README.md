# dbt-demo
Using dbt with various Database Engines.

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
```bash
pgcli -h localhost -U dbt -p 5432 -d dbt -P password1234
```
