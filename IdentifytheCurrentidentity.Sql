# SqlCode

-------------------Identify the Current identity for given table------------------
SELECT IDENT_SEED(TABLE_SCHEMA+'.'+TABLE_NAME) AS Seed,
IDENT_INCR(TABLE_SCHEMA+'.'+TABLE_NAME) AS Increment,
IDENT_CURRENT(TABLE_SCHEMA+'.'+TABLE_NAME) AS Current_Identity,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE OBJECTPROPERTY(OBJECT_ID(TABLE_SCHEMA+'.'+TABLE_NAME), 'TableHasIdentity') = 1
AND TABLE_TYPE = 'BASE TABLE'
and  TABLE_NAME='tblResponseType'

select IDENT_CURRENT('tblResponseBatchMilestone')
