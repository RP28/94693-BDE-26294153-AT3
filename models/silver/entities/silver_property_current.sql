with source as (
    select * from {{ ref('silver_listings') }}
),
lga_codes as (
    select * from {{ ref('silver_lga_code') }}
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
        c.listing_id,
        c.listing_neighbourhood,
        g.lga_code as listing_lga_code,
        c.property_type,
        c.room_type,
        c.accommodates,
        c.source_month
    from current_batch c
    left join lga_codes g
        on upper(trim(c.listing_neighbourhood)) = g.lga_name
)
select * from resolved