{% snapshot snapshot_property %}
{{
    config(
        target_schema='silver',
        unique_key='listing_id',
        strategy='timestamp',
        updated_at='source_month',
        invalidate_hard_deletes=false
    )
}}
select
    listing_id,
    listing_neighbourhood,
    listing_lga_code,
    property_type,
    room_type,
    accommodates,
    source_month
from {{ ref('silver_property_current') }}
{% endsnapshot %}