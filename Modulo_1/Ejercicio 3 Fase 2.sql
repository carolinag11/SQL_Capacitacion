SELECT 
date_trunc('month', date(a.dt)) as fecha, 
count(distinct act_acct_cd) as users
FROM "db-analytics-prod"."fixed_cwp" a
inner join "db-stage-prod"."interactions_cwp" b
on a.act_acct_cd=b.account_id
and date_trunc('month', date(a.dt))=date_trunc('month', date(b.interaction_start_time))
inner join "db-stage-dev"."so_hdr_cwp" c
on a.act_acct_cd=cast(c.account_id as varchar)
and date_trunc('month', date(date_trunc('month', date(a.dt))))=date_trunc('month', date(c.order_start_date))
where date_trunc('month', date(order_start_date))>=date('2022-01-01')
and act_cust_typ_nm='Residencial'
and date_trunc('month', date(a.dt))>=date('2022-01-01') 
and date(a.dt)=date_trunc('month', date(a.dt))
and date_trunc('month', date(interaction_start_time))>=date('2022-01-01') 
group by 1
order by 1 asc
