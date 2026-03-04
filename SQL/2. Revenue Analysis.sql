-- SQLBook: Code

/* Total Revenue (Successful Billing Only): */

select
    count(*) as total_successful_billings,
    round(sum(amount_in_euro_cents) / 100, 2) as total_revenue_eur,
    round(sum(payout_amount_in_euro_cents) / 100, 2) as total_payout_eur
from billing_histories
where status = 'ok';

/* b) Revenue per Product: */

select
    product_identifier,
    product_type,
    count(*) as successful_billings,
    round(sum(amount_in_euro_cents) / 100, 2) as total_revenue_eur,
    round(sum(payout_amount_in_euro_cents) / 100, 2) as total_payout_eur,
    round(avg(amount_in_euro_cents) / 100, 4) as avg_billing_amount_eur
from billing_histories
where status = 'ok'
group by product_identifier, product_type
order by total_revenue_eur desc;

/* c) Revenue Trend Over Time (Monthly): */

select
    date_format(created_at, '%Y-%m') as billing_month,
    count(*) as successful_billings,
    round(sum(amount_in_euro_cents) / 100, 2) as monthly_revenue_eur,
    round(sum(payout_amount_in_euro_cents) / 100, 2) as monthly_payout_eur
from billing_histories
where status = 'ok'
group by date_format(created_at, '%Y-%m')
order by billing_month;


/* d) Average Revenue per Subscription: */

select round(sum(amount_in_euro_cents) / 100.0 / count(distinct contract_id), 2) as avg_revenue_per_subscription_eur
from billing_histories
where status = 'ok';

/* e) Revenue Grouped by Campaign: */

select coalesce(cs.campaign_name, 'Unknown') as campaign_name,
coalesce(cs.campaign_id, 'Unknown') as campaign_id, count(distinct bh.contract_id) as paying_subscriptions, round(sum(bh.amount_in_euro_cents) / 100, 2) as total_revenue_eur,
round(avg(bh.amount_in_euro_cents) / 100, 2) as avg_revenue_per_billing_eur, round(sum(bh.amount_in_euro_cents) / 100.0 / count(distinct bh.contract_id), 2) as revenue_per_subscription_eur
from billing_histories bh join contract_sign_up_details cs on bh.contract_id = cs.contract_id
where bh.status = 'ok'
group by cs.campaign_name, cs.campaign_id
order by total_revenue_eur desc;

/* f) Revenue Grouped by Publisher */

select coalesce(cs.publisher_id, 'Unknown') as publisher_id, COUNT(distinct bh.contract_id) as paying_subscriptions,
round(sum(bh.amount_in_euro_cents) / 100, 2) as total_revenue_eur,
round(sum(bh.amount_in_euro_cents) / 100.0 / count(distinct bh.contract_id), 2) as revenue_per_subscription_eur
from billing_histories bh
join contract_sign_up_details cs ON bh.contract_id = cs.contract_id
where bh.status = 'ok'
group by cs.publisher_id
order by total_revenue_eur desc;
