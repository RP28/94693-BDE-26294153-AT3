with values as (
    select
        j.key as column_name,
        nullif(trim(j.value #>> '{}'), '') as value
    from {{ source('bronze', 'raw_census_g01') }} t
    cross join lateral jsonb_each(to_jsonb(t)) j
    where j.key <> 'lga_code_2016'
)
select *
from values
where value is not null
  and value !~ '^[0-9]+$'