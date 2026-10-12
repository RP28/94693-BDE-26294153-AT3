
with listing_expected as (
    select
        p.listing_neighbourhood,
        m.month_year,
        coalesce(
            sum(f.number_of_stays)
                filter (where f.active_listing_flag = 1),
            0
        ) as expected_stays
    from {{ ref('fact_listing') }} f
    join {{ ref('dim_property') }} p
        on f.property_key = p.property_key
    join {{ ref('dim_month') }} m
        on f.month_key = m.month_key
    group by p.listing_neighbourhood, m.month_year
),
property_expected as (
    select
        p.property_type,
        p.room_type,
        p.accommodates,
        m.month_year,
        coalesce(
            sum(f.number_of_stays)
                filter (where f.active_listing_flag = 1),
            0
        ) as expected_stays
    from {{ ref('fact_listing') }} f
    join {{ ref('dim_property') }} p
        on f.property_key = p.property_key
    join {{ ref('dim_month') }} m
        on f.month_key = m.month_key
    group by
        p.property_type,
        p.room_type,
        p.accommodates,
        m.month_year
),
host_expected as (
    select
        l.lga_name as host_neighbourhood_lga,
        m.month_year,
        coalesce(
            sum(f.estimated_revenue)
                filter (where f.active_listing_flag = 1),
            0
        ) / nullif(count(distinct h.host_id), 0)
            as expected_revenue_per_host
    from {{ ref('fact_listing') }} f
    join {{ ref('dim_host') }} h
        on f.host_key = h.host_key
    join {{ ref('dim_month') }} m
        on f.month_key = m.month_key
    left join {{ ref('dim_lga') }} l
        on h.host_lga_code = l.lga_code
    group by l.lga_name, m.month_year
),
violations as (
    select
        'dm_listing_neighbourhood' as datamart,
        d.listing_neighbourhood::text as group_value,
        d.month_year,
        'price_or_stays_mismatch' as issue
    from {{ ref('dm_listing_neighbourhood') }} d
    left join listing_expected e
        on d.listing_neighbourhood
            is not distinct from e.listing_neighbourhood
       and d.month_year = e.month_year
    where
        d.total_number_of_stays
            is distinct from e.expected_stays
        or (
            d.minimum_active_listing_price is not null
            and (
                d.maximum_active_listing_price
                    < d.minimum_active_listing_price
                or d.median_active_listing_price not between
                    d.minimum_active_listing_price
                    and d.maximum_active_listing_price
                or d.average_active_listing_price not between
                    d.minimum_active_listing_price
                    and d.maximum_active_listing_price
            )
        )
    union all
    select
        'dm_property_type',
        concat_ws(
            ' | ',
            d.property_type,
            d.room_type,
            d.accommodates::text
        ),
        d.month_year,
        'price_or_stays_mismatch'
    from {{ ref('dm_property_type') }} d
    left join property_expected e
        on d.property_type is not distinct from e.property_type
       and d.room_type is not distinct from e.room_type
       and d.accommodates is not distinct from e.accommodates
       and d.month_year = e.month_year
    where
        d.total_number_of_stays
            is distinct from e.expected_stays
        or (
            d.minimum_active_listing_price is not null
            and (
                d.maximum_active_listing_price
                    < d.minimum_active_listing_price
                or d.median_active_listing_price not between
                    d.minimum_active_listing_price
                    and d.maximum_active_listing_price
                or d.average_active_listing_price not between
                    d.minimum_active_listing_price
                    and d.maximum_active_listing_price
            )
        )
    union all
    select
        'dm_host_neighbourhood',
        d.host_neighbourhood_lga::text,
        d.month_year,
        'revenue_per_host_mismatch'
    from {{ ref('dm_host_neighbourhood') }} d
    left join host_expected e
        on d.host_neighbourhood_lga
            is not distinct from e.host_neighbourhood_lga
       and d.month_year = e.month_year
    where d.estimated_revenue_per_host
        is distinct from e.expected_revenue_per_host
)
select *
from violations
