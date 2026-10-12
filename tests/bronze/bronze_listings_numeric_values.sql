WITH values AS (
    SELECT
        j.key AS column_name,
        NULLIF(TRIM(j.value #>> '{}'), '') AS value
    FROM {{ source('bronze', 'raw_listings') }} t
    CROSS JOIN LATERAL jsonb_each(to_jsonb(t)) j
    WHERE j.key IN (
        'listing_id',
        'scrape_id',
        'host_id',
        'accommodates',
        'price',
        'availability_30',
        'number_of_reviews',
        'review_scores_rating',
        'review_scores_accuracy',
        'review_scores_cleanliness',
        'review_scores_checkin',
        'review_scores_communication',
        'review_scores_value'
    )
)
SELECT *
FROM values
WHERE value IS NOT NULL
  AND value !~ '^-?[0-9]+(\.[0-9]+)?$'