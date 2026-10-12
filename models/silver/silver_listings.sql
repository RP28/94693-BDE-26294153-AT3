with source as (
    select * from {{ source('bronze', 'raw_listings') }}
),
cleaned as (
    select
        nullif(trim(listing_id), '')::bigint as listing_id,
        nullif(trim(scrape_id), '')::bigint as scrape_id,
        nullif(trim(scraped_date), '')::date as scraped_date,
        nullif(trim(source_month), '')::date as source_month,
        nullif(trim(host_id), '')::bigint as host_id,
        nullif(trim(host_name), '') as host_name,
        to_date(nullif(trim(host_since), ''), 'DD/MM/YYYY') as host_since,
        case
            when lower(trim(host_is_superhost)) = 't' then true
            when lower(trim(host_is_superhost)) = 'f' then false
            else null
        end as host_is_superhost,
        nullif(trim(host_neighbourhood), '') as host_neighbourhood,
        nullif(trim(listing_neighbourhood), '') as listing_neighbourhood,
        nullif(trim(property_type), '') as property_type,
        nullif(trim(room_type), '') as room_type,
        nullif(trim(accommodates), '')::integer as accommodates,
        nullif(trim(price), '')::numeric as price,
        case
            when lower(trim(has_availability)) = 't' then true
            when lower(trim(has_availability)) = 'f' then false
            else null
        end as has_availability,
        nullif(trim(availability_30), '')::integer as availability_30,
        nullif(trim(number_of_reviews), '')::integer as number_of_reviews,
        nullif(trim(review_scores_rating), '')::numeric as review_scores_rating,
        nullif(trim(review_scores_accuracy), '')::numeric as review_scores_accuracy,
        nullif(trim(review_scores_cleanliness), '')::numeric as review_scores_cleanliness,
        nullif(trim(review_scores_checkin), '')::numeric as review_scores_checkin,
        nullif(trim(review_scores_communication), '')::numeric as review_scores_communication,
        nullif(trim(review_scores_value), '')::numeric as review_scores_value
    from source
)
select * from cleaned