select
    'dim_host' as dimension_name,
    host_id::text as entity_id,
    valid_from,
    valid_to
from {{ ref('dim_host') }}
where valid_from is null
   or (
       valid_to is not null
       and valid_to <= valid_from
   )
union all
select
    'dim_property' as dimension_name,
    listing_id::text as entity_id,
    valid_from,
    valid_to
from {{ ref('dim_property') }}
where valid_from is null
   or (
       valid_to is not null
       and valid_to <= valid_from
   )