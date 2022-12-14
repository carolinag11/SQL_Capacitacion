WITH
active as(
SELECT 
act_acct_cd,
date_trunc('month', date(dt)) as fecha
FROM "db-analytics-prod"."fixed_cwp" 
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(dt))>=date('2022-01-01') 
and fi_outst_age <90 or fi_outst_age is null 
)
,
Dx_40days as(
select
a.account_id,
date(interaction_start_time) as int_date,
date(order_start_date) as dx_date,
date_diff('day',date(a.interaction_start_time),date(b.order_start_date))
from "db-stage-prod"."interactions_cwp" a
inner join "db-stage-dev"."so_hdr_cwp" b
on a.account_id=cast(b.account_id as varchar)
and date_diff('day',date(a.interaction_start_time),date(b.order_start_date))<=40 and date_diff('day',date(a.interaction_start_time),date(b.order_start_date))>=0
where b.order_start_date>=date('2022-01-01') 
and a.interaction_start_time>=date('2022-01-01')
and order_type='DEACTIVATION'
)

select
count(distinct act_acct_cd)
from active a 
inner join Dx_40days b
on a.act_acct_cd=b.account_id
--and a.fecha=b.int_date
