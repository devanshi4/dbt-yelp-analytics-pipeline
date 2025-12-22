{{
    config(
        materialized='incremental',
        unique_key='timeline_key',
        tags=['marts', 'timeline']
    )
}}

with review_metrics as (
    select * from {{ ref('int_review_metrics') }}
    {% if is_incremental() %}
        where review_date > (select max(review_date) from {{ this }})
    {% endif %}
),

daily_metrics as (
    select
        review_date,
        product_id,
        
        -- Daily counts
        count(*) as daily_review_count,
        count(distinct user_id) as daily_unique_reviewers,
        
        -- Daily averages
        round(avg(rating)::numeric, 2) as daily_avg_rating,
        
        -- Daily sentiment
        sum(is_positive_review) as daily_positive_reviews,
        sum(is_negative_review) as daily_negative_reviews,
        
        -- Daily engagement
        sum(helpful_votes) as daily_helpful_votes,
        sum(is_verified) as daily_verified_reviews
        
    from review_metrics
    group by review_date, product_id
),

final as (
    select
        md5(review_date::text || product_id::text) as timeline_key,
        *
        
    from daily_metrics
)

select * from final