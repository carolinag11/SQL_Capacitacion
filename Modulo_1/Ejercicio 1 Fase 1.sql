SELECT 
date_trunc('month', date(dt)) as fecha, count(distinct act_acct_cd) as num_users
FROM "db-analytics-prod"."fixed_cwp" 
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(dt))>=date('2022-01-01') 
and date(dt)=date_trunc('month', date(dt))
group by 1
order by 1 asc
