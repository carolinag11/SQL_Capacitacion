WITH
Activos as(
SELECT
case when (date_diff('DAY',  cast (concat(substr(oldest_unpaid_bill_dt, 1,4),'-',substr(oldest_unpaid_bill_dt, 5,2),'-', substr(oldest_unpaid_bill_dt, 7,2)) as date), cast(dt as date)))>=90 then 'Inactivo'
else 'Activo'
end as overdue,
account_id
FROM "db-analytics-prod"."tbl_postpaid_cwc"
where account_type='Residential'
and org_id = '338'
and dt='2022-10-01'
order by 1
),
OrdenesServicio as (
select
cast(account_id as Varchar) as account_id,
date(date_trunc('month',order_start_date)) as mo
from "db-stage-dev"."so_hdr_cwc"
where date(date_trunc('month',order_start_date))=date('2022-10-01')
)

select
count(distinct a.account_id) as users
from Activos a
inner join OrdenesServicio b
on a.account_id=b.account_id
where overdue='Activo'
