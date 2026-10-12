with source as (
    select * from {{ ref('snapshot_property') }}
),
transformed as (
    select
        dbt_scd_id as property_key,
        listing_id,
        listing_neighbourhood,
        listing_lga_code,
        property_type,
        room_type,
        accommodates,
        source_month as version_source_month,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to
    from source
)
select * from transformed