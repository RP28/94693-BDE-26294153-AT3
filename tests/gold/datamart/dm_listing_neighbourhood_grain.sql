select
    listing_neighbourhood,
    month_year,
    count(*) as row_count
from {{ ref('dm_listing_neighbourhood') }}
group by
    listing_neighbourhood,
    month_year
having count(*) > 1