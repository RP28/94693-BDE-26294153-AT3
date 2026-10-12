with source as (
    select * from {{ ref('silver_listings') }}
),
transformed as (
    select distinct
        (
            extract(year from source_month)::integer * 100
            + extract(month from source_month)::integer
        ) as month_key,
        source_month as month_start,
        extract(year from source_month)::integer as year,
        extract(month from source_month)::integer as month_number,
        to_char(source_month, 'Month') as month_name,
        to_char(source_month, 'YYYY-MM') as month_year
    from source
)
select * from transformed