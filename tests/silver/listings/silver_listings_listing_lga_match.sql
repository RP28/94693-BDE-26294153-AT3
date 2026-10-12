select distinct
    l.listing_neighbourhood
from {{ ref('silver_listings') }} l
left join {{ ref('silver_lga_code') }} g
    on upper(trim(l.listing_neighbourhood)) = g.lga_name
where l.listing_neighbourhood is not null
  and g.lga_code is null