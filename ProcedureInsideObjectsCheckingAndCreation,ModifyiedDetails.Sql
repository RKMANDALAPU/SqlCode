-------------------Identify the Procedure creation and Modify date------------------
SELECT name, create_date, modify_date
FROM sys.objects
WHERE type = 'P'
AND name = 'GetUserNamePassword'

-----------Finding the Objects used inside other Objects-------------------
SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
WHERE m.definition Like '%[ABD]%';
