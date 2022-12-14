WITH
active as(
SELECT 
act_acct_cd,
date_trunc('month', date(dt)) as fecha,
dt
FROM "db-analytics-prod"."fixed_cwp" 
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(dt))>=date('2022-01-01') 
and (fi_outst_age <90 or fi_outst_age is null)
)

select
date_trunc('month',date(a.dt)),
count (distinct act_acct_cd)
--act_acct_cd,
--date(a.dt) as active_date,
--date(interaction_start_time) as int_date,
--date(order_start_date) as order_date
from active a 
inner join "db-stage-prod"."interactions_cwp" b
on a.act_acct_cd=b.account_id
and date(a.dt)=date(b.interaction_start_time)
inner join "db-stage-dev"."so_hdr_cwp" c
on a.act_acct_cd=cast(c.account_id as varchar)
where date_diff('day',date(interaction_start_time),date(order_start_date))<=40
and date_diff('day',date(interaction_start_time),date(order_start_date))>=0
group by 1
order by 1
