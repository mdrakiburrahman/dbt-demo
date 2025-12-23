# dbt dimensional modelling tutorial

* [Website](https://docs.getdbt.com/blog/kimball-dimensional-model)
* [Code](https://github.com/mdrakiburrahman/dbt-dimensional-modelling)

## Table of Contents 

- [Part 0: Understand dimensional modelling concepts](#dimensional-modelling)
- [Part 1: Set up a mock dbt project and database](docs/part01-setup-dbt-project.md)
- [Part 2: Identify the business process to model](docs/part02-identify-business-process.md)
- [Part 3: Identify the fact and dimension tables](docs/part03-identify-fact-dimension.md)
- [Part 4: Create the dimension tables](docs/part04-create-dimension.md)
- [Part 5: Create the fact table](docs/part05-create-fact.md)
- [Part 6: Document the dimensional model relationships](docs/part06-document-model.md)
- [Part 7: Consume the dimensional model](docs/part07-consume-model.md)

## Introduction

Dimensional modelling is one of many data modelling techniques that are used by data practitioners to organize and present data for analytics. Other data modelling techniques include Data Vault (DV), Third Normal Form (3NF), and One Big Table (OBT) to name a few.

![](docs/img/data-modelling.png)
*Data modelling techniques on a normalization vs denormalization scale*

While the relevancy of dimensional modelling [has been debated by data practitioners](https://discourse.getdbt.com/t/is-kimball-dimensional-modeling-still-relevant-in-a-modern-data-warehouse/225/6), it is still one of the most widely adopted data modelling technique for analytics. 

Despite its popularity, resources on how to create dimensional models using dbt remain scarce and lack detail. This tutorial aims to solve this by providing the definitive guide to dimensional modelling with dbt. 

## Dimensional modelling

Dimensional modelling is a technique introduced by Ralph Kimball in 1996 with his book, [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/). 

The goal of dimensional modelling is to take raw data and transform it into Fact and Dimension tables that represent the business. 

![](docs/img/3nf-to-dimensional-model.png)

*Raw 3NF data to dimensional model*

The benefits of dimensional modelling are: 

- **Simpler data model for analytics**: Users of dimensional models do not need to perform complex joins when consuming a dimensional model for analytics. Performing joins between fact and dimension tables are made simple through the use of surrogate keys.
- [**Don’t repeat yourself**](https://docs.getdbt.com/terms/dry): Dimensions can be easily re-used with other fact tables to avoid duplication of effort and code logic. Reusable dimensions are referred to as conformed dimensions.
- **Faster data retrieval**: Analytical queries executed against a dimensional model are significantly faster than a 3NF model since data transformations like joins and aggregations have been already applied.
- **Close alignment with actual business processes**: Business processes and metrics are modelled and calculated as part of dimensional modelling. This helps ensure that the modelled data is easily usable.

Now that we understand the broad concepts and benefits of dimensional modelling, let’s get hands-on and create our first dimensional model using dbt. 

[Next &raquo;](docs/part01-setup-dbt-project.md)

## Environment setup

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/tutorials/3_kimball"

python -m venv env
source env/bin/activate
pip install -r requirements.txt

dbt --version
# Core:
#   - installed: 1.4.5 
#   - latest:    1.11.2 - Update available!
# 
#   Your version of dbt-core is out of date!
#   You can find instructions for upgrading here:
#   https://docs.getdbt.com/docs/installation
# 
# Plugins:
#   - postgres: 1.4.5 - Update available!
#   - duckdb:   1.4.1 - Update available!
```

## Run

```bash
cd "${GIT_ROOT}/tutorials/3_kimball/adventureworks"

# Install deps
dbt deps

# 22:47:51  Installing dbt-labs/dbt_utils
# 22:47:52    Installed from version 1.0.0
# 22:47:52    Updated version available: 1.3.3

# Seed duckdb 
dbt seed --target duckdb

# 22:48:25  Running with dbt=1.4.5
# 22:48:25  Unable to do partial parsing because saved manifest not found. Starting full parse.
# 22:48:26  Found 8 models, 42 tests, 0 snapshots, 0 analyses, 410 macros, 0 operations, 15 seed files, 0 sources, 0 exposures, 0 metrics
# 22:48:26  
# 22:48:26  Concurrency: 12 threads (target='duckdb')
# 22:48:26  
# 22:48:26  1 of 15 START seed file person.address ......................................... [RUN]
# 22:48:26  2 of 15 START seed file person.countryregion ................................... [RUN]
# 22:48:26  3 of 15 START seed file sales.creditcard ....................................... [RUN]
# 22:48:26  4 of 15 START seed file sales.customer ......................................... [RUN]
# 22:48:26  5 of 15 START seed file date.date .............................................. [RUN]
# 22:48:26  6 of 15 START seed file person.person .......................................... [RUN]
# 22:48:26  7 of 15 START seed file production.product ..................................... [RUN]
# 22:48:26  8 of 15 START seed file production.productcategory ............................. [RUN]
# 22:48:26  9 of 15 START seed file production.productsubcategory .......................... [RUN]
# 22:48:26  10 of 15 START seed file sales.salesorderdetail ................................ [RUN]
# 22:48:26  11 of 15 START seed file sales.salesorderheader ................................ [RUN]
# 22:48:26  12 of 15 START seed file sales.salesorderheadersalesreason ..................... [RUN]
# 22:48:30  8 of 15 OK loaded seed file production.productcategory ......................... [INSERT 4 in 4.30s]
# 22:48:31  13 of 15 START seed file sales.salesreason ..................................... [RUN]
# 22:48:49  13 of 15 OK loaded seed file sales.salesreason ................................. [INSERT 10 in 17.44s]
# 22:48:49  14 of 15 START seed file person.stateprovince .................................. [RUN]
# 22:48:52  14 of 15 OK loaded seed file person.stateprovince .............................. [INSERT 181 in 2.83s]
# 22:48:52  15 of 15 START seed file sales.store ........................................... [RUN]
# 22:48:52  15 of 15 OK loaded seed file sales.store ....................................... [INSERT 701 in 0.90s]
# 22:48:54  12 of 15 OK loaded seed file sales.salesorderheadersalesreason ................. [INSERT 1710 in 27.70s]
# 22:48:56  1 of 15 OK loaded seed file person.address ..................................... [INSERT 1675 in 30.62s]
# 22:49:16  7 of 15 OK loaded seed file production.product ................................. [INSERT 504 in 49.97s]
# 22:49:35  4 of 15 OK loaded seed file sales.customer ..................................... [INSERT 19820 in 69.36s]
# 22:49:44  9 of 15 OK loaded seed file production.productsubcategory ...................... [INSERT 37 in 78.17s]
# 22:49:44  11 of 15 OK loaded seed file sales.salesorderheader ............................ [INSERT 1566 in 78.35s]
# 22:50:00  3 of 15 OK loaded seed file sales.creditcard ................................... [INSERT 19118 in 94.20s]
# 22:50:11  2 of 15 OK loaded seed file person.countryregion ............................... [INSERT 238 in 105.07s]
# 22:50:11  10 of 15 OK loaded seed file sales.salesorderdetail ............................ [INSERT 5716 in 105.19s]
# 22:50:14  6 of 15 OK loaded seed file person.person ...................................... [INSERT 2057 in 108.61s]
# 22:50:15  5 of 15 OK loaded seed file date.date .......................................... [INSERT 731 in 108.97s]
# 22:50:15  
# 22:50:15  Finished running 15 seeds in 0 hours 1 minutes and 49.17 seconds (109.17s).
# 22:50:15  
# 22:50:15  Completed successfully
# 22:50:15  
# 22:50:15  Done. PASS=15 WARN=0 ERROR=0 SKIP=0 TOTAL=15
```

![Source Schema](docs/img/source-schema.png)

Let's open a DuckDB CLI and check our data, as shown below - `duckdb`:

```sql
ATTACH '/home/mdrrahman/dbt-demo/tutorials/3_kimball/adventureworks/target/adventureworks.duckdb' AS adventureworks;

SELECT * FROM adventureworks.sales.salesorderheader limit 3;

-- ┌──────────────┬──────────────┬─────────────────┬─────────────────────┬───┬───────────────┬────────────┬───────────────┬─────────────────────┬────────────────┐
-- │ salesorderid │ shipmethodid │ billtoaddressid │    modifieddate     │ … │   totaldue    │ customerid │ salespersonid │      shipdate       │ accountnumber  │
-- │    int32     │    int32     │      int32      │      timestamp      │   │ decimal(18,3) │   int32    │     int32     │      timestamp      │    varchar     │
-- ├──────────────┼──────────────┼─────────────────┼─────────────────────┼───┼───────────────┼────────────┼───────────────┼─────────────────────┼────────────────┤
-- │        43659 │            5 │             985 │ 2011-06-07 00:00:00 │ … │     23153.234 │      29825 │           279 │ 2011-06-07 00:00:00 │ 10-4020-000676 │
-- │        43660 │            5 │             921 │ 2011-06-07 00:00:00 │ … │      1457.329 │      29672 │           279 │ 2011-06-07 00:00:00 │ 10-4020-000117 │
-- │        43661 │            5 │             517 │ 2011-06-07 00:00:00 │ … │     36865.801 │      29734 │           282 │ 2011-06-07 00:00:00 │ 10-4020-000442 │
-- ├──────────────┴──────────────┴─────────────────┴─────────────────────┴───┴───────────────┴────────────┴───────────────┴─────────────────────┴────────────────┤
-- │ 3 rows                                                                                                                                 23 columns (9 shown) │
-- └─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

The Snowflake schema is as follows:

![Snowflake Schema](docs/img/snowflake-schema.png)

The STAR schema is as follows:

![STAR Schema](docs/img/star-schema.png)

And the DBT DAG:

![DBT DAG](docs/img/dbt-dag.png)

Here are the tables at this point:

```sql
SHOW ALL TABLES;

-- ┌────────────────┬────────────┬──────────────────────┬──────────────────────┬───────────────────────────────────────────────────────────────────────────────────────────┬───────────┐
-- │    database    │   schema   │         name         │     column_names     │                                       column_types                                        │ temporary │
-- │    varchar     │  varchar   │       varchar        │      varchar[]       │                                         varchar[]                                         │  boolean  │
-- ├────────────────┼────────────┼──────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────────────────────────────────────┼───────────┤
-- │ adventureworks │ date       │ date                 │ [date_day, prior_d…  │ [DATE, DATE, DATE, DATE, DATE, INTEGER, VARCHAR, INTEGER, INTEGER]                        │ false     │
-- │ adventureworks │ person     │ address              │ [addressid, addres…  │ [INTEGER, VARCHAR, VARCHAR, VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, TIMESTAMP]       │ false     │
-- │ adventureworks │ person     │ countryregion        │ [countryregioncode…  │ [VARCHAR, TIMESTAMP, VARCHAR]                                                             │ false     │
-- │ adventureworks │ person     │ person               │ [businessentityid,…  │ [INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, BOOLEAN, VARCHAR, TIMESTAMP, VAR…  │ false     │
-- │ adventureworks │ person     │ stateprovince        │ [stateprovinceid, …  │ [INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR, INTEGER, BOOLEAN, VARCHAR]                │ false     │
-- │ adventureworks │ production │ product              │ [productid, name, …  │ [INTEGER, VARCHAR, SMALLINT, BOOLEAN, VARCHAR, BOOLEAN, VARCHAR, SMALLINT, TIMESTAMP, V…  │ false     │
-- │ adventureworks │ production │ productcategory      │ [productcategoryid…  │ [INTEGER, VARCHAR, TIMESTAMP]                                                             │ false     │
-- │ adventureworks │ production │ productsubcategory   │ [productsubcategor…  │ [INTEGER, INTEGER, VARCHAR, TIMESTAMP]                                                    │ false     │
-- │ adventureworks │ sales      │ creditcard           │ [creditcardid, car…  │ [INTEGER, VARCHAR, SMALLINT, TIMESTAMP WITH TIME ZONE, SMALLINT, VARCHAR]                 │ false     │
-- │ adventureworks │ sales      │ customer             │ [customerid, perso…  │ [INTEGER, INTEGER, INTEGER, INTEGER]                                                      │ false     │
-- │ adventureworks │ sales      │ salesorderdetail     │ [salesorderid, ord…  │ [INTEGER, SMALLINT, INTEGER, 'DECIMAL(18,3)', INTEGER, TIMESTAMP, VARCHAR, INTEGER, 'DE…  │ false     │
-- │ adventureworks │ sales      │ salesorderheader     │ [salesorderid, shi…  │ [INTEGER, INTEGER, INTEGER, TIMESTAMP, VARCHAR, 'DECIMAL(18,3)', INTEGER, BOOLEAN, INTE…  │ false     │
-- │ adventureworks │ sales      │ salesorderheadersa…  │ [salesorderid, mod…  │ [INTEGER, TIMESTAMP, INTEGER]                                                             │ false     │
-- │ adventureworks │ sales      │ salesreason          │ [salesreasonid, na…  │ [INTEGER, VARCHAR, VARCHAR, TIMESTAMP]                                                    │ false     │
-- │ adventureworks │ sales      │ store                │ [businessentityid,…  │ [INTEGER, VARCHAR, INTEGER, TIMESTAMP]                                                    │ false     │
-- ├────────────────┴────────────┴──────────────────────┴──────────────────────┴───────────────────────────────────────────────────────────────────────────────────────────┴───────────┤
-- │ 15 rows                                                                                                                                                                 6 columns │
-- └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

Build the model:

```bash
dbt run

# 22:56:20  1 of 8 START sql table model marts.dim_address ................................. [RUN]
# 22:56:20  2 of 8 START sql table model marts.dim_credit_card ............................. [RUN]
# 22:56:20  3 of 8 START sql table model marts.dim_customer ................................ [RUN]
# 22:56:20  4 of 8 START sql table model marts.dim_date .................................... [RUN]
# 22:56:20  5 of 8 START sql table model marts.dim_order_status ............................ [RUN]
# 22:56:20  6 of 8 START sql table model marts.dim_product ................................. [RUN]
# 22:56:20  7 of 8 START sql table model marts.fct_sales ................................... [RUN]
# 22:56:21  5 of 8 OK created sql table model marts.dim_order_status ....................... [OK in 0.18s]
# 22:56:21  2 of 8 OK created sql table model marts.dim_credit_card ........................ [OK in 0.18s]
# 22:56:21  4 of 8 OK created sql table model marts.dim_date ............................... [OK in 0.19s]
# 22:56:21  6 of 8 OK created sql table model marts.dim_product ............................ [OK in 0.19s]
# 22:56:21  1 of 8 OK created sql table model marts.dim_address ............................ [OK in 0.20s]
# 22:56:21  3 of 8 OK created sql table model marts.dim_customer ........................... [OK in 0.20s]
# 22:56:21  7 of 8 OK created sql table model marts.fct_sales .............................. [OK in 0.27s]
# 22:56:21  8 of 8 START sql table model marts.obt_sales ................................... [RUN]
# 22:56:21  8 of 8 OK created sql table model marts.obt_sales .............................. [OK in 0.17s]
# 22:56:21  
# 22:56:21  Finished running 8 table models in 0 hours 0 minutes and 0.61 seconds (0.61s).
# 22:56:21  
# 22:56:21  Completed successfully

dbt test

# 22:56:33  Running with dbt=1.4.5
# 22:56:33  Found 8 models, 42 tests, 0 snapshots, 0 analyses, 410 macros, 0 operations, 15 seed files, 0 sources, 0 exposures, 0 metrics
# 22:56:33  
# 22:56:33  Concurrency: 12 threads (target='duckdb')
# 22:56:33  
# 22:56:33  1 of 42 START test not_null_dim_address_address_key ............................ [RUN]
# 22:56:33  2 of 42 START test not_null_dim_address_addressid .............................. [RUN]
# 22:56:33  3 of 42 START test not_null_dim_credit_card_cardtype ........................... [RUN]
# 22:56:33  4 of 42 START test not_null_dim_credit_card_creditcard_key ..................... [RUN]
# 22:56:33  5 of 42 START test not_null_dim_credit_card_creditcardid ....................... [RUN]
# 22:56:33  6 of 42 START test not_null_dim_customer_customer_key .......................... [RUN]
# 22:56:33  7 of 42 START test not_null_dim_customer_customerid ............................ [RUN]
# 22:56:33  8 of 42 START test not_null_dim_date_date_day .................................. [RUN]
# 22:56:33  9 of 42 START test not_null_dim_date_date_key .................................. [RUN]
# 22:56:33  10 of 42 START test not_null_dim_order_status_order_status ..................... [RUN]
# 22:56:33  11 of 42 START test not_null_dim_order_status_order_status_key ................. [RUN]
# 22:56:33  12 of 42 START test not_null_dim_product_product_key ........................... [RUN]
# 22:56:33  1 of 42 PASS not_null_dim_address_address_key .................................. [PASS in 0.12s]
# 22:56:33  2 of 42 PASS not_null_dim_address_addressid .................................... [PASS in 0.12s]
# 22:56:33  4 of 42 PASS not_null_dim_credit_card_creditcard_key ........................... [PASS in 0.12s]
# 22:56:33  5 of 42 PASS not_null_dim_credit_card_creditcardid ............................. [PASS in 0.12s]
# 22:56:33  6 of 42 PASS not_null_dim_customer_customer_key ................................ [PASS in 0.12s]
# 22:56:33  3 of 42 PASS not_null_dim_credit_card_cardtype ................................. [PASS in 0.12s]
# 22:56:33  7 of 42 PASS not_null_dim_customer_customerid .................................. [PASS in 0.12s]
# 22:56:33  8 of 42 PASS not_null_dim_date_date_day ........................................ [PASS in 0.12s]
# 22:56:33  9 of 42 PASS not_null_dim_date_date_key ........................................ [PASS in 0.12s]
# 22:56:33  11 of 42 PASS not_null_dim_order_status_order_status_key ....................... [PASS in 0.12s]
# 22:56:33  10 of 42 PASS not_null_dim_order_status_order_status ........................... [PASS in 0.12s]
# 22:56:33  12 of 42 PASS not_null_dim_product_product_key ................................. [PASS in 0.12s]
# 22:56:33  13 of 42 START test not_null_dim_product_product_name .......................... [RUN]
# 22:56:33  14 of 42 START test not_null_dim_product_productid ............................. [RUN]
# 22:56:33  15 of 42 START test not_null_fct_sales_customer_key ............................ [RUN]
# 22:56:33  16 of 42 START test not_null_fct_sales_order_date_key .......................... [RUN]
# 22:56:33  17 of 42 START test not_null_fct_sales_order_status_key ........................ [RUN]
# 22:56:33  18 of 42 START test not_null_fct_sales_orderqty ................................ [RUN]
# 22:56:33  19 of 42 START test not_null_fct_sales_product_key ............................. [RUN]
# 22:56:33  20 of 42 START test not_null_fct_sales_sales_key ............................... [RUN]
# 22:56:33  21 of 42 START test not_null_fct_sales_salesorderdetailid ...................... [RUN]
# 22:56:33  22 of 42 START test not_null_fct_sales_salesorderid ............................ [RUN]
# 22:56:33  23 of 42 START test not_null_fct_sales_ship_address_key ........................ [RUN]
# 22:56:33  24 of 42 START test not_null_fct_sales_unitprice ............................... [RUN]
# 22:56:33  13 of 42 PASS not_null_dim_product_product_name ................................ [PASS in 0.10s]
# 22:56:33  14 of 42 PASS not_null_dim_product_productid ................................... [PASS in 0.10s]
# 22:56:33  15 of 42 PASS not_null_fct_sales_customer_key .................................. [PASS in 0.10s]
# 22:56:33  16 of 42 PASS not_null_fct_sales_order_date_key ................................ [PASS in 0.10s]
# 22:56:33  17 of 42 PASS not_null_fct_sales_order_status_key .............................. [PASS in 0.10s]
# 22:56:33  20 of 42 PASS not_null_fct_sales_sales_key ..................................... [PASS in 0.10s]
# 22:56:33  18 of 42 PASS not_null_fct_sales_orderqty ...................................... [PASS in 0.10s]
# 22:56:33  22 of 42 PASS not_null_fct_sales_salesorderid .................................. [PASS in 0.10s]
# 22:56:33  19 of 42 PASS not_null_fct_sales_product_key ................................... [PASS in 0.10s]
# 22:56:33  21 of 42 PASS not_null_fct_sales_salesorderdetailid ............................ [PASS in 0.10s]
# 22:56:33  24 of 42 PASS not_null_fct_sales_unitprice ..................................... [PASS in 0.10s]
# 22:56:33  23 of 42 PASS not_null_fct_sales_ship_address_key .............................. [PASS in 0.10s]
# 22:56:33  25 of 42 START test not_null_obt_sales_orderqty ................................ [RUN]
# 22:56:33  26 of 42 START test not_null_obt_sales_sales_key ............................... [RUN]
# 22:56:33  27 of 42 START test not_null_obt_sales_salesorderdetailid ...................... [RUN]
# 22:56:33  28 of 42 START test not_null_obt_sales_salesorderid ............................ [RUN]
# 22:56:33  29 of 42 START test not_null_obt_sales_unitprice ............................... [RUN]
# 22:56:33  30 of 42 START test unique_dim_address_address_key ............................. [RUN]
# 22:56:33  31 of 42 START test unique_dim_address_addressid ............................... [RUN]
# 22:56:33  32 of 42 START test unique_dim_credit_card_creditcardid ........................ [RUN]
# 22:56:33  33 of 42 START test unique_dim_customer_customer_key ........................... [RUN]
# 22:56:33  34 of 42 START test unique_dim_customer_customerid ............................. [RUN]
# 22:56:33  35 of 42 START test unique_dim_date_date_day ................................... [RUN]
# 22:56:33  36 of 42 START test unique_dim_date_date_key ................................... [RUN]
# 22:56:34  26 of 42 PASS not_null_obt_sales_sales_key ..................................... [PASS in 0.11s]
# 22:56:34  29 of 42 PASS not_null_obt_sales_unitprice ..................................... [PASS in 0.11s]
# 22:56:34  28 of 42 PASS not_null_obt_sales_salesorderid .................................. [PASS in 0.11s]
# 22:56:34  25 of 42 PASS not_null_obt_sales_orderqty ...................................... [PASS in 0.11s]
# 22:56:34  30 of 42 PASS unique_dim_address_address_key ................................... [PASS in 0.11s]
# 22:56:34  27 of 42 PASS not_null_obt_sales_salesorderdetailid ............................ [PASS in 0.11s]
# 22:56:34  31 of 42 PASS unique_dim_address_addressid ..................................... [PASS in 0.11s]
# 22:56:34  32 of 42 PASS unique_dim_credit_card_creditcardid .............................. [PASS in 0.11s]
# 22:56:34  35 of 42 PASS unique_dim_date_date_day ......................................... [PASS in 0.11s]
# 22:56:34  36 of 42 PASS unique_dim_date_date_key ......................................... [PASS in 0.10s]
# 22:56:34  33 of 42 PASS unique_dim_customer_customer_key ................................. [PASS in 0.11s]
# 22:56:34  37 of 42 START test unique_dim_order_status_order_status ....................... [RUN]
# 22:56:34  34 of 42 PASS unique_dim_customer_customerid ................................... [PASS in 0.12s]
# 22:56:34  38 of 42 START test unique_dim_order_status_order_status_key ................... [RUN]
# 22:56:34  39 of 42 START test unique_dim_product_product_key ............................. [RUN]
# 22:56:34  40 of 42 START test unique_dim_product_productid ............................... [RUN]
# 22:56:34  41 of 42 START test unique_fct_sales_sales_key ................................. [RUN]
# 22:56:34  42 of 42 START test unique_obt_sales_sales_key ................................. [RUN]
# 22:56:34  37 of 42 PASS unique_dim_order_status_order_status ............................. [PASS in 0.06s]
# 22:56:34  38 of 42 PASS unique_dim_order_status_order_status_key ......................... [PASS in 0.06s]
# 22:56:34  40 of 42 PASS unique_dim_product_productid ..................................... [PASS in 0.06s]
# 22:56:34  41 of 42 PASS unique_fct_sales_sales_key ....................................... [PASS in 0.06s]
# 22:56:34  39 of 42 PASS unique_dim_product_product_key ................................... [PASS in 0.06s]
# 22:56:34  42 of 42 PASS unique_obt_sales_sales_key ....................................... [PASS in 0.07s]
# 22:56:34  
# 22:56:34  Finished running 42 tests in 0 hours 0 minutes and 0.54 seconds (0.54s).
# 22:56:34  
# 22:56:34  Completed successfully
# 22:56:34  
# 22:56:34  Done. PASS=42 WARN=0 ERROR=0 SKIP=0 TOTAL=42
```

Here are the tables at this point:

```sql
SHOW ALL TABLES;

-- ┌────────────────┬────────────┬──────────────────────┬──────────────────────┬──────────────────────────────────────────────────────────┬───────────┐
-- │    database    │   schema   │         name         │     column_names     │                       column_types                       │ temporary │
-- │    varchar     │  varchar   │       varchar        │      varchar[]       │                        varchar[]                         │  boolean  │
-- ├────────────────┼────────────┼──────────────────────┼──────────────────────┼──────────────────────────────────────────────────────────┼───────────┤
-- │ adventureworks │ date       │ date                 │ [date_day, prior_d…  │ [DATE, DATE, DATE, DATE, DATE, INTEGER, VARCHAR, INTEG…  │ false     │
-- │ adventureworks │ marts      │ dim_address          │ [address_key, addr…  │ [VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR]            │ false     │
-- │ adventureworks │ marts      │ dim_credit_card      │ [creditcard_key, c…  │ [VARCHAR, INTEGER, VARCHAR]                              │ false     │
-- │ adventureworks │ marts      │ dim_customer         │ [customer_key, cus…  │ [VARCHAR, INTEGER, INTEGER, VARCHAR, INTEGER, VARCHAR]   │ false     │
-- │ adventureworks │ marts      │ dim_date             │ [date_key, date_da…  │ [VARCHAR, DATE, DATE, DATE, DATE, DATE, INTEGER, VARCH…  │ false     │
-- │ adventureworks │ marts      │ dim_order_status     │ [order_status_key,…  │ [VARCHAR, SMALLINT, VARCHAR]                             │ false     │
-- │ adventureworks │ marts      │ dim_product          │ [product_key, prod…  │ [VARCHAR, INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR,…  │ false     │
-- │ adventureworks │ marts      │ fct_sales            │ [sales_key, produc…  │ [VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,…  │ false     │
-- │ adventureworks │ marts      │ obt_sales            │ [sales_key, saleso…  │ [VARCHAR, INTEGER, INTEGER, 'DECIMAL(18,3)', SMALLINT,…  │ false     │
-- │ adventureworks │ person     │ address              │ [addressid, addres…  │ [INTEGER, VARCHAR, VARCHAR, VARCHAR, INTEGER, VARCHAR,…  │ false     │
-- │ adventureworks │ person     │ countryregion        │ [countryregioncode…  │ [VARCHAR, TIMESTAMP, VARCHAR]                            │ false     │
-- │ adventureworks │ person     │ person               │ [businessentityid,…  │ [INTEGER, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR,…  │ false     │
-- │ adventureworks │ person     │ stateprovince        │ [stateprovinceid, …  │ [INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR, INTEGE…  │ false     │
-- │ adventureworks │ production │ product              │ [productid, name, …  │ [INTEGER, VARCHAR, SMALLINT, BOOLEAN, VARCHAR, BOOLEAN…  │ false     │
-- │ adventureworks │ production │ productcategory      │ [productcategoryid…  │ [INTEGER, VARCHAR, TIMESTAMP]                            │ false     │
-- │ adventureworks │ production │ productsubcategory   │ [productsubcategor…  │ [INTEGER, INTEGER, VARCHAR, TIMESTAMP]                   │ false     │
-- │ adventureworks │ sales      │ creditcard           │ [creditcardid, car…  │ [INTEGER, VARCHAR, SMALLINT, TIMESTAMP WITH TIME ZONE,…  │ false     │
-- │ adventureworks │ sales      │ customer             │ [customerid, perso…  │ [INTEGER, INTEGER, INTEGER, INTEGER]                     │ false     │
-- │ adventureworks │ sales      │ salesorderdetail     │ [salesorderid, ord…  │ [INTEGER, SMALLINT, INTEGER, 'DECIMAL(18,3)', INTEGER,…  │ false     │
-- │ adventureworks │ sales      │ salesorderheader     │ [salesorderid, shi…  │ [INTEGER, INTEGER, INTEGER, TIMESTAMP, VARCHAR, 'DECIM…  │ false     │
-- │ adventureworks │ sales      │ salesorderheadersa…  │ [salesorderid, mod…  │ [INTEGER, TIMESTAMP, INTEGER]                            │ false     │
-- │ adventureworks │ sales      │ salesreason          │ [salesreasonid, na…  │ [INTEGER, VARCHAR, VARCHAR, TIMESTAMP]                   │ false     │
-- │ adventureworks │ sales      │ store                │ [businessentityid,…  │ [INTEGER, VARCHAR, INTEGER, TIMESTAMP]                   │ false     │
-- ├────────────────┴────────────┴──────────────────────┴──────────────────────┴──────────────────────────────────────────────────────────┴───────────┤
-- │ 23 rows                                                                                                                                6 columns │
-- └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

And we can see the DBT DAG for `obt_sales`:

```bash
dbt docs generate
dbt docs serve
```