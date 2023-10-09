-------------------Partition Level Data Size ------------------

USE COMM
SELECT sizes.[schema], sizes.[tableName], sizes.[partition], sizes.[rowCount], sizes.[totalSpaceMB] 
FROM (
    SELECT sch.[name] AS [schema], 
        t.[NAME] AS [tableName], 
        p.[rows] AS [rowCount], 
        ((SUM(a.total_pages) * 8) / 1024) AS [totalSpaceMB], 
        CONVERT(date, prv.[value]) AS [partition]
    FROM sys.tables t WITH(NOLOCK)
    INNER JOIN sys.indexes i WITH(NOLOCK) ON t.OBJECT_ID = i.object_id
    INNER JOIN sys.partitions p WITH(NOLOCK) ON i.object_id = p.OBJECT_ID 
        AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a WITH(NOLOCK) ON p.partition_id = a.container_id
    INNER JOIN sys.schemas sch WITH(NOLOCK) ON t.schema_id = sch.schema_id
    LEFT OUTER JOIN sys.partition_schemes ps WITH(NOLOCK) ON ps.data_space_id = i.data_space_id
    LEFT OUTER JOIN sys.partition_range_values prv WITH(NOLOCK) ON ps.function_id = prv.function_id 
        AND p.partition_number = prv.boundary_id
    WHERE t.is_ms_shipped = 0 
    AND (ps.[name] IS NULL OR (prv.[value] IS NOT NULL AND p.[rows] > 0))
    GROUP BY t.[Name], sch.[name], p.[Rows], prv.[value]
) sizes
ORDER BY sizes.[schema] asc, sizes.[tableName] asc, sizes.[partition] desc

