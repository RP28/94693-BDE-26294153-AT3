with values as (
    select
        j.key as column_name,
        nullif(trim(j.value #>> '{}'), '') as value
    from {{ source('bronze', 'raw_listings') }} t
    cross join lateral jsonb_each(to_jsonb(t)) j
    where j.key in (
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
select *
from values
where value is not null
  and value !~ '^-?[0-9]+(\.[0-9]+)?$'