with source as (
    select * from {{ ref('silver_listings') }}
),
properties as (
    select * from {{ ref('dim_property') }}
),
hosts as (
    select * from {{ ref('dim_host') }}
),
suburbs as (
    select * from {{ ref('dim_suburb') }}
),
calculated as (
    select
        l.*,
        (
            extract(year from l.source_month)::integer * 100
            + extract(month from l.source_month)::integer
        ) as month_key,
        case
            when l.has_availability then 1
            else 0
        end as active_listing_flag,
        case
            when not l.has_availability then 1
            else 0
        end as inactive_listing_flag,
        case
            when l.has_availability
            then 30 - l.availability_30
            else null
        end as number_of_stays,
        case
            when l.has_availability
            then (30 - l.availability_30) * l.price
            else null
        end as estimated_revenue
    from source l
),
resolved as (
    select
        b.listing_id,
        b.host_id,
        b.month_key,
        p.property_key,
        h.host_key,
        p.listing_lga_code,
        h.host_lga_code,
        s.suburb_key as host_suburb_key,
        b.price,
        b.active_listing_flag,
        b.inactive_listing_flag,
        b.availability_30,
        b.number_of_reviews,
        b.review_scores_rating,
        b.review_scores_accuracy,
        b.review_scores_cleanliness,
        b.review_scores_checkin,
        b.review_scores_communication,
        b.review_scores_value,
        b.number_of_stays,
        b.estimated_revenue
    from calculated b
    inner join properties p
        on b.listing_id = p.listing_id
        and b.source_month >= p.valid_from
        and (
            b.source_month < p.valid_to
            or p.valid_to is null
        )
    inner join hosts h
        on b.host_id = h.host_id
        and b.source_month >= h.valid_from
        and (
            b.source_month < h.valid_to
            or h.valid_to is null
        )
    left join suburbs s
        on h.host_neighbourhood = s.suburb_name
        and h.host_lga_code = s.lga_code
)
select * from resolved