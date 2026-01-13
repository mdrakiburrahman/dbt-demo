# Microsoft official

* [Microsoft Official](https://learn.microsoft.com/en-us/fabric/data-warehouse/tutorial-setup-dbt)

## Environment setup

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/tutorials/5_fabric_dwh/msft_official"

python -m venv env
source env/bin/activate
pip install -r requirements.txt

dbt --version
```

## Project setup

Test connectivity

```bash
export DBT_PROFILES_DIR=$(pwd)
dbt debug

# 21:57:48  Running with dbt=1.11.2
# 21:57:48  dbt version: 1.11.2
# 21:57:48  python version: 3.13.11
# 21:57:48  python path: /home/mdrrahman/dbt-demo/tutorials/5_fabric_dwh/msft_official/env/bin/python3.13
# 21:57:48  os info: Linux-6.6.87.2-microsoft-standard-WSL2-x86_64-with-glibc2.39
# 21:57:48  Using profiles dir at /home/mdrrahman/dbt-demo/tutorials/5_fabric_dwh/msft_official/jaffle-shop-classic
# 21:57:48  Using profiles.yml file at /home/mdrrahman/dbt-demo/tutorials/5_fabric_dwh/msft_official/jaffle-shop-classic/profiles.yml
# 21:57:48  Using dbt_project.yml file at /home/mdrrahman/dbt-demo/tutorials/5_fabric_dwh/msft_official/jaffle-shop-classic/dbt_project.yml
# 21:57:48  adapter type: fabric
# 21:57:48  adapter version: 1.9.8
# 21:57:48  Configuration:
# 21:57:48    profiles.yml file [OK found and valid]
# 21:57:48    dbt_project.yml file [OK found and valid]
# 21:57:48  Required dependencies:
# 21:57:48   - git [OK found]

# 21:57:48  Connection:
# 21:57:48    server: x6eps4xrq2xudenlfv6naeo3i4-e6y6fnhrgltuti5kvb63urezbq.msit-datawarehouse.fabric.microsoft.com
# 21:57:48    database: demo_warehouse
# 21:57:48    schema: dbo
# 21:57:48    warehouse_snapshot_name: None
# 21:57:48    snapshot_timestamp: None
# 21:57:48    UID: None
# 21:57:48    workspace_id: None
# 21:57:48    authentication: CLI
# 21:57:48    retries: 3
# 21:57:48    login_timeout: 0
# 21:57:48    query_timeout: 0
# 21:57:48    trace_flag: False
# 21:57:48    encrypt: True
# 21:57:48    trust_cert: False
# 21:57:48    api_url: https://api.fabric.microsoft.com/v1
# 21:57:48  Registered adapter: fabric=1.9.8
# 21:57:52    Connection test: [OK connection ok]

# 21:57:52  All checks passed!
```