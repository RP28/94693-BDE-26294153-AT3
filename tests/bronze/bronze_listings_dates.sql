SELECT
    listing_id,
    scraped_date,
    host_since
FROM {{ source('bronze', 'raw_listings') }}
WHERE (
        NULLIF(TRIM(scraped_date), '') IS NOT NULL
        AND TRIM(scraped_date) !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      )
   OR (
        NULLIF(TRIM(host_since), '') IS NOT NULL
        AND TRIM(host_since) !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
      )