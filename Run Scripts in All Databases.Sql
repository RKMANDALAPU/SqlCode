------------------Run Scripts in All Databases------------------
DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
EXEC sp_MSforeachdb @command 
