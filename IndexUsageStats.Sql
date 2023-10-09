-------------------Index Usage Stats------------------
SELECT
    objects.name AS Table_name,
    indexes.name AS Index_name,
    dm_db_index_usage_stats.user_seeks,
    dm_db_index_usage_stats.user_scans,
    dm_db_index_usage_stats.user_updates
FROM
    sys.dm_db_index_usage_stats
    INNER JOIN sys.objects ON dm_db_index_usage_stats.OBJECT_ID = objects.OBJECT_ID
    INNER JOIN sys.indexes ON indexes.index_id = dm_db_index_usage_stats.index_id AND dm_db_index_usage_stats.OBJECT_ID = indexes.OBJECT_ID
WHERE
    indexes.is_primary_key = 0 -- This condition excludes primary key constarint
    AND
    indexes. is_unique = 0 -- This condition excludes unique key constarint
    AND
    dm_db_index_usage_stats. user_lookups = 0
    AND
    dm_db_index_usage_stats.user_seeks = 0
    AND
    dm_db_index_usage_stats.user_scans = 0
ORDER BY objects.name
    ,dm_db_index_usage_stats.user_updates DESC

SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT 
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (db_id(),NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS I 
         ON I.[OBJECT_ID] = A.[OBJECT_ID] 
            AND I.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1
