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
num_interactions as (
select
account_id,
date_trunc('month',date(interaction_start_time)) as fecha_interaccion,
count(distinct interaction_id) as interactions_per_user
from "db-stage-prod"."interactions_cwp" a
inner join active b
on a.account_id=b.act_acct_cd
and date_trunc('month',date(interaction_start_time))=b.fecha
where date(date_trunc('month',interaction_start_time))>=date('2022-01-01')
and interaction_purpose_descrip='CLAIM'
group by 1,2
order by 2
),

classification_users as(
select
account_id,
fecha_interaccion,
interactions_per_user,
case when interactions_per_user=1 then 1 else null end as one_int_user,
case when interactions_per_user>1 then 1 else null end as more_than_1_int_user
from num_interactions a
)

select
fecha_interaccion,
sum(one_int_user) as one_int,
sum(more_than_1_int_user) as more_int
from classification_users
group by 1
order by 1
