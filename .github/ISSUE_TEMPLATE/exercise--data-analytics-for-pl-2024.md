---
name: 'Exercise: Data Analytics Assignment - PL 3 month data'
about: Data Analytics Assignment for PL Oct 24 to Dec 24
title: assignment-instructions
labels: ''
assignees: ''

# Data Analyst Assignment

Subscription & Revenue Analysis (Time Budget: 3–4 Hours)

---

## Dataset Overview

The dump contains three tables:

### 1. `contracts`
Represents subscriptions.

Key fields:
- `created_at` — Subscription start date
- `terminated_at` — Subscription end date (if churned)
- `state` — Current status
- `product_identifier` — Product/service name
- `payment_provider_config_profile_id` — Pricing/billing configuration
- `billing_histories_count` — Cached billing attempts count
- `billing_histories_sum_in_euro_cents` — Cached total billed amount

---

### 2. `contract_sign_up_details`
Marketing and device metadata.

Examples:
- `referrer`
- `campaign_id`
- `publisher_id`
- `device`
- `os_family`
- `remote_ip`

---

### 3. `billing_histories`
Represents individual billing attempts.

Key fields:
- `created_at`
- `status` (success, failure, etc.)
- `amount_in_euro_cents`
- `product_identifier`

---

## Required Analysis

Please cover the following:

### 1. Subscription Overview
- Total subscriptions
- Subscriptions per product
- Signup trend over time
- Subscriptions grouped by campaign, OS family, and publisher (placement)

### 2. Revenue Analysis
- Total revenue (based on successful billing attempts)
- Revenue per product
- Revenue trend over time
- Average revenue per subscription
- Revenue grouped by campaign and publisher

### 3. Billing Performance
- Total billing attempts
- Success vs failure rate
- Success rate per product
- Success rate by campaign or publisher (if meaningful)

### 4. Retention and Churn
- Churn rate
- Average subscription lifetime
- Basic cohort analysis (by signup month)
- Retention comparison:
  - By campaign
  - By OS family
  - By publisher (placement)

### 5. Marketing Effectiveness (Using `contract_sign_up_details`)
Using campaign, publisher, and device data:

- Compare campaigns by:
  - Number of subscriptions
  - Revenue generated
  - Retention performance

- Compare OS families by:
  - Subscription volume
  - Retention
  - Revenue contribution

- Compare publishers (placements) by:
  - Subscription volume
  - Revenue
  - Retention quality

Based on your analysis, identify:
- High-performing campaigns
- High-quality placements (publishers)
- Segments that generate strong retention and revenue
- Segments that may be low quality or risky

---

Focus on identifying which acquisition sources and user segments are most beneficial for the business, not just which generate the most signups.

---

## Deliverables

Please submit:

1. SQL queries used
2. Scripts (Python, panda, R, etc) used for data processing and analytics
2. A short written report (Markdown or PDF)
3. Relevant charts or visualizations where suitable
4. Clear business insights and recommendations

You may use any tools (SQL, Excel, Python, R, BI tools, etc.).

> IMPORTANT NOTE: Everything should be submitted in this given repository only. No data, code, script, report, etc should be pushed outside this repository.

---

## Optional

If you notice anything interesting, unusual, or valuable (for example anomalies, patterns, risks, or correlations), feel free to include additional insights.

---

## What We Care About

- Correct use of data
- Logical structure
- Meaningful KPIs
- Clear assumptions
- Business-focused insights

We are not evaluating visual design or tool preference.
