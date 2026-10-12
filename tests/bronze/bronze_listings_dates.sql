select
    listing_id,
    scraped_date,
    host_since
from {{ source('bronze', 'raw_listings') }}
where (
        nullif(trim(scraped_date), '') is not null
        and trim(scraped_date) !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      )
   or (
        nullif(trim(host_since), '') is not null
        and trim(host_since) !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
      )