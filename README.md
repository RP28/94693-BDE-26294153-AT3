# Big Data Engineering – AT3

A **dbt project** for transforming Sydney Airbnb listings and Australian Census data into a PostgreSQL analytical data warehouse using a Silver–Gold architecture.

## Project Structure

```text
├── models/
│   ├── silver/         # Cleaning, type conversions and entity models
│   ├── gold/
│   │   ├── dimensions/ # Host, Property, LGA, Suburb, Month
│   │   ├── facts/      # Monthly listing fact table
│   │   ├── reference/  # Census G01 and G02
│   │   └── datamart/   # Analytical views
│   └── sources.yml     # Bronze source definitions
├── snapshots/           # Host and Property SCD Type 2
├── tests/               # Custom SQL data quality tests
├── macros/              # Custom macros and generic tests
└── dbt_project.yml
```

## Implementation

- **Silver:** Cleans and standardises raw Airbnb, Census and LGA data from PostgreSQL Bronze tables.
- **Snapshots:** Tracks historical changes in Host and Property dimensions using timestamp-based SCD Type 2 snapshots.
- **Gold:** Builds a dimensional warehouse with five dimensions, a monthly listing fact table and two Census reference tables.
- **Datamarts:** Provides monthly performance metrics grouped by listing neighbourhood, property configuration and host neighbourhood.
- **Data Quality:** Uses dbt schema tests, custom SQL tests and macros to validate source data, relationships, historical consistency and analytical metrics.

## Execution

Configure a PostgreSQL connection through the dbt profile and run:

```bash
dbt build --no-partial-parse
```

For an initial historical load, process source months chronologically and execute `dbt build --no-partial-parse` after each monthly ingestion to preserve SCD Type 2 history.

The project is designed to work with Bronze data ingested through an Apache Airflow pipeline.