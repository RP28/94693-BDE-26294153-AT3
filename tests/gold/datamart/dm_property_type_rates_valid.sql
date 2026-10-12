select
    property_type,
    room_type,
    accommodates,
    month_year,
    active_listing_rate,
    superhost_rate
from {{ ref('dm_property_type') }}
where active_listing_rate < 0
   or active_listing_rate > 100
   or superhost_rate < 0
   or superhost_rate > 100