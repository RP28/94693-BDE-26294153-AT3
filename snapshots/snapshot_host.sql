{% snapshot snapshot_host %}
{{
    config(
        target_schema='silver',
        unique_key='host_id',
        strategy='timestamp',
        updated_at='source_month',
        invalidate_hard_deletes=false
    )
}}
select
    host_id,
    host_name,
    host_since,
    host_is_superhost,
    host_neighbourhood,
    host_lga_code,
    source_month
from {{ ref('silver_host_current') }}
{% endsnapshot %}