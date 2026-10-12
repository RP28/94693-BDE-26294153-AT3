with g01_only as (
    select lga_code
    from {{ ref('silver_census_g01') }}
    except
    select lga_code
    from {{ ref('silver_census_g02') }}
),
g02_only as (
    select lga_code
    from {{ ref('silver_census_g02') }}
    except
    select lga_code
    from {{ ref('silver_census_g01') }}
)
select
    lga_code,
    'g01_only' as issue
from g01_only
union all
select
    lga_code,
    'g02_only' as issue
from g02_only