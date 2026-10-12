with host_versions as (
    select distinct
        source_month,
        host_id,
        host_name,
        host_since,
        host_is_superhost,
        host_neighbourhood
    from {{ ref('silver_listings') }}
)
select
    source_month,
    host_id,
    count(*) as distinct_host_versions
from host_versions
group by
    source_month,
    host_id
having count(*) > 1