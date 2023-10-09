-------------------Col Level Index Size------------------

SELECT 
SCHEMA_NAME(tbl.[schema_id]) SchemaName,
		tbl.[name] AS TableName,
		ColumnName = col.name,
		idx.[name] AS IndexName,
		SUM(dps.[used_page_count]) * 8/1024 AS IndexSizeInMB

FROM sys.dm_db_partition_stats AS dps
		INNER JOIN sys.indexes AS idx ON dps.[object_id] = idx.[object_id]
									   AND dps.[index_id] = idx.[index_id]
		INNER JOIN sys.index_columns ic ON  idx.object_id = ic.object_id 
										and idx.index_id = ic.index_id 
		INNER JOIN sys.columns col ON ic.object_id = col.object_id 
		and ic.column_id = col.column_id
	 INNER JOIN sys.tables tbl ON tbl.[object_id] = idx.[object_id] 

		-----and tbl.[name]='tblNCPDPInbox'
GROUP BY tbl.[name], col.name,idx.[name], tbl.[schema_id]
ORDER BY IndexSizeInMB DESC
