WITH
Interactions as(
select
account_id,
date_trunc('month', date(interaction_start_time)) as fecha1,
interaction_purpose_descrip,
concat(cast(date_trunc('month', date(interaction_start_time))as varchar),'/',account_id) as concatenado
from "db-stage-prod"."interactions_cwp" 
where date_trunc('month', date(interaction_start_time))>=date('2022-01-01') 
)
,
Orders as(
select
cast(account_id as varchar) as account_id,
date(date_trunc('month',order_start_date)) as fecha,
concat(cast(date_trunc('month', date(order_start_date))as varchar),'/',cast(account_id as varchar)) as concatenado
from "db-stage-dev"."so_hdr_cwp"
),

Users as(
SELECT 
date_trunc('month', date(dt)) as fecha, 
act_acct_cd,
concat(cast(date_trunc('month', date(dt))as varchar),'/',act_acct_cd) as concatenado
FROM "db-analytics-prod"."fixed_cwp" 
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(dt))>=date('2022-01-01') 
and date(dt)=date_trunc('month', date(dt))
order by 1 asc
)

select
a.fecha1,
count(distinct a.account_id) as users
from Interactions a
inner join Orders b on a.concatenado=b.concatenado
inner join Users c on a.concatenado=c.concatenado
group by 1
order by 1
