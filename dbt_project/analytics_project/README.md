# 🎯 Yelp Reviews Analytics Pipeline - DBT Project

A production-grade data transformation pipeline built with **DBT**, **PostgreSQL**, and **Python**. This project demonstrates end-to-end data engineering skills including data ingestion, transformation, testing, and documentation.

## 📊 Project Overview

This pipeline analyzes **2,000+ Yelp business reviews** to generate actionable insights about:
- **Product Performance**: Sentiment analysis, rating trends, engagement metrics
- **User Behavior**: Review patterns, credibility scoring, user segmentation
- **Time Series Analysis**: Daily and monthly review trends

## 🏗️ Architecture
```
HuggingFace Dataset → PostgreSQL (Raw) → DBT (Transform) → Analytics Tables
```

**Data Flow:**
1. **Ingestion**: Python script loads Yelp reviews from HuggingFace
2. **Staging**: DBT cleans and standardizes raw data
3. **Intermediate**: DBT calculates review metrics and KPIs
4. **Marts**: DBT creates business-ready analytics tables

## 🛠️ Tech Stack

- **Data Warehouse**: PostgreSQL
- **Transformation**: DBT (Data Build Tool)
- **Data Source**: HuggingFace Datasets API
- **Languages**: SQL, Python
- **Version Control**: Git/GitHub

## 📁 Project Structure
```
analytics_project/
├── models/
│   ├── staging/          # Raw data cleaning & standardization
│   │   ├── stg_reviews.sql
│   │   └── _sources.yml
│   ├── intermediate/     # Business logic & metrics
│   │   └── int_review_metrics.sql
│   └── marts/            # Final analytics tables
│       ├── fct_product_performance.sql
│       ├── fct_user_activity.sql
│       └── dim_review_timeline.sql
├── tests/                # Data quality tests
└── dbt_project.yml       # DBT configuration
```

## 🚀 Getting Started

### Prerequisites
```bash
# Install required packages
pip install dbt-postgres datasets pandas sqlalchemy psycopg2-binary
```

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/devanshi4/dbt-yelp-analytics-pipeline.git
cd dbt-analytics-project
```

2. **Configure PostgreSQL connection**
   - Create database: `dbt_analytics`
   - Update `~/.dbt/profiles.yml` with your credentials

3. **Load data**
```bash
cd data_ingestion
python load_data.py
```

4. **Run DBT pipeline**
```bash
cd ../dbt_project/analytics_project
dbt run
dbt test
```

## 📈 Key Models

### 🏆 fct_product_performance
Aggregated product metrics including:
- Total reviews & unique reviewers
- Average ratings & sentiment distribution
- Verification rates
- **Product Health Score** (0-100)

### 👥 fct_user_activity
User behavior analysis:
- Review volume & frequency
- Rating patterns
- Credibility indicators
- **Reviewer Quality Score**

### 📅 dim_review_timeline
Time-series data for trend analysis:
- Daily review counts
- Rolling averages
- Sentiment trends over time

## ✅ Data Quality

Comprehensive testing suite includes:
- **Not Null Tests**: Ensuring critical fields have values
- **Unique Tests**: Preventing duplicate records
- **Accepted Values**: Validating categorical data
- **Referential Integrity**: Checking foreign key relationships

Run tests: `dbt test`

## 📚 Documentation

Generate interactive documentation:
```bash
dbt docs generate
dbt docs serve
```

View at: `http://localhost:8080`

Features:
- 📊 Interactive lineage graph
- 📖 Model documentation
- 🧪 Test results
- 📈 Column-level details

## 🎓 Key Features Demonstrated

✅ **Modern Data Stack**: DBT + PostgreSQL  
✅ **Data Modeling**: Staging → Intermediate → Marts architecture  
✅ **SQL Skills**: CTEs, window functions, aggregations  
✅ **Data Quality**: Automated testing framework  
✅ **Incremental Models**: Efficient data processing  
✅ **Documentation**: Auto-generated docs with lineage  
✅ **Version Control**: Git best practices  

## 📊 Sample Insights

- **Average Product Rating**: 4.2/5.0
- **Review Sentiment**: 65% positive, 20% neutral, 15% negative
- **Top Products**: Ranked by health score
- **Power Users**: Identified by quality score

## 🔄 Future Enhancements

- [ ] Add dbt snapshots for historical tracking
- [ ] Implement custom data quality macros
- [ ] Add CI/CD with GitHub Actions
- [ ] Create dashboard with Tableau/Power BI
- [ ] Add more data sources

## 👤 Author

**Your Name**
- LinkedIn: [https://www.linkedin.com/in/devanshi4/]
- GitHub: [@devanshi4]
- Portfolio: [https://my-portfolio-xjgdxcqjrhtvxbuaombpda.streamlit.app/#ai-sql-assistant]

## 📝 License

This project is open source and available under the MIT License.

---

⭐ **If you found this project helpful, please give it a star!**