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

> Warning: flaky, needs retries configured for the config

```bash
cd "${GIT_ROOT}/tutorials/6_fabric_spark/msft_official/jaffle-shop-classic"
export DBT_PROFILES_DIR=$(pwd)
dbt debug
```

Seed:

```bash
dbt seed

# 16:55:37  Running with dbt=1.11.2
# 16:55:37  Registered adapter: fabricspark=1.9.0
# 16:55:37  Found 5 models, 3 seeds, 20 data tests, 507 macros
# 16:55:37  
# 16:55:37  Concurrency: 1 threads (target='fabric-dev')
# 16:55:37  
# 16:55:37  Microsoft Fabric-Spark adapter: Using CLI auth
# 16:56:16  1 of 3 START seed file demo_etl_dbt.raw_customers .............................. [RUN]
# 16:56:34  1 of 3 OK loaded seed file demo_etl_dbt.raw_customers .......................... [INSERT 100 in 18.61s]
# 16:56:34  2 of 3 START seed file demo_etl_dbt.raw_orders ................................. [RUN]
# 16:56:48  2 of 3 OK loaded seed file demo_etl_dbt.raw_orders ............................. [INSERT 99 in 13.52s]
# 16:56:48  3 of 3 START seed file demo_etl_dbt.raw_payments ............................... [RUN]
# 16:57:01  3 of 3 OK loaded seed file demo_etl_dbt.raw_payments ........................... [INSERT 113 in 13.21s]
# 16:57:03  
# 16:57:03  Finished running 3 seeds in 0 hours 1 minutes and 25.76 seconds (85.76s).
# 16:57:03  
# 16:57:03  Completed successfully
# 16:57:03  
# 16:57:03  Done. PASS=3 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=3
```

And we see:

![Lakehouse seeded](.imgs/lakehouse-seeded.png)

And fire:

```bash
dbt run
```

With views:

```bash
17:59:06  Running with dbt=1.11.2
17:59:06  Registered adapter: fabricspark=1.9.0
17:59:07  Unable to do partial parsing because a project config has changed
17:59:07  [WARNING][UnexpectedJinjaBlockDeprecation]: Deprecated functionality
Found unexpected 'do' block tag. in file
`macros/materializations/models/table/create_table_as.sql`
17:59:08  [WARNING][MissingArgumentsPropertyInGenericTestDeprecation]: Deprecated
functionality
Found top-level arguments to test `relationships` defined on 'orders' in package
'jaffle_shop' (models/schema.yml). Arguments to generic tests should be nested
under the `arguments` property.
17:59:08  Found 5 models, 3 seeds, 20 data tests, 507 macros
17:59:08  
17:59:08  Concurrency: 1 threads (target='fabric-dev')
17:59:08  
17:59:08  Microsoft Fabric-Spark adapter: Using CLI auth
17:59:10  Microsoft Fabric-Spark adapter: Warning: No message, retrying due to 'retry_all' configuration set to true.
        Retrying in 10 seconds (0 of 25)
17:59:21  Microsoft Fabric-Spark adapter: Warning: No message, retrying due to 'retry_all' configuration set to true.
        Retrying in 10 seconds (1 of 25)
18:10:59  1 of 5 START sql view model demo_etl_dbt.stg_customers ......................... [RUN]
18:11:06  1 of 5 OK created sql view model demo_etl_dbt.stg_customers .................... [OK in 7.06s]
18:11:06  2 of 5 START sql view model demo_etl_dbt.stg_orders ............................ [RUN]
18:11:13  2 of 5 OK created sql view model demo_etl_dbt.stg_orders ....................... [OK in 6.87s]
18:11:13  3 of 5 START sql view model demo_etl_dbt.stg_payments .......................... [RUN]
18:11:20  3 of 5 OK created sql view model demo_etl_dbt.stg_payments ..................... [OK in 6.44s]
18:11:20  4 of 5 START sql table model demo_etl_dbt.customers ............................ [RUN]
18:11:50  4 of 5 OK created sql table model demo_etl_dbt.customers ....................... [OK in 30.77s]
18:11:50  5 of 5 START sql table model demo_etl_dbt.orders ............................... [RUN]
18:12:09  5 of 5 OK created sql table model demo_etl_dbt.orders .......................... [OK in 18.27s]
18:00:36  
18:00:36  Finished running 5 view models in 0 hours 1 minutes and 27.91 seconds (87.91s).
18:00:36  
18:00:36  Completed successfully
18:00:36  
18:00:36  Done. PASS=5 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=5
```

Test to validate data quality:

```bash
dbt test

18:01:13  Running with dbt=1.11.2
18:01:13  Registered adapter: fabricspark=1.9.0
18:01:14  Found 5 models, 3 seeds, 20 data tests, 507 macros
18:01:14  
18:01:14  Concurrency: 1 threads (target='fabric-dev')
18:01:14  
18:01:14  Microsoft Fabric-Spark adapter: Using CLI auth
18:01:38  1 of 20 START test accepted_values_orders_status__placed__shipped__completed__return_pending__returned  [RUN]
18:01:50  1 of 20 PASS accepted_values_orders_status__placed__shipped__completed__return_pending__returned  [PASS in 11.98s]
18:01:50  2 of 20 START test accepted_values_stg_orders_status__placed__shipped__completed__return_pending__returned  [RUN]
18:01:58  2 of 20 PASS accepted_values_stg_orders_status__placed__shipped__completed__return_pending__returned  [PASS in 8.01s]
18:01:58  3 of 20 START test accepted_values_stg_payments_payment_method__credit_card__coupon__bank_transfer__gift_card  [RUN]
18:02:04  3 of 20 PASS accepted_values_stg_payments_payment_method__credit_card__coupon__bank_transfer__gift_card  [PASS in 6.45s]
18:02:04  4 of 20 START test not_null_customers_customer_id .............................. [RUN]
18:02:11  4 of 20 PASS not_null_customers_customer_id .................................... [PASS in 6.41s]
18:02:11  5 of 20 START test not_null_orders_amount ...................................... [RUN]
18:02:17  5 of 20 PASS not_null_orders_amount ............................................ [PASS in 6.39s]
18:02:17  6 of 20 START test not_null_orders_bank_transfer_amount ........................ [RUN]
18:02:24  6 of 20 PASS not_null_orders_bank_transfer_amount .............................. [PASS in 6.50s]
18:02:24  7 of 20 START test not_null_orders_coupon_amount ............................... [RUN]
18:02:30  7 of 20 PASS not_null_orders_coupon_amount ..................................... [PASS in 6.46s]
18:02:30  8 of 20 START test not_null_orders_credit_card_amount .......................... [RUN]
18:02:37  8 of 20 PASS not_null_orders_credit_card_amount ................................ [PASS in 6.40s]
18:02:37  9 of 20 START test not_null_orders_customer_id ................................. [RUN]
18:02:43  9 of 20 PASS not_null_orders_customer_id ....................................... [PASS in 6.37s]
18:02:43  10 of 20 START test not_null_orders_gift_card_amount ........................... [RUN]
18:02:49  10 of 20 PASS not_null_orders_gift_card_amount ................................. [PASS in 6.42s]
18:02:49  11 of 20 START test not_null_orders_order_id ................................... [RUN]
18:02:56  11 of 20 PASS not_null_orders_order_id ......................................... [PASS in 6.20s]
18:02:56  12 of 20 START test not_null_stg_customers_customer_id ......................... [RUN]
18:03:02  12 of 20 PASS not_null_stg_customers_customer_id ............................... [PASS in 6.32s]
18:03:02  13 of 20 START test not_null_stg_orders_order_id ............................... [RUN]
18:03:08  13 of 20 PASS not_null_stg_orders_order_id ..................................... [PASS in 6.19s]
18:03:08  14 of 20 START test not_null_stg_payments_payment_id ........................... [RUN]
18:03:14  14 of 20 PASS not_null_stg_payments_payment_id ................................. [PASS in 6.28s]
18:03:14  15 of 20 START test relationships_orders_customer_id__customer_id__ref_customers_  [RUN]
18:03:21  15 of 20 PASS relationships_orders_customer_id__customer_id__ref_customers_ .... [PASS in 6.37s]
18:03:21  16 of 20 START test unique_customers_customer_id ............................... [RUN]
18:03:27  16 of 20 PASS unique_customers_customer_id ..................................... [PASS in 6.58s]
18:03:27  17 of 20 START test unique_orders_order_id ..................................... [RUN]
18:03:34  17 of 20 PASS unique_orders_order_id ........................................... [PASS in 6.50s]
18:03:34  18 of 20 START test unique_stg_customers_customer_id ........................... [RUN]
18:03:41  18 of 20 PASS unique_stg_customers_customer_id ................................. [PASS in 6.83s]
18:03:41  19 of 20 START test unique_stg_orders_order_id ................................. [RUN]
18:03:47  19 of 20 PASS unique_stg_orders_order_id ....................................... [PASS in 6.54s]
18:03:47  20 of 20 START test unique_stg_payments_payment_id ............................. [RUN]
18:03:54  20 of 20 PASS unique_stg_payments_payment_id ................................... [PASS in 6.36s]
18:03:56  
18:03:56  Finished running 20 data tests in 0 hours 2 minutes and 41.76 seconds (161.76s).
```

And we can see the DBT DAG:

```bash
dbt docs generate
dbt docs serve
```