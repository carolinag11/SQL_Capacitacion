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
),

first_value_function as(
select
act_acct_cd,
date(dt) as date_dt,
first_value(date(dt)) over (partition by act_acct_cd order by dt desc) as first_value
from active
order by 1,2
)

select
first_value,
count(distinct act_acct_cd)
from first_value_function
where first_value between date('2022-07-01') and date('2022-08-31')
group by 1
order by 1


