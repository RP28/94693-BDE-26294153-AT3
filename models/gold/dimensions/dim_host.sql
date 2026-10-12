with source as (
    select * from {{ ref('snapshot_host') }}
),
transformed as (
    select
        dbt_scd_id as host_key,
        host_id,
        host_name,
        host_since,
        host_is_superhost,
        host_neighbourhood,
        host_lga_code,
        source_month as version_source_month,
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to
    from source
)
select * from transformed