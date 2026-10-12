with silver_count as (
    select count(*) as row_count from {{ ref('silver_listings') }}
),
fact_count as (
    select count(*) as row_count from {{ ref('fact_listing') }}
)
select
    s.row_count as silver_row_count,
    f.row_count as fact_row_count
from silver_count s
cross join fact_count f
where s.row_count <> f.row_count