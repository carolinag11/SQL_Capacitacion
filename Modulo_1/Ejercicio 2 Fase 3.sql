with
first_value_function as(
select
act_acct_cd,
date(dt) as date_dt,
first_value(date(dt)) over (partition by act_acct_cd order by dt desc) as first_value
from "db-analytics-prod"."fixed_cwp" 
where date(dt) between date('2022-07-01') and date('2022-08-31')
order by 1,2
),
Users_first_value as(
select
act_acct_cd,
first_value
from first_value_function
group by 1,2
)
select
distinct first_value,
count(distinct act_acct_cd)
from Users_first_value
where first_value<date('2022-08-31')
group by 1
order by 1
