# DBT with Postgres Container

* [Website snapshot](https://web.archive.org/web/20230206200025/https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)
* [Code snapshot](https://github.com/josephmachado/simple_dbt_project/tree/ee8b9679790c10d85fef806ee003feda5423362a)
* [SCD2](https://web.archive.org/web/20230206183346/https://www.startdataengineering.com/post/how-to-join-fact-scd2-tables/)

![Data Flow](.imgs/data_flow.png)

## Environment setup

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/tutorials/1_postgres"

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

```sql
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;
```

```text
+------------+-----------+
| schemaname | tablename |
|------------+-----------|
| warehouse  | customers |
| warehouse  | orders    |
| warehouse  | state     |
+------------+-----------+
```

## Run

```bash
export DBT_PROFILES_DIR="${GIT_ROOT}/tutorials/1_postgres/sde_dbt_tutorial"
cd ${DBT_PROFILES_DIR}

# Compile SQL statements but don't run them
dbt compile

# 21:44:47  Running with dbt=1.11.2
# 21:44:47  [WARNING]: Deprecated functionality
# 
# User config should be moved from the 'config' key in profiles.yml to the 'flags' key in dbt_project.yml.
# 21:44:47  [WARNING]: Deprecated functionality
# The `source-paths` config has been renamed to `model-paths`. Please update your
# `dbt_project.yml` configuration to reflect this change.
# 21:44:47  [WARNING]: Deprecated functionality
# The `data-paths` config has been renamed to `seed-paths`. Please update your
# `dbt_project.yml` configuration to reflect this change.
# 21:44:47  Registered adapter: postgres=1.10.0
# 21:44:47  Unable to do partial parsing because saved manifest not found. Starting full parse.
# 21:44:48  [WARNING][MissingArgumentsPropertyInGenericTestDeprecation]: Deprecated
# functionality
# Found top-level arguments to test `accepted_values` defined on 'customer_orders'
# in package 'sde_dbt_tutorial' (models/marts/marketing/marketing.yml). Arguments
# to generic tests should be nested under the `arguments` property.
# 21:44:49  Found 6 models, 1 snapshot, 10 data tests, 3 sources, 463 macros
# 21:44:49  
# 21:44:49  Concurrency: 1 threads (target='dev')
# 21:44:49  
# 21:44:49  [WARNING][DeprecationsSummary]: Deprecated functionality
# Summary of encountered deprecations:
# - ProjectFlagsMovedDeprecation: 1 occurrence
# - ConfigSourcePathDeprecation: 1 occurrence
# - ConfigDataPathDeprecation: 1 occurrence
# - MissingArgumentsPropertyInGenericTestDeprecation: 2 occurrences
# To see all deprecation instances instead of just the first occurrence of each,
# run command again with the `--show-all-deprecations` flag. You may also need to
# run with `--no-partial-parse` as some deprecations are only encountered during
# parsing.

# Run a dbt snapshot
dbt snapshot

# 22:01:42  Registered adapter: postgres=1.10.0
# 22:01:42  Found 6 models, 1 snapshot, 10 data tests, 3 sources, 463 macros
# 22:01:42  
# 22:01:42  Concurrency: 1 threads (target='dev')
# 22:01:42  
# 22:01:42  1 of 1 START snapshot snapshots.customers_snapshot ............................. [RUN]
# 22:01:42  Data type of snapshot table timestamp columns (DATETIME) doesn't match derived column 'updated_at' (TEXT). Please update snapshot config 'updated_at'.
# 22:01:42  1 of 1 OK snapshotted snapshots.customers_snapshot ............................. [SELECT 100 in 0.13s]
# 22:01:42  
# 22:01:42  Finished running 1 snapshot in 0 hours 0 minutes and 0.24 seconds (0.24s).
# 22:01:42  
# 22:01:42  Completed successfully
# 22:01:42  
# 22:01:42  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
# 22:01:42  [WARNING][DeprecationsSummary]: Deprecated functionality

# +------------+--------------------+
# | schemaname | tablename          |
# |------------+--------------------|
# | snapshots  | customers_snapshot |
# | warehouse  | customers          |
# | warehouse  | orders             |
# | warehouse  | state              |
# +------------+--------------------+
```

Simulate changed rows in Postgres:

```sql
COPY warehouse.customers(customer_id, zipcode, city, state_code, datetime_created, datetime_updated)
FROM '/input_data/customer_new.csv' DELIMITER ',' CSV HEADER;

-- COPY 5
-- Time: 0.004s
```

Run again:

```bash
dbt snapshot

# 22:03:20  Concurrency: 1 threads (target='dev')
# 22:03:20  
# 22:03:20  1 of 1 START snapshot snapshots.customers_snapshot ............................. [RUN]
# 22:03:20  Data type of snapshot table timestamp columns (DATETIME) doesn't match derived column 'updated_at' (TEXT). Please update snapshot config 'updated_at'.
# 22:03:20  1 of 1 OK snapshotted snapshots.customers_snapshot ............................. [INSERT 0 5 in 0.15s]
# 22:03:20  
# 22:03:20  Finished running 1 snapshot in 0 hours 0 minutes and 0.23 seconds (0.23s).
```

And look at the data:

```sql
-- Raw data
SELECT customer_id, zipcode, datetime_created, datetime_updated
FROM warehouse.customers
WHERE customer_id = 82;

-- +-------------+---------+---------------------+---------------------+
-- | customer_id | zipcode | datetime_created    | datetime_updated    |
-- |-------------+---------+---------------------+---------------------|
-- | 82          | 59655   | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 |
-- | 82          | 24120   | 2017-10-18 00:00:00 | 2017-10-18 00:10:00 |
-- +-------------+---------+---------------------+---------------------+
-- SELECT 2
-- Time: 0.003s

-- Snapshot table
SELECT customer_id, zipcode, datetime_created, datetime_updated, dbt_valid_from, dbt_valid_to
FROM snapshots.customers_snapshot
WHERE customer_id = 82;

-- +-------------+---------+---------------------+---------------------+---------------------+---------------------+
-- | customer_id | zipcode | datetime_created    | datetime_updated    | dbt_valid_from      | dbt_valid_to        |
-- |-------------+---------+---------------------+---------------------+---------------------+---------------------|
-- | 82          | 59655   | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 | 2017-10-18 00:00:00 | 2017-10-18 00:10:00 |
-- | 82          | 24120   | 2017-10-18 00:00:00 | 2017-10-18 00:10:00 | 2017-10-18 00:10:00 | <null>              |
-- +-------------+---------+---------------------+---------------------+---------------------+---------------------+
-- SELECT 2
-- Time: 0.003s
```

And fire dbt to hydrate everything:

```bash
dbt snapshot
# ...

dbt run

# 22:07:59  1 of 6 START sql view model warehouse.stg_eltool__customers .................... [RUN]
# 22:07:59  1 of 6 OK created sql view model warehouse.stg_eltool__customers ............... [CREATE VIEW in 0.08s]
# 22:07:59  2 of 6 START sql view model warehouse.stg_eltool__orders ....................... [RUN]
# 22:07:59  2 of 6 OK created sql view model warehouse.stg_eltool__orders .................. [CREATE VIEW in 0.02s]
# 22:07:59  3 of 6 START sql view model warehouse.stg_eltool__state ........................ [RUN]
# 22:07:59  3 of 6 OK created sql view model warehouse.stg_eltool__state ................... [CREATE VIEW in 0.03s]
# 22:07:59  4 of 6 START sql table model warehouse.fct_orders .............................. [RUN]
# 22:07:59  4 of 6 OK created sql table model warehouse.fct_orders ......................... [SELECT 999 in 0.04s]
# 22:07:59  5 of 6 START sql table model warehouse.dim_customers ........................... [RUN]
# 22:07:59  5 of 6 OK created sql table model warehouse.dim_customers ...................... [SELECT 105 in 0.03s]
# 22:07:59  6 of 6 START sql view model warehouse.customer_orders .......................... [RUN]
# 22:07:59  6 of 6 OK created sql view model warehouse.customer_orders ..................... [CREATE VIEW in 0.08s]
# 22:07:59  
# 22:07:59  Finished running 2 table models, 4 view models in 0 hours 0 minutes and 0.38 seconds (0.38s).
# 22:07:59  
# 22:07:59  Completed successfully

# +------------+--------------------+
# | schemaname | tablename          |
# |------------+--------------------|
# | snapshots  | customers_snapshot |
# | warehouse  | customers          |
# | warehouse  | dim_customers      |
# | warehouse  | fct_orders         |
# | warehouse  | orders             |
# | warehouse  | state              |
# +------------+--------------------+

dbt test

# 22:09:28  1 of 10 START test accepted_values_customer_orders_order_status__delivered__invoiced__shipped__processing__canceled__unavailable  [RUN]
# 22:09:28  1 of 10 PASS accepted_values_customer_orders_order_status__delivered__invoiced__shipped__processing__canceled__unavailable  [PASS in 0.04s]
# 22:09:28  2 of 10 START test assert_customer_dimension_has_no_row_loss ................... [RUN]
# 22:09:28  2 of 10 PASS assert_customer_dimension_has_no_row_loss ......................... [PASS in 0.02s]
# 22:09:28  3 of 10 START test not_null_customer_orders_customer_id ........................ [RUN]
# 22:09:28  3 of 10 PASS not_null_customer_orders_customer_id .............................. [PASS in 0.01s]
# 22:09:28  4 of 10 START test not_null_dim_customers_customer_id .......................... [RUN]
# 22:09:28  4 of 10 PASS not_null_dim_customers_customer_id ................................ [PASS in 0.01s]
# 22:09:28  5 of 10 START test not_null_stg_eltool__customers_customer_id .................. [RUN]
# 22:09:28  5 of 10 PASS not_null_stg_eltool__customers_customer_id ........................ [PASS in 0.01s]
# 22:09:28  6 of 10 START test source_not_null_warehouse_customers_customer_id ............. [RUN]
# 22:09:28  6 of 10 PASS source_not_null_warehouse_customers_customer_id ................... [PASS in 0.01s]
# 22:09:28  7 of 10 START test source_not_null_warehouse_orders_order_id ................... [RUN]
# 22:09:28  7 of 10 PASS source_not_null_warehouse_orders_order_id ......................... [PASS in 0.01s]
# 22:09:28  8 of 10 START test source_relationships_warehouse_orders_cust_id__customer_id__source_warehouse_customers_  [RUN]
# 22:09:28  8 of 10 PASS source_relationships_warehouse_orders_cust_id__customer_id__source_warehouse_customers_  [PASS in 0.02s]
# 22:09:28  9 of 10 START test source_unique_warehouse_orders_order_id ..................... [RUN]
# 22:09:28  9 of 10 PASS source_unique_warehouse_orders_order_id ........................... [PASS in 0.01s]
# 22:09:28  10 of 10 START test unique_customer_orders_order_id ............................ [RUN]
# 22:09:28  10 of 10 PASS unique_customer_orders_order_id .................................. [PASS in 0.01s]
# 22:09:28  
# 22:09:28  Finished running 10 data tests in 0 hours 0 minutes and 0.25 seconds (0.25s).
# 22:09:28  
# 22:09:28  Completed successfully
```

And we see the data:

```sql
SELECT * 
FROM warehouse.customer_orders 
LIMIT 3;

-- +----------------------------------+-------------+--------------+--------------------------+---------------------+------------------------------+-------------------------------+-------------------------------+------------------+----------------+---------------------+---------------------+
-- | order_id                         | customer_id | order_status | order_purchase_timestamp | order_approved_at   | order_delivered_carrier_date | order_delivered_customer_date | order_estimated_delivery_date | customer_zipcode | customer_city  | customer_state_code | customer_state_name |
-- |----------------------------------+-------------+--------------+--------------------------+---------------------+------------------------------+-------------------------------+-------------------------------+------------------+----------------+---------------------+---------------------|
-- | 53cdb2fc8bc7dce0b6741e2150273451 | 17          | delivered    | 2018-07-24 20:41:37      | 2018-07-26 03:24:27 | 2018-07-26 14:31:00          | 2018-08-07 15:27:45           | 2018-08-13 00:00:00           | 22750            | rio de janeiro | RJ                  | Rio de Janeiro      |
-- | 47770eb9100c2d0c44946d9cf07ec65d | 26          | delivered    | 2018-08-08 08:38:49      | 2018-08-08 08:55:23 | 2018-08-08 13:50:00          | 2018-08-17 18:06:29           | 2018-09-04 00:00:00           | 09121            | santo andre    | SP                  | Sao Paulo           |
-- | 949d5b44dbf5de918fe9c16f97b45f8a | 35          | delivered    | 2017-11-18 19:28:06      | 2017-11-18 19:45:59 | 2017-11-22 13:39:59          | 2017-12-02 00:28:42           | 2017-12-15 00:00:00           | 81750            | curitiba       | PR                  | Parana              |
-- +----------------------------------+-------------+--------------+--------------------------+---------------------+------------------------------+-------------------------------+-------------------------------+------------------+----------------+---------------------+---------------------+
```

We can now look at the docs:

```bash
dbt docs generate

# 22:12:06  Building catalog
# 22:12:06  Catalog written to /home/mdrrahman/dbt-demo/1_postgres/sde_dbt_tutorial/target/catalog.json
```

```bash
cat ${GIT_ROOT}/tutorials/1_postgres/sde_dbt_tutorial/target/catalog.json | jq .

# {
#   "metadata": {
#     "dbt_schema_version": "https://schemas.getdbt.com/dbt/catalog/v1.json",
#     "dbt_version": "1.11.2",
#     "generated_at": "2025-12-23T22:12:06.190003Z",
#     "invocation_id": "d748367b-12de-46fd-8701-0b1d93db8538",
#     "invocation_started_at": "2025-12-23T22:12:05.466087Z",
#     "env": {}
#   },
#   "nodes": {
#     "snapshot.sde_dbt_tutorial.customers_snapshot": {
#       "metadata": {
#         "type": "BASE TABLE",
#         "schema": "snaps
```

And serve it:

```bash
dbt docs serve
```

[Browse](http://localhost:8080/#!/overview)

![DBT Docs](.imgs/dbt_docs.png)