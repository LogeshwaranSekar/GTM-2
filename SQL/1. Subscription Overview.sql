-- SQLBook: Code
select count(*) from mozaic_db.org_contracts;
select count(*) from mozaic_db.org_billing_histories;
select count(*) from mozaic_db.org_contract_sign_up_details;

create table if not exists contracts as 
select id, created_at , terminated_at, state, product_identifier, payment_provider_config_profile_id, product_type, signed_at,
billing_histories_count, billing_histories_sum_in_euro_cents from org_contracts;

create table if not exists contract_sign_up_details as
select referrer, contract_id, campaign_id, campaign_name, publisher_id, device, os_family, remote_ip
from org_contract_sign_up_details;

create table if not exists billing_histories as
select id, created_at, reason, country, contract_id, status, amount_in_euro_cents, product_identifier, payout_amount_in_euro_cents, product_type
from org_billing_histories;

/* a) Total subscriptions: */
select
    count(*) as total_subscriptions,
    sum(case when state = 'rejected' then 1 else 0 end) as rejected_subscriptions,
    sum(case when terminated_at is not null then 1 else 0 end) as terminated_subscriptions
from contracts;

/* b) Subscriptions per product: */

select
    product_identifier,
    product_type,
    count(*) as total_subscriptions,
    sum(case when state = 'rejected' then 1 else 0 end) as active_subscriptions,
    sum(case when terminated_at is not null then 1 else 0 end) as churned_subscriptions
from contracts
group by product_identifier, product_type
order by total_subscriptions desc;

/* c) Signup Trend Over Time (Monthly): */

select date_format(signed_at, '%Y-%m') AS signup_month, COUNT(*) as new_subscriptions,
sum(count(*)) over (order by date_format(signed_at, '%Y-%m')) as cumulative_subscriptions
from contracts
where signed_at is not null
group by date_format(signed_at, '%Y-%m')
order by signup_month;
 
/* d) Subscriptions Grouped by Campaign: */

select
    coalesce(cs.campaign_name, 'Unknown') as campaign_name,
    coalesce(cs.campaign_id, 'Unknown') as campaign_id,
    count(c.id) as total_subscriptions,
    sum(case when c.state = 'rejected' then 1 else 0 end) as active_subscriptions
from contracts c
left join contract_sign_up_details cs on c.id = cs.contract_id
group by cs.campaign_name, cs.campaign_id
order by total_subscriptions desc;

/* e) Subscriptions Grouped by OS Family: */

select
    coalesce(cs.os_family, 'Unknown') as os_family,  
    count(c.id) as total_subscriptions,
    sum(case when c.state = 'rejected' then 1 else 0 end) as active_subscriptions,
    round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as active_rate_pct
from contracts c
left join contract_sign_up_details cs on c.id = cs.contract_id
group by cs.os_family
order by total_subscriptions desc;

/* f) Subscriptions Grouped by Publisher (Placement): */

select
    coalesce(cs.publisher_id, 'Unknown') as publisher_id,
    count(c.id) AS total_subscriptions,
    sum(case when c.state = 'rejected' then 1 else 0 end) as active_subscriptions,
    round(sum(case when c.state = 'rejected' then 1 else 0 end) * 100.0 / count(c.id), 2) as active_rate_pct
from contracts c
left join contract_sign_up_details cs on c.id = cs.contract_id
group by cs.publisher_id
order by total_subscriptions desc;