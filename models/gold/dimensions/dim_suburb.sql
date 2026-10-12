with source as (
    select * from {{ ref('silver_lga_suburb') }}
),
transformed as (
    select
        md5(
            concat_ws(
                '||',
                lga_code,
                suburb_name
            )
        ) as suburb_key,
        suburb_name,
        lga_code,
        lga_name
    from source
)
select * from transformed