select 1
where (
    select count(*)
    from {{ ref('silver_lga_code') }}
) <> (
    select count(*)
    from {{ source('bronze', 'raw_lga_code') }}
)