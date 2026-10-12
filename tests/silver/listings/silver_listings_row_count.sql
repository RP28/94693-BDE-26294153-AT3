select 1
where (
    select count(*)
    from {{ ref('silver_listings') }}
) <> (
    select count(*)
    from {{ source('bronze', 'raw_listings') }}
)