select
    lga_code,
    lga_name,
    suburb_name,
    count(*) as row_count
from {{ ref('silver_lga_suburb') }}
group by
    lga_code,
    lga_name,
    suburb_name
having count(*) > 1