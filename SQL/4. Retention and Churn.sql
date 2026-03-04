-- SQLBook: Code

/* a) Churn Rate: */

select count(*) as total_signed,
sum(case when terminated_at is not null then 1 else 0 end) as churned,
round(sum(case when terminated_at is not null then 1 else 0 end) * 100.0 / count(*), 2) as churn_rate_pct
from contracts
where signed_at is not null;

/* b) Average Subscription Lifetime: */

select round(avg(datediff(coalesce(terminated_at, now()),signed_at)), 1) as avg_lifetime_days,
round(avg(datediff(terminated_at, signed_at)), 1) AS avg_churned_lifetime_days
from contracts
where signed_at is not null;

/* c) Basic cohort analysis (by signup month): */

select date_format(c.signed_at, '%Y-%m') as cohort_month,
count(c.id) as cohort_size,
sum(case when c.state = 'rejected' then 1 else 0 end) as still_active,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days
from contracts c
where c.signed_at is not null
group by date_format(c.signed_at, '%Y-%m')
order by cohort_month;

/* d) Retention Comparison by Campaign: */

select coalesce(cs.campaign_name, 'Unknown') as campaign_name, count(c.id) as total_subscriptions,
sum(case when c.state = 'rejected' then 1 else 0 end) as active,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days
from contracts c
join contract_sign_up_details cs on c.id = cs.contract_id
where c.signed_at is not null
group by cs.campaign_name
order by retention_rate_pct DESC;

/* e) Retention Comparison by OS Family: */

select coalesce(csd.os_family, 'Unknown') as os_family,
count(c.id) as total_subscriptions, sum(case when c.state = 'rejected' then 1 else 0 end) as active,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days
from contracts c
join contract_sign_up_details csd on c.id = csd.contract_id
where c.signed_at is not null
group by csd.os_family
order by retention_rate_pct desc;

/* e) Retention Comparison by OS Family: */

select coalesce(cs.publisher_id, 'Unknown') as publisher_id,
count(c.id) AS total_subscriptions,
sum(case when c.state = 'rejected' then 1 else 0 end) as active,
round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as retention_rate_pct,
round(avg(datediff(coalesce(c.terminated_at, now()), c.signed_at)), 1) as avg_lifetime_days
from contracts c
join contract_sign_up_details cs ON c.id = cs.contract_id
where c.signed_at is not null
group by cs.publisher_id
order by retention_rate_pct desc;