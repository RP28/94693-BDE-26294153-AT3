select 1
where
    (select count(*) from {{ ref('fact_listing') }})
    <>
    (select count(*) from {{ ref('silver_listings') }})