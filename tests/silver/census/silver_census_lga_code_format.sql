select
    lga_code,
    'silver_census_g01' as model_name
from {{ ref('silver_census_g01') }}
where lga_code !~ '^[0-9]{5}$'
union all
select
    lga_code,
    'silver_census_g02' as model_name
from {{ ref('silver_census_g02') }}
where lga_code !~ '^[0-9]{5}$'