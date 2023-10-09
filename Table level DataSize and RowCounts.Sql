------------------- Table level DataSize and RowCounts -------------------
IF OBJECT_ID(N'tempdb..#TableList') IS NOT NULL
BEGIN
DROP TABLE #TableList
END
GO

IF OBJECT_ID(N'tempdb..##TableRecordsSize') IS NOT NULL
BEGIN
DROP TABLE ##TableRecordsSize
END
GO

Create table ##TableRecordsSize(name	varchar(100)
,rows_count bigint
,reserved varchar(100)
,data	varchar(100)
,index_size	varchar(100)
,unused varchar(100)
)
 
CREATE TABLE #TableList
(
 id int identity(1,1),
 TableName varchar(500) 
 
)
Insert into #TableList(TableName)
select name from sys.tables 

Declare @id int,@TableName varchar(100)
select @id=max(id) from #TableList

while @id>0
begin
select @TableName=TableName from #TableList where id=@id

insert into ##TableRecordsSize
exec sp_spaceused @TableName

set @id=@id-1
end

select 
Name AS TableName
,rows_count AS RowCounts
,CAST(replace(reserved,'KB','') AS bigint)/1024 AS TotalSpaceMB
,SUM(CAST(replace(data,'KB','') AS bigint)+CAST(replace(index_size,'KB','') AS bigint))/1024 AS UsedSpaceMB
,CAST(replace(unused,'KB','') AS bigint)/1024 AS UnUsedSpaceMB
from ##TableRecordsSize
GROUP BY Name,rows_count,reserved,unused


------------------ Table Level Row Count With DataSize ------------------
;with cte as
(
SELECT
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name, s.Name, p.Rows
--ORDER BY s.Name, t.Name
)
select TableName
,sum(RowCounts) as RowCounts
,sum(Total_MB) as Total_MB
,sum(Used_MB) as Used_MB
,sum(Unused_MB) as Unused_MB 
from cte 
group by TableName


SELECT
t.NAME AS TableName,
MAX(p.rows) AS RowCounts,
(SUM(a.total_pages) * 8) / 1024.0 as TotalSpaceMB,
(SUM(a.used_pages) * 8) / 1024.0 as UsedSpaceMB,
(SUM(a.data_pages) * 8) /1024.0 as DataSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE i.OBJECT_ID > 255
AND i.index_id IN (0,1)
GROUP BY t.NAME
ORDER BY TotalSpaceMB DESC


-------------------------------------------------------------------------------------
SELECT
t.NAME AS TableName,
i.name as indexName,
p.[Rows],
sum(a.total_pages) as TotalPages,
sum(a.used_pages) as UsedPages,
sum(a.data_pages) as DataPages,
(sum(a.total_pages) * 8) / 1024 as TotalSpaceMB,
(sum(a.used_pages) * 8) / 1024 as UsedSpaceMB,
(sum(a.data_pages) * 8) / 1024 as DataSpaceMB
FROM 
sys.tables t
INNER JOIN
sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN
sys.allocation_units a ON p.partition_id = a.container_id
WHERE
--t.NAME NOT LIKE 'dt%' AND
--i.OBJECT_ID > 255 AND
i.index_id <= 1
and
t.Name = 'tblClaimOutboundStore' and t.type_desc = 'USER_TABLE'
GROUP BY
t.NAME, i.object_id, i.index_id, i.name, p.[Rows]

------------------Table Data Size------------------

select 
Table_Name
,Table_Rows
,(CAST((replace(reserved,' KB','')) AS DECIMAL(10,2))/1024) AS Reserved_Space_MB
,(CAST((replace(data,' KB','')) AS DECIMAL(10,2))/1024) AS Data_Space_MB
,(CAST((replace(index_size,' KB','')) AS DECIMAL(10,2))/1024) AS Index_Size_MB
,(CAST((replace(unused,' KB','')) AS DECIMAL(10,2))/1024)  AS Unused_Space_MB
from #TEMP

select 
Table_Name
,Table_Rows
,(CAST((replace(reserved,' KB','')) AS DECIMAL(10,2))/1024)/1024 AS Reserved_Space_GB
,(CAST((replace(data,' KB','')) AS DECIMAL(10,2))/1024)/1024 AS Data_Space_GB
,(CAST((replace(index_size,' KB','')) AS DECIMAL(10,2))/1024)/1024 AS Index_Size_GB
,(CAST((replace(unused,' KB','')) AS DECIMAL(10,2))/1024)/1024  AS Unused_Space_GB
from #TEMP


SELECT db_name() as DB,
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts
,CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages)-SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB
,CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
where t.Name = 'tblClaimOutboundStore'
GROUP BY t.Name, s.Name, p.Rows
ORDER BY s.Name, t.Name
