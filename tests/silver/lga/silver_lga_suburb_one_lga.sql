SELECT
    suburb_name,
    COUNT(DISTINCT lga_code) AS lga_count
FROM {{ ref('silver_lga_suburb') }}
GROUP BY suburb_name
HAVING COUNT(DISTINCT lga_code) > 1