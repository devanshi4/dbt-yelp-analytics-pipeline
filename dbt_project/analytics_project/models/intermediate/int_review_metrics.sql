{{
    config(
        materialized='ephemeral',
        tags=['intermediate']
    )
}}

with staging_reviews as (
    select * from {{ ref('stg_reviews') }}
),

review_metrics as (
    select
        -- IDs
        product_id,
        user_id,
        
        -- Review details
        rating,
        sentiment,
        review_date,
        review_month,
        is_verified_purchase,
        helpful_votes,
        review_length,
        
        -- Metrics
        case when is_verified_purchase then 1 else 0 end as is_verified,
        case when rating >= 4 then 1 else 0 end as is_positive_review,
        case when rating <= 2 then 1 else 0 end as is_negative_review,
        case when helpful_votes > 0 then 1 else 0 end as has_helpful_votes,
        
        -- Review quality indicators
        case 
            when review_length < 50 then 'short'
            when review_length < 200 then 'medium'
            else 'long'
        end as review_length_category
        
    from staging_reviews
)

select * from review_metrics