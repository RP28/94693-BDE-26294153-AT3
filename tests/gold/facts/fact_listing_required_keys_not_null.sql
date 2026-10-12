select
    listing_id,
    month_key,
    property_key,
    host_key
from {{ ref('fact_listing') }}
where property_key is null
   or host_key is null
   or month_key is null