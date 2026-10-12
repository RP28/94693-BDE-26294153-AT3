select
    property_type,
    room_type,
    accommodates,
    month_year,
    count(*) as row_count
from {{ ref('dm_property_type') }}
group by
    property_type,
    room_type,
    accommodates,
    month_year
having count(*) > 1