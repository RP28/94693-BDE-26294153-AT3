select
    host_neighbourhood_lga,
    month_year,
    count(*) as row_count
from {{ ref('dm_host_neighbourhood') }}
group by
    host_neighbourhood_lga,
    month_year
having count(*) > 1