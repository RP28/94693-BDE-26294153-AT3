select 1
where (
    select count(*)
    from {{ ref('silver_lga_suburb') }}
) <> (
    select count(*)
    from {{ source('bronze', 'raw_lga_suburb') }}
)