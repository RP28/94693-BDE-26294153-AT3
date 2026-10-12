with null_values as (
    select
        'silver_census_g01' as table_name,
        t.lga_code,
        j.key as column_name
    from {{ ref('silver_census_g01') }} t
    cross join lateral jsonb_each(
        to_jsonb(t)
    ) j
    where j.value = 'null'::jsonb
    union all
    select
        'silver_census_g02' as table_name,
        t.lga_code,
        j.key as column_name
    from {{ ref('silver_census_g02') }} t
    cross join lateral jsonb_each(
        to_jsonb(t)
    ) j
    where j.value = 'null'::jsonb
)
select * from null_values