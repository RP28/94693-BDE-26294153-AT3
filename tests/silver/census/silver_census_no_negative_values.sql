with census_values as (
    select
        'silver_census_g01' as table_name,
        t.lga_code,
        j.key as column_name,
        nullif(j.value, '')::numeric as numeric_value
    from {{ ref('silver_census_g01') }} t
    cross join lateral jsonb_each_text(
        to_jsonb(t) - 'lga_code'
    ) j
    union all
    select
        'silver_census_g02' as table_name,
        t.lga_code,
        j.key as column_name,
        nullif(j.value, '')::numeric as numeric_value
    from {{ ref('silver_census_g02') }} t
    cross join lateral jsonb_each_text(
        to_jsonb(t) - 'lga_code'
    ) j
)
select
    table_name,
    lga_code,
    column_name,
    numeric_value
from census_values
where numeric_value < 0