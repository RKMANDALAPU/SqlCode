------------------sp operations------------------
;with SP as
(
select
( OBJECT_NAME(dp.referenced_major_id)) as table_name ,
OBJECT_NAME(dp.object_id) as sp_name,
db_name() as 'DB_Name',
schema_name(ob.schema_id) as 'Schema_Name',
(dp.is_updated) as IS_DML_OPR,

case when is_selected=0 and is_select_all=0 then 0
when is_selected=0 and is_select_all=1 then 1
when is_selected=1 and is_select_all=0 then 1
when is_selected=1 and is_select_all=1 then 1
end as RD_OPR
--select top 10 *
from sys.sql_dependencies dp with (nolock)

left join sys.objects ob
on dp.object_id=ob.object_id
)
select DB_Name,Schema_Name,sp_name,table_name ,max(cast(RD_OPR as int)) as RD_OPR, max(cast(IS_DML_OPR as int)) as IS_DML_OPR
from SP with (nolock)
where sp_name = 'uspGetNextFeed'
group by DB_Name,Schema_Name,sp_name,table_name
