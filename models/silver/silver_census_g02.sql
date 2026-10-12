with source as (
    select * from {{ source('bronze', 'raw_census_g02') }}
),
cleaned as (
    select
        regexp_replace(upper(trim(lga_code_2016)), '^LGA', '') as lga_code,
        nullif(trim(median_age_persons), '')::integer as median_age_persons,
        nullif(trim(median_mortgage_repay_monthly), '')::integer as median_mortgage_repay_monthly,
        nullif(trim(median_tot_prsnl_inc_weekly), '')::integer as median_tot_prsnl_inc_weekly,
        nullif(trim(median_rent_weekly), '')::integer as median_rent_weekly,
        nullif(trim(median_tot_fam_inc_weekly), '')::integer as median_tot_fam_inc_weekly,
        nullif(trim(average_num_psns_per_bedroom), '')::numeric(4, 2) as average_num_psns_per_bedroom,
        nullif(trim(median_tot_hhd_inc_weekly), '')::integer as median_tot_hhd_inc_weekly,
        nullif(trim(average_household_size), '')::numeric(4, 2) as average_household_size
    from source
)
select * from cleaned