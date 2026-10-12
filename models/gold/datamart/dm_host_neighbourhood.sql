with listings as (
    select * from {{ ref('fact_listing') }}
),
hosts as (
    select * from {{ ref('dim_host') }}
),
months as (
    select * from {{ ref('dim_month') }}
),
lgas as (
    select * from {{ ref('dim_lga') }}
),
monthly_metrics as (
    select
        l.lga_name as host_neighbourhood_lga,
        m.month_start,
        m.month_year,
        count(distinct h.host_id) as number_of_distinct_hosts,
        avg(f.estimated_revenue)
            filter (where f.active_listing_flag = 1)
            as average_estimated_revenue_per_active_listing,
        coalesce(
            sum(f.estimated_revenue)
                filter (where f.active_listing_flag = 1), 0
        ) / nullif(count(distinct h.host_id), 0)
            as estimated_revenue_per_host
    from listings f
    inner join hosts h
        on f.host_key = h.host_key
    inner join months m
        on f.month_key = m.month_key
    left join lgas l
        on h.host_lga_code = l.lga_code
    group by
        l.lga_name,
        m.month_start,
        m.month_year
)
select
    host_neighbourhood_lga,
    month_year,
    number_of_distinct_hosts,
    average_estimated_revenue_per_active_listing,
    estimated_revenue_per_host
from monthly_metrics
order by
    host_neighbourhood_lga,
    month_start