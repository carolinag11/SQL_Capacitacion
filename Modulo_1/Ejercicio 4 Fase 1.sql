SELECT 
date_trunc('month', date(dt)) as fecha, 
case when date_diff('day', date(act_cust_strt_dt),date(dt))<180 then 'Early tenure'
when date_diff('day', date(act_cust_strt_dt),date(dt))<360 then 'Mid tenure'
else 'Late tenure'
end as tenure,
count(distinct act_acct_cd) as num_users
FROM "db-analytics-prod"."fixed_cwp" 
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(dt))>=date('2022-01-01') 
and date(dt)=date_trunc('month', date(dt))
group by 1,2
order by 1 asc
