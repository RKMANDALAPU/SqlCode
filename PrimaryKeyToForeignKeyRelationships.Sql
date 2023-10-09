------------------PrimaryKey To ForeignKey Relationship ------------------

SELECT o2.name AS Referenced_Table_Name,
       c2.name AS Referenced_Column_As_FK,
       o1.name AS Referencing_Table_Name,
       c1.name AS Referencing_Column_Name,
s.name AS Constraint_name
FROM  sysforeignkeys fk
INNER JOIN sysobjects o1 ON fk.fkeyid = o1.id
INNER JOIN sysobjects o2 ON fk.rkeyid = o2.id
INNER JOIN syscolumns c1 ON c1.id = o1.id AND c1.colid = fk.fkey
INNER JOIN syscolumns c2 ON c2.id = o2.id AND c2.colid = fk.rkey
INNER JOIN sysobjects s ON fk.constid = s.id
ORDER BY o2.name
