with versions as (
    select
        'dim_host' as dimension_name,
        host_id::text as entity_id,
        valid_from,
        valid_to
    from {{ ref('dim_host') }}
    union all
    select
        'dim_property' as dimension_name,
        listing_id::text as entity_id,
        valid_from,
        valid_to
    from {{ ref('dim_property') }}
),
ordered_versions as (
    select
        *,
        lead(valid_from) over (
            partition by dimension_name, entity_id
            order by valid_from
        ) as next_valid_from
    from versions
)
select
    dimension_name,
    entity_id,
    valid_from,
    valid_to,
    next_valid_from
from ordered_versions
where
    (
        next_valid_from is not null
        and (
            valid_to is null
            or valid_to > next_valid_from
        )
    )
    or (
        next_valid_from is not null
        and valid_from = next_valid_from
    )