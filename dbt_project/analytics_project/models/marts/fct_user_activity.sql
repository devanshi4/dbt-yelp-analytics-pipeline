{{
    config(
        materialized='table',
        tags=['marts', 'user']
    )
}}

with review_metrics as (
    select * from {{ ref('int_review_metrics') }}
),

user_aggregates as (
    select
        user_id,
        
        -- Volume metrics
        count(*) as total_reviews_written,
        count(distinct product_id) as unique_products_reviewed,
        
        -- Rating behavior
        round(avg(rating)::numeric, 2) as avg_rating_given,
        min(rating) as min_rating_given,
        max(rating) as max_rating_given,
        
        -- Sentiment patterns
        sum(is_positive_review) as positive_reviews_written,
        sum(is_negative_review) as negative_reviews_written,
        
        -- User credibility
        sum(is_verified) as verified_purchases,
        sum(helpful_votes) as total_helpful_votes_received,
        round(avg(helpful_votes)::numeric, 2) as avg_helpful_votes_per_review,
        
        -- Engagement level
        round(avg(review_length)::numeric, 0) as avg_review_length,
        sum(case when review_length_category = 'long' then 1 else 0 end) as detailed_reviews,
        
        -- Timeline
        min(review_date) as first_review_date,
        max(review_date) as most_recent_review_date,
        max(review_date) - min(review_date) as active_days
        
    from review_metrics
    group by user_id
),

with_percentages as (
    select
        *,
        
        -- Calculated metrics
        round((positive_reviews_written::numeric / nullif(total_reviews_written, 0) * 100), 1) as positive_review_percentage,
        round((verified_purchases::numeric / nullif(total_reviews_written, 0) * 100), 1) as verified_purchase_percentage,
        round((detailed_reviews::numeric / nullif(total_reviews_written, 0) * 100), 1) as detailed_review_percentage
        
    from user_aggregates
),

final as (
    select
        *,
        
        -- User type classification
        case
            when total_reviews_written >= 20 then 'power_user'
            when total_reviews_written >= 10 then 'active_user'
            when total_reviews_written >= 5 then 'regular_user'
            else 'occasional_user'
        end as user_type,
        
        -- Reviewer quality score
        round(
            (verified_purchase_percentage * 0.3) +
            (avg_helpful_votes_per_review * 5) +
            (detailed_review_percentage * 0.2) +
            least(total_reviews_written * 2, 20),
            1
        ) as reviewer_quality_score
        
    from with_percentages
)

select * from final
order by total_reviews_written desc