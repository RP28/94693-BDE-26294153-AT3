select 1
where (
    select count(*)
    from {{ ref('silver_census_g01') }}
) <> (
    select count(*)
    from {{ source('bronze', 'raw_census_g01') }}
)