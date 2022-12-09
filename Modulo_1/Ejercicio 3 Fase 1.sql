SELECT
date_trunc ('month', date(interaction_start_time)) as mo,
interaction_purpose_descrip,
count(distinct interaction_id) as interactions
FROM "db-stage-prod"."interactions_cwp" 
where year(interaction_start_time)=2022 
and month(interaction_start_time)=8
group by 1,2
