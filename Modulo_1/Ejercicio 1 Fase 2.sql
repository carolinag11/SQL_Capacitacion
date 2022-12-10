WITH 
Truckrolls as (
select
account_id,
date_trunc('month', date(interaction_start_time)) as fecha1,
interaction_purpose_descrip,
concat(cast(date_trunc('month', date(interaction_start_time))as varchar),'/',account_id) as concatenado
from "db-stage-prod"."interactions_cwp" 
where interaction_purpose_descrip='TRUCKROLL' 
and date_trunc('month', date(interaction_start_time))>=date('2022-01-01') 
)
,
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
a.fecha,
count(distinct a.act_acct_cd) as users
from Users a
inner join Truckrolls b on a.concatenado=b.concatenado
group by 1
order by 1
