# Subscription Analytics Project Report
**Analyst:** Logeshwaran Sekar
**Database:** Mozaic DB
**Tools:** MySQL · Python · Power BI


## Overview

This project delivers an end-to-end analytics solution built on three operational tables — `contracts`, `billing_histories`, and `contract_sign_up_details` — covering the full subscriber lifecycle from sign-up through billing, retention, and churn. The output spans SQL, Python, and Power BI, structured across five analytical domains.


### 1. Subscription Overview
- SQL queries covering total subscription counts, per-product breakdowns, monthly signup trends, and segmentation by campaign, OS family, and publisher. 
- Establishes the baseline volume picture before any revenue or quality analysis.

### 2. Revenue Analysis
- SQL-based revenue reporting using successful billing records only (`status = 'ok'`). Covers total and per-product revenue, monthly trend lines, average revenue per subscription, and revenue grouped by campaign and publisher. 
- All figures expressed in EUR using `amount_in_euro_cents / 100`.

### 3. Billing Performance
- Analysis of billing attempt success and failure rates at overall, product, campaign, and publisher level. 
- Includes failure reason breakdowns to identify recurring payment issues and flag segments with abnormally low collection rates.

### 4. Retention & Churn *(Python — MySQL)*
Python notebook using `pandas`, `Mysql-connector`
- Overall churn rate with pie chart visualisation
- Subscription lifetime distribution (all vs churned)
- Monthly cohort retention table and dual-axis chart
- Retention comparison by campaign, OS family, and publisher with ranked horizontal bar charts

### 5. Marketing Effectiveness

- Some campaigns generate high volume but low retention, indicating lower traffic quality.
- Certain publishers show strong retention and higher revenue contribution, making them high-value placements.
- OS family differences highlight device segments with better billing success and retention.


### 6. Data Cleansing using *(Python — MySQL)*

A dedicated Jupyter notebook handles data quality across all three tables before analysis:

`contracts`
`billing_histories` 
`contract_signup_details` 


### 7. Power BI Dashboard

This project analyzes subscription, billing, and marketing performance using data from three tables: **contracts**, **billing_histories**, and **contract_sign_up_details**.
SQL was used for data preparation, and Power BI was used to build interactive dashboards.

## Subscription Overview

* Total subscriptions and signup trends over time
* Subscriptions grouped by product, campaign, and publisher

## Revenue Analysis

* Total revenue generated
* Revenue by product and campaign
* Revenue trend over time

## Retention & Churn

* Overall churn rate
* Average subscription lifetime
* Retention comparison by campaign, OS family, and publisher


### Final Thoughts (Clear business insights and recommendations):

* Retention & Churn covers why timing of churn matters more than total churn rate, the 30-day second billing cycle as the strongest LTV predictor, and the difference between voluntary and involuntary churn (and why they require completely different solutions).
* Recommendations gives 9 specific actions structured across three timeframes — Immediate (this week), Short-term (30 days), Medium-term (90 days) — each with the data field to query, the team who owns it, and the expected impact.
