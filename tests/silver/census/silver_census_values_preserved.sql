with bronze_values as (
    select
        'g01' as dataset,
        regexp_replace(
            upper(trim(b.lga_code_2016)),
            '^LGA',
            ''
        ) as lga_code,
        j.key as column_name,
        nullif(
            trim(j.value),
            ''
        )::numeric as numeric_value
    from {{ source('bronze', 'raw_census_g01') }} b
    cross join lateral jsonb_each_text(
        to_jsonb(b) - 'lga_code_2016'
    ) j
    union all
    select
        'g02' as dataset,
        regexp_replace(
            upper(trim(b.lga_code_2016)),
            '^LGA',
            ''
        ) as lga_code,
        j.key as column_name,
        nullif(
            trim(j.value),
            ''
        )::numeric as numeric_value
    from {{ source('bronze', 'raw_census_g02') }} b
    cross join lateral jsonb_each_text(
        to_jsonb(b) - 'lga_code_2016'
    ) j
),
silver_values as (
    select
        'g01' as dataset,
        s.lga_code,
        j.key as column_name,
        nullif(j.value, '')::numeric as numeric_value
    from {{ ref('silver_census_g01') }} s
    cross join lateral jsonb_each_text(
        to_jsonb(s) - 'lga_code'
    ) j
    union all
    select
        'g02' as dataset,
        s.lga_code,
        j.key as column_name,
        nullif(j.value, '')::numeric as numeric_value
    from {{ ref('silver_census_g02') }} s
    cross join lateral jsonb_each_text(
        to_jsonb(s) - 'lga_code'
    ) j
)
select
    coalesce(b.dataset, s.dataset) as dataset,
    coalesce(b.lga_code, s.lga_code) as lga_code,
    coalesce(b.column_name, s.column_name) as column_name,
    b.numeric_value as bronze_value,
    s.numeric_value as silver_value
from bronze_values b
full outer join silver_values s
    on b.dataset = s.dataset
   and b.lga_code = s.lga_code
   and b.column_name = s.column_name
where
       b.lga_code is null
    or s.lga_code is null
    or b.column_name is null
    or s.column_name is null
    or b.numeric_value is distinct from s.numeric_value