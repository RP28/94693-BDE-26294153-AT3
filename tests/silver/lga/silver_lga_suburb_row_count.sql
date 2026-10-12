SELECT 1
WHERE (
    SELECT COUNT(*)
    FROM {{ ref('silver_lga_suburb') }}
) <> (
    SELECT COUNT(*)
    FROM {{ source('bronze', 'raw_lga_suburb') }}
)