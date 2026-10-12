select
    listing_id,
    month_key,
    count(*) as row_count
from {{ ref('fact_listing') }}
group by
    listing_id,
    month_key
having count(*) > 1