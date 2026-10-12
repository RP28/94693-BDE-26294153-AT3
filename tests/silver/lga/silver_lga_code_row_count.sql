SELECT 1
WHERE (
    SELECT COUNT(*)
    FROM {{ ref('silver_lga_code') }}
) <> (
    SELECT COUNT(*)
    FROM {{ source('bronze', 'raw_lga_code') }}
)