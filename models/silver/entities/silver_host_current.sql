with source as (
    select * from {{ ref('silver_listings') }}
),
lga_suburbs as (
    select * from {{ ref('silver_lga_suburb') }}
),
latest_batch as (
    select max(source_month) as source_month from source
),
current_batch as (
    select s.* from source s
    inner join latest_batch b
        on s.source_month = b.source_month
),
resolved as (
    select distinct
        c.host_id,
        c.host_name,
        c.host_since,
        c.host_is_superhost,
        c.host_neighbourhood,
        s.lga_code as host_lga_code,
        c.source_month
    from current_batch c
    left join lga_suburbs s
        on upper(trim(c.host_neighbourhood)) = s.suburb_name
)
select * from resolved