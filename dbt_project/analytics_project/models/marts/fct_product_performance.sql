{{
    config(
        materialized='table',
        tags=['marts', 'product']
    )
}}

with review_metrics as (
    select * from {{ ref('int_review_metrics') }}
),

product_aggregates as (
    select
        product_id,
        
        -- Volume metrics
        count(*) as total_reviews,
        count(distinct user_id) as unique_reviewers,
        
        -- Rating metrics
        round(avg(rating)::numeric, 2) as avg_rating,
        min(rating) as min_rating,
        max(rating) as max_rating,
        
        -- Sentiment distribution
        sum(is_positive_review) as positive_reviews,
        sum(is_negative_review) as negative_reviews,
        sum(case when sentiment = 'neutral' then 1 else 0 end) as neutral_reviews,
        
        -- Verification metrics
        sum(is_verified) as verified_reviews,
        
        -- Engagement metrics
        sum(helpful_votes) as total_helpful_votes,
        round(avg(helpful_votes)::numeric, 2) as avg_helpful_votes,
        sum(has_helpful_votes) as reviews_with_helpful_votes,
        
        -- Review length metrics
        round(avg(review_length)::numeric, 0) as avg_review_length,
        sum(case when review_length_category = 'long' then 1 else 0 end) as long_reviews,
        
        -- Timeline
        min(review_date) as first_review_date,
        max(review_date) as last_review_date,
        max(review_date) - min(review_date) as review_span_days
        
    from review_metrics
    group by product_id
),

with_percentages as (
    select
        *,
        
        -- Calculated percentages
        round((positive_reviews::numeric / nullif(total_reviews, 0) * 100), 1) as positive_percentage,
        round((negative_reviews::numeric / nullif(total_reviews, 0) * 100), 1) as negative_percentage,
        round((verified_reviews::numeric / nullif(total_reviews, 0) * 100), 1) as verified_percentage,
        round((reviews_with_helpful_votes::numeric / nullif(total_reviews, 0) * 100), 1) as helpful_vote_percentage
        
    from product_aggregates
),

final as (
    select
        *,
        
        -- Product health score (simple algorithm)
        round(
            (avg_rating / 5.0 * 40) +
            (positive_percentage * 0.3) +
            (verified_percentage * 0.2) +
            (helpful_vote_percentage * 0.1),
            1
        ) as product_health_score
        
    from with_percentages
)

select * from final
order by total_reviews desc