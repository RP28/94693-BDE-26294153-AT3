SELECT 1
WHERE (
    SELECT COUNT(*)
    FROM {{ ref('silver_listings') }}
) <> (
    SELECT COUNT(*)
    FROM {{ source('bronze', 'raw_listings') }}
)