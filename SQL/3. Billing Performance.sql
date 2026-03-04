-- SQLBook: Code

/* a) Total Billing Attempts with Overall Success vs Failure Rate */

select count(*) as total_attempts, sum(case when status = 'ok' then 1 else 0 end) as successful,
sum(case when status != 'ok' then 1 else 0 end) as failed, 
round(sum(case when status = 'ok' then 1 else 0 end) * 100.0 / count(*), 2) as success_rate_pct
from billing_histories;

/* b) Success Rate per Product: */

select product_identifier, product_type,
count(*) AS total_attempts,
sum(case when status = 'ok' then 1 else 0 end) as successful,
round(sum(case when status = 'ok' then 1 else 0 end) * 100.0 / count(*), 2) as success_rate_pct
from billing_histories
group by product_identifier, product_type
order by success_rate_pct desc;

/* c) Billing Failure Breakdown by Reason: */

select status, reason, count(*) as occurrences,
round(count(*) * 100.0 / sum(count(*)) over(), 2) as pct_of_all_attempts
from billing_histories
where status != 'ok'
group by status, reason
order by occurrences desc;

/* d) Success Rate by Campaign: */

select coalesce(cs.campaign_name, 'Unknown') as campaign_name,
count(bh.id) AS total_attempts,
sum(case when bh.status = 'ok' then 1 else 0 end) AS successful,
round(sum(case when bh.status = 'ok' then 1 else 0 end) * 100.0 / count(bh.id), 2) as success_rate_pct
from billing_histories bh
join contract_sign_up_details cs ON bh.contract_id = cs.contract_id
group by cs.campaign_name
order by success_rate_pct desc;