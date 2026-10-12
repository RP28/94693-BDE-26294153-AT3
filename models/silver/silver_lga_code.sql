with source as (
    select * from {{ source('bronze', 'raw_lga_code') }}
),
cleaned as (
    select
        nullif(trim(lga_code), '') as lga_code,
        upper(nullif(trim(lga_name), '')) as lga_name
    from source
)
select * from cleaned