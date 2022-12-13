SELECT 
date_trunc('month', date(a.dt)) as fecha, 
count(distinct act_acct_cd) as users
FROM "db-analytics-prod"."fixed_cwp" a
inner join "db-stage-prod"."interactions_cwp" b
on a.act_acct_cd=b.account_id
and date_trunc('month', date(a.dt))=date_trunc('month', date(b.interaction_start_time))
where act_cust_typ_nm='Residencial'
and date_trunc('month', date(a.dt))>=date('2022-01-01') 
and date(a.dt)=date_trunc('month', date(a.dt))
and pd_bb_prod_cd is not null
and interaction_purpose_descrip='TRUCKROLL' 
and date_trunc('month', date(interaction_start_time))>=date('2022-01-01') 
group by 1
order by 1 asc
