with source as (
    select * from {{ source('bronze', 'raw_lga_suburb') }}
),
lga_codes as (
    select * from {{ ref('silver_lga_code') }}
),
cleaned as (
    select
        c.lga_code,
        upper(nullif(trim(s.lga_name), '')) as lga_name,
        upper(nullif(trim(s.suburb_name), '')) as suburb_name
    from source s
    left join lga_codes c
        on upper(nullif(trim(s.lga_name), '')) = c.lga_name
)
select * from cleaned