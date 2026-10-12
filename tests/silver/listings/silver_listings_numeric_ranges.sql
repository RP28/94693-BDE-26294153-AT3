select
    listing_id,
    source_month
from {{ ref('silver_listings') }}
where price < 0
   or accommodates <= 0
   or availability_30 not between 0 and 30
   or number_of_reviews < 0
   or review_scores_rating not between 0 and 100
   or review_scores_accuracy not between 0 and 10
   or review_scores_cleanliness not between 0 and 10
   or review_scores_checkin not between 0 and 10
   or review_scores_communication not between 0 and 10
   or review_scores_value not between 0 and 10