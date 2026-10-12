select
    suburb_name,
    count(distinct lga_code) as lga_count
from {{ ref('silver_lga_suburb') }}
group by suburb_name
having count(distinct lga_code) > 1