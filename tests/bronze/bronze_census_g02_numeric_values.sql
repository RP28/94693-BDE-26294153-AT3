WITH values AS (
    SELECT
        j.key AS column_name,
        NULLIF(TRIM(j.value #>> '{}'), '') AS value
    FROM {{ source('bronze', 'raw_census_g02') }} t
    CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) j
    WHERE j.key <> 'lga_code_2016'
)
SELECT *
FROM values
WHERE value IS NOT NULL
  AND value !~ '^-?[0-9]+(\.[0-9]+)?$'