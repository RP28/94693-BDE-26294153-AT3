select
    'dm_listing_neighbourhood' as datamart,
    listing_neighbourhood::text as group_value,
    month_year,
    total_number_of_stays
from {{ ref('dm_listing_neighbourhood') }}
where total_number_of_stays < 0
union all
select
    'dm_property_type',
    concat_ws(
        ' | ',
        property_type,
        room_type,
        accommodates::text
    ),
    month_year,
    total_number_of_stays
from {{ ref('dm_property_type') }}
where total_number_of_stays < 0