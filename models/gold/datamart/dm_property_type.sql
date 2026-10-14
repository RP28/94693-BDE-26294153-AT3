with listings as (
    select * from {{ ref('fact_listing') }}
),
properties as (
    select * from {{ ref('dim_property') }}
),
hosts as (
    select * from {{ ref('dim_host') }}
),
months as (
    select * from {{ ref('dim_month') }}
),
monthly_metrics as (
    select
        p.property_type,
        p.room_type,
        p.accommodates,
        m.month_start,
        m.month_year,
        count(*) as total_listings,
        count(*) filter (
            where f.active_listing_flag = 1
        ) as active_listings,
        count(*) filter (
            where f.inactive_listing_flag = 1
        ) as inactive_listings,
        100.0 * count(*) filter (
            where f.active_listing_flag = 1
        ) / nullif(count(*), 0) as active_listing_rate,
        min(f.price) filter (
            where f.active_listing_flag = 1
        ) as minimum_active_listing_price,
        max(f.price) filter (
            where f.active_listing_flag = 1
        ) as maximum_active_listing_price,
        percentile_cont(0.5) within group (
            order by f.price
        ) filter (
            where f.active_listing_flag = 1
        ) as median_active_listing_price,
        avg(f.price) filter (
            where f.active_listing_flag = 1
        ) as average_active_listing_price,
        count(distinct h.host_id) as number_of_distinct_hosts,
        100.0 * count(
            distinct case
                when h.host_is_superhost = true
                then h.host_id
            end
        ) / count(distinct h.host_id) as superhost_rate,
        avg(f.review_scores_rating) filter (
            where f.active_listing_flag = 1
        ) as average_review_scores_rating,
        coalesce(
            sum(f.number_of_stays) filter (
                where f.active_listing_flag = 1
            ), 0
        ) as total_number_of_stays,
        avg(f.estimated_revenue) filter (
            where f.active_listing_flag = 1
        ) as average_estimated_revenue_per_active_listing
    from listings f
    inner join properties p
        on f.property_key = p.property_key
    inner join hosts h
        on f.host_key = h.host_key
    inner join months m
        on f.month_key = m.month_key
    group by
        p.property_type,
        p.room_type,
        p.accommodates,
        m.month_start,
        m.month_year
),
with_previous_month as (
    select
        *,
        lag(active_listings) over (
            partition by
                property_type,
                room_type,
                accommodates
            order by month_start
        ) as previous_active_listings,
        lag(inactive_listings) over (
            partition by
                property_type,
                room_type,
                accommodates
            order by month_start
        ) as previous_inactive_listings
    from monthly_metrics
)
select
    property_type,
    room_type,
    accommodates,
    month_year,
    active_listing_rate,
    minimum_active_listing_price,
    maximum_active_listing_price,
    median_active_listing_price,
    average_active_listing_price,
    number_of_distinct_hosts,
    superhost_rate,
    average_review_scores_rating,
    100.0 * (
        active_listings - previous_active_listings
    ) / nullif(previous_active_listings, 0)
        as percentage_change_active_listings,
    100.0 * (
        inactive_listings - previous_inactive_listings
    ) / nullif(previous_inactive_listings, 0)
        as percentage_change_inactive_listings,
    total_number_of_stays,
    average_estimated_revenue_per_active_listing
from with_previous_month
order by
    property_type,
    room_type,
    accommodates,
    month_start