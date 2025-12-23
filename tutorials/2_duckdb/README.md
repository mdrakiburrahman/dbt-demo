# DBT with DuckDB

* [Website snapshot](https://web.archive.org/web/20251014064901/https://www.startdataengineering.com/post/dbt-data-build-tool-tutorial/)
* [Code snapshot](https://github.com/josephmachado/simple_dbt_project/tree/345ef554396e55476ec41dc5b62b3da0fc074ccc)

![Data Flow](.imgs/data_flow.png)

## Environment setup

```bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "${GIT_ROOT}/tutorials/2_duckdb"

rm -rf .venv
uv python install 3.13
uv venv --python 3.13
uv sync
source .venv/bin/activate
```

## Run dbt 

Run dbt commands as shown below:

```bash
dbt clean
dbt deps
dbt snapshot
dbt run
dbt test
dbt docs generate
dbt docs serve
```

Go to [http://localhost:8080](http://localhost:8080) to see the dbt documentation. If you are running this on GitHub CodeSpaces, follow [this section]() to expose port 8080 for access from your browser.

Press `Ctrl + C` to stop the document server.

## Query in DuckDB

```bash
# Start UI
duckdb -ui

# ┌────────────────────────────────────────────┐
# │                   result                   │
# │                  varchar                   │
# ├────────────────────────────────────────────┤
# │ Navigate browser to http://localhost:4213/ │
# └────────────────────────────────────────────┘
```

> Create/attach a database at /home/mdrrahman/dbt-demo/tutorials/2_duckdb/dbt.duckdb

![DuckDB UI](.imgs/duckdb_ui.png)

## Create snapshots

Let's do some testing, Insert some data into source customer table(in our case the new_customer data is appended into customers.csv), to demonstrate dbt snapshots. Since we are using duckdb and the base table is essentially data at [customer.csv](./raw_data/customer.csv) we have to append new data to this customer.csv file as shown below:

```bash
# Remove header from ./raw_data/customers_new.csv
# and append it to ./raw_data/customers.csv
echo "" >> ./raw_data/customers.csv
tail -n +2 ./raw_data/customer_new.csv >> ./raw_data/customers.csv

# NOTE: Windows users need to do this manually or via powershell as
```

Run snapshot and create models again.

```bash
dbt snapshot 
dbt run 
```

```bash
# reset customers.csv
head -n -5 ./raw_data/customers.csv > temp
cat temp > ./raw_data/customers.csv 
rm temp
```

Let's open a python REPL and check our data, as shown below:

```python
import duckdb
con = duckdb.connect("dbt.duckdb")
results = con.execute("select * from snapshots.customers_snapshot where customer_id = 82").fetchall()
for row in results:
    print(row)
# NOTE: You will see 2 rows printed
exit()
```

