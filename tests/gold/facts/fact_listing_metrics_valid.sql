select
    listing_id,
    month_key,
    price,
    availability_30,
    active_listing_flag,
    inactive_listing_flag,
    number_of_stays,
    estimated_revenue
from {{ ref('fact_listing') }}
where
    active_listing_flag is null
    or inactive_listing_flag is null
    or active_listing_flag not in (0, 1)
    or inactive_listing_flag not in (0, 1)
    or (
        active_listing_flag = 1
        and inactive_listing_flag = 1
    )
    or (
        active_listing_flag = 1
        and (
            inactive_listing_flag <> 0
            or number_of_stays is distinct from
                (30 - availability_30)
            or estimated_revenue is distinct from
                ((30 - availability_30) * price)
            or number_of_stays not between 0 and 30
            or estimated_revenue < 0
        )
    )
    or (
        inactive_listing_flag = 1
        and (
            active_listing_flag <> 0
            or number_of_stays is not null
            or estimated_revenue is not null
        )
    )
    or (
        active_listing_flag = 0
        and inactive_listing_flag = 0
        and (
            number_of_stays is not null
            or estimated_revenue is not null
        )
    )