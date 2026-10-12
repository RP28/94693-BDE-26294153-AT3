select
    listing_id,
    source_month,
    count(*) as row_count
from {{ ref('silver_listings') }}
group by
    listing_id,
    source_month
having count(*) > 1