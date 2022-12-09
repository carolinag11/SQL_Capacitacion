SELECT 
date_trunc('month',DATE(order_start_date)) as fecha,
count(distinct order_id) as orders
FROM "db-stage-dev"."so_hdr_cwc"
where org_cntry='Jamaica'
and account_type='Residential'
and year(date_trunc('month',order_start_date))=2022
group by 1
order by 1 asc
