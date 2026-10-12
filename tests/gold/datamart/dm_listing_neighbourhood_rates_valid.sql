select
    listing_neighbourhood,
    month_year,
    active_listing_rate,
    superhost_rate
from {{ ref('dm_listing_neighbourhood') }}
where active_listing_rate < 0
   or active_listing_rate > 100
   or superhost_rate < 0
   or superhost_rate > 100