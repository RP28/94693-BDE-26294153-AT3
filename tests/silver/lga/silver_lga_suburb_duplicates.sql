SELECT
    lga_code,
    lga_name,
    suburb_name,
    COUNT(*) AS row_count
FROM {{ ref('silver_lga_suburb') }}
GROUP BY
    lga_code,
    lga_name,
    suburb_name
HAVING COUNT(*) > 1