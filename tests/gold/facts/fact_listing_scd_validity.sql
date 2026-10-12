select
    f.listing_id,
    f.host_id,
    f.month_key,
    f.property_key,
    f.host_key,
    m.month_start,
    p.valid_from as property_valid_from,
    p.valid_to as property_valid_to,
    h.valid_from as host_valid_from,
    h.valid_to as host_valid_to
from {{ ref('fact_listing') }} f
left join {{ ref('dim_month') }} m
    on f.month_key = m.month_key
left join {{ ref('dim_property') }} p
    on f.property_key = p.property_key
left join {{ ref('dim_host') }} h
    on f.host_key = h.host_key
where
    m.month_key is null
    or p.property_key is null
    or h.host_key is null
    or p.listing_id is distinct from f.listing_id
    or h.host_id is distinct from f.host_id
    or m.month_start < p.valid_from
    or (
        p.valid_to is not null
        and m.month_start >= p.valid_to
    )
    or m.month_start < h.valid_from
    or (
        h.valid_to is not null
        and m.month_start >= h.valid_to
    )