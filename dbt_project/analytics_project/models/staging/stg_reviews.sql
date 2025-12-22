{{
    config(
        materialized='view',
        tags=['staging']
    )
}}

with source_data as (
    select * from {{ source('raw', 'raw_reviews') }}
),

cleaned as (
    select
        -- IDs
        product_id,
        user_id,
        
        -- Review content
        rating,
        title as review_title,
        text as review_text,
        
        -- Metadata
        timestamp as review_timestamp,
        verified_purchase as is_verified_purchase,
        helpful_vote as helpful_votes,
        
        -- Derived fields
        to_timestamp(timestamp) as review_datetime,
        date_trunc('day', to_timestamp(timestamp))::date as review_date,
        date_trunc('month', to_timestamp(timestamp))::date as review_month,
        
        -- Sentiment classification
        case 
            when rating >= 4 then 'positive'
            when rating = 3 then 'neutral'
            else 'negative'
        end as sentiment,
        
        -- Review length
        length(text) as review_length
        
    from source_data
    where rating is not null
      and text is not null
)

select * from cleaned