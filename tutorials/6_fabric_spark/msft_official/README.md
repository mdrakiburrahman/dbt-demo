# Microsoft official

* [Microsoft Official](https://learn.microsoft.com/en-us/fabric/data-warehouse/tutorial-setup-dbt)
* [DBT Fabric Spark setup](https://docs.getdbt.com/docs/core/connect-data-platform/fabricspark-setup)
* [DBT Fabric Spark configuration](https://docs.getdbt.com/reference/resource-configs/fabricspark-configs)

## Environment setup

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/tutorials/6_fabric_spark/msft_official"

python -m venv env
source env/bin/activate
pip install -r requirements.txt

dbt --version
```

## Project setup

Test connectivity:

```bash
cd "${GIT_ROOT}/tutorials/6_fabric_spark/msft_official/jaffle-shop-classic"
export DBT_PROFILES_DIR=$(pwd)
dbt debug
```

Seed:

```bash
dbt seed
```

And we see:

![Warehouse seeded](.imgs/warehouse-seeded.png)

And fire:

```bash
dbt run
```

Test to validate data quality:

```bash
dbt test
```

And we can see the DBT DAG:

```bash
dbt docs generate
dbt docs serve
```