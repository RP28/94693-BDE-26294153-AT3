with source as (
    select * from {{ ref('silver_lga_code') }}
),
transformed as (
    select
        lga_code,
        lga_name
    from source
)
select * from transformed