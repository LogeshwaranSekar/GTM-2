-- SQLBook: Code

/* 1) Compare campaigns by (Number of subscriptions, Revenue generated, Retention performance): */

select coalesce(cs.campaign_name, 'Unknown') as campaign_name, coalesce(cs.campaign_id, 'Unknown') as campaign_id,
count(distinct c.id) AS total_subscriptions,
round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0, 2) as total_revenue_eur,
round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0
/ nullif(count(distinct c.id), 0),4)  as revenue_per_subscription_eur,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(distinct c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days,
count(bh.id) as total_billing_attempts,
round(sum(case when bh.status = 'ok' then 1 else 0 end) * 100.0 / nullif(count(bh.id), 0), 2) as billing_success_rate_pct
from contracts c
join contract_sign_up_details cs on c.id = cs.contract_id
left join billing_histories bh on c.id = bh.contract_id
where c.signed_at is not null
group by cs.campaign_name, cs.campaign_id
order by total_revenue_eur desc;

/* 2) Compare OS families by (Subscription volume, Retention, Revenue contribution): */

select
    coalesce(csd.os_family, 'Unknown') as os_family,
    count(distinct c.id) as total_subscriptions,
    round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0, 2) as total_revenue_eur,
    round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0
    / nullif(count(distinct c.id), 0),4) as revenue_per_subscription_eur,
    round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(DISTINCT c.id), 2) as retention_rate_pct,
    round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days
from contracts c
join contract_sign_up_details csd on c.id = csd.contract_id
left join billing_histories bh on c.id = bh.contract_id
where c.signed_at is not null
group by csd.os_family
order by total_revenue_eur desc;

/* 3) Compare publishers placements by (Subscription volume, Revenue,Retention quality): */

select coalesce(csd.publisher_id, 'Unknown') as publisher_id,
count(distinct c.id) as total_subscriptions,
round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0, 2) as total_revenue_eur,
round(sum(case when bh.status = 'ok' then bh.amount_in_euro_cents else 0 end) / 100.0
/ nullif(count(distinct c.id), 0),4) as revenue_per_subscription_eur,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(distinct c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days,
round(sum(case when bh.status = 'ok' then 1 else 0 end) * 100.0 / nullif(count(bh.id), 0), 2) as billing_success_rate_pct
from contracts c
join contract_sign_up_details csd on c.id = csd.contract_id
left join billing_histories bh on c.id = bh.contract_id
where c.signed_at is not null
group by csd.publisher_id
order by total_revenue_eur desc;

-- High-Performing Campaigns (min 50 subs for statistical significance) Using ChatGPT:

WITH campaign_stats AS (
    SELECT
        COALESCE(csd.campaign_name, 'Unknown') AS campaign_name,
        COALESCE(csd.campaign_id, 'Unknown') AS campaign_id,
        COUNT(DISTINCT c.id) AS total_subscriptions,
        ROUND(SUM(CASE WHEN bh.status = 'ok' THEN bh.amount_in_euro_cents ELSE 0 END) / 100.0
            / NULLIF(COUNT(DISTINCT c.id), 0), 4)                       AS revenue_per_sub_eur,
        ROUND(SUM(CASE WHEN c.state = 'rejected' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT c.id), 2) AS retention_rate_pct,
        ROUND(SUM(CASE WHEN bh.status = 'ok' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(bh.id), 0), 2) AS billing_success_rate_pct
    FROM contracts c
    JOIN contract_sign_up_details csd ON c.id = csd.contract_id
    LEFT JOIN billing_histories bh ON c.id = bh.contract_id
    WHERE c.signed_at IS NOT NULL
    GROUP BY csd.campaign_name, csd.campaign_id
    HAVING COUNT(DISTINCT c.id) >= 50
)
SELECT
    *,
    -- Simple composite score: equally weights the three key KPIs (all are pct or normalised)
    ROUND((retention_rate_pct + billing_success_rate_pct + (revenue_per_sub_eur * 10)) / 3, 2) AS quality_score
FROM campaign_stats
ORDER BY quality_score DESC;

-- High-Quality Publishers (min 50 subs)
WITH publisher_stats AS (
    SELECT
        COALESCE(csd.publisher_id, 'Unknown')                           AS publisher_id,
        COUNT(DISTINCT c.id)                                            AS total_subscriptions,
        ROUND(SUM(CASE WHEN bh.status = 'ok' THEN bh.amount_in_euro_cents ELSE 0 END) / 100.0
            / NULLIF(COUNT(DISTINCT c.id), 0), 4)                       AS revenue_per_sub_eur,
        ROUND(SUM(CASE WHEN c.state = 'rejected' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT c.id), 2) AS retention_rate_pct,
        ROUND(SUM(CASE WHEN bh.status = 'ok' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(bh.id), 0), 2) AS billing_success_rate_pct
    FROM contracts c
    JOIN contract_sign_up_details csd ON c.id = csd.contract_id
    LEFT JOIN billing_histories bh ON c.id = bh.contract_id
    WHERE c.signed_at IS NOT NULL
    GROUP BY csd.publisher_id
    HAVING COUNT(DISTINCT c.id) >= 50
)
SELECT
    *,
    ROUND((retention_rate_pct + billing_success_rate_pct + (revenue_per_sub_eur * 10)) / 3, 2) AS quality_score
FROM publisher_stats
ORDER BY quality_score DESC;

-- Low-Quality / Risky Publishers
-- High volume but poor retention and/or billing success
WITH publisher_stats AS (
    SELECT
        COALESCE(csd.publisher_id, 'Unknown')  AS publisher_id,
        COUNT(DISTINCT c.id)  AS total_subscriptions,
        ROUND(SUM(CASE WHEN c.state = 'rejected' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT c.id), 2) AS retention_rate_pct,
        ROUND(SUM(CASE WHEN bh.status = 'ok' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(bh.id), 0), 2) AS billing_success_rate_pct,
        ROUND(AVG(DATEDIFF(COALESCE(c.terminated_at, NOW()), c.signed_at)), 1) AS avg_lifetime_days
    FROM contracts c
    JOIN contract_sign_up_details csd ON c.id = csd.contract_id
    LEFT JOIN billing_histories bh ON c.id = bh.contract_id
    WHERE c.signed_at IS NOT NULL
    GROUP BY csd.publisher_id
    HAVING COUNT(DISTINCT c.id) >= 30
)
SELECT *, 'LOW QUALITY / RISKY' AS flag
FROM publisher_stats
WHERE retention_rate_pct < 20     -- Less than 20% still active
OR billing_success_rate_pct < 50  -- Less than half of billings succeed
OR avg_lifetime_days < 7          -- Users leaving within a week on average
ORDER BY retention_rate_pct ASC;