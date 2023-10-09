https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-cached-plans-transact-sql?view=sql-server-ver16
https://www.sqlshack.com/understanding-sql-server-query-plan-cache/
https://stackoverflow.com/questions/57797571/sql-script-run-history-checking


----------------Most Used Sql Objects List-----------------------
SELECT
DatabaseName = DB_NAME(st.dbid)
,SchemaName = OBJECT_SCHEMA_NAME(st.objectid,dbid)
,StoredProcedure = OBJECT_NAME(st.objectid,dbid)
,cp.objtype,ExecutionCount = MAX(cp.usecounts)
,st.text
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
WHERE DB_NAME(st.dbid) IS NOT NULL
AND cp.objtype != 'proc'
GROUP BY
cp.plan_handle
,DB_NAME(st.dbid)
,OBJECT_SCHEMA_NAME(objectid,st.dbid)
,OBJECT_NAME(objectid,st.dbid)
,cp.objtype
,st.text
ORDER BY MAX(cp.usecounts) DESC

------------------Most Executed Objects Count ------------------
select DB_NAME(st.dbid)
,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
,OBJECT_NAME(ST.OBJECTID) oBJECT_Name
,cp.objtype
,max(cp.usecounts) Execution_count
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
where OBJECT_NAME(ST.OBJECTID) is not null
group by st.dbid,st.objectid,cp.objtype
order by max(cp.usecounts) desc
