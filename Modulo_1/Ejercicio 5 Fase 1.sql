SELECT
date_trunc('month',date(dt)) as mo,
case when (date_diff('DAY',  cast (concat(substr(oldest_unpaid_bill_dt, 1,4),'-',substr(oldest_unpaid_bill_dt, 5,2),'-', substr(oldest_unpaid_bill_dt, 7,2)) as date), cast(dt as date)))>=90 then 'Inactivo'
else 'Activo'
end as overdue,
count(distinct account_id) as num_users
FROM "db-analytics-prod"."tbl_postpaid_cwc"
where account_type='Residential'
and org_id = '338'
and dt='2022-10-01'
group  by 1,2
order by 1
