------------------ Column Level  DataSize ----------------------
IF OBJECT_ID(N'tempdb..#TablesList') IS NOT NULL
	BEGIN
		DROP TABLE #TablesList
	END

IF OBJECT_ID(N'tempdb..#DataSize') IS NOT NULL
	BEGIN
		DROP TABLE #DataSize
	END

create table #TablesList(id int identity(1,1),TABLE_NAME varchar(max),COLUMN_NAME varchar(max),DATA_TYPE varchar(max))
create table #DataSize(id int identity(1,1),TABLE_NAME varchar(max),COLUMN_NAME varchar(max),DATA_TYPE varchar(max),DataSizeInKb bigint)

insert into #TablesList(TABLE_NAME,COLUMN_NAME,DATA_TYPE)
select TABLE_NAME,COLUMN_NAME,DATA_TYPE from information_schema.columns
where Data_type like '%varbinary%'
and TABLE_NAME like 'tbl%'

select * from #TablesList
Declare @TABLE_NAME varchar(max)
,@COLUMN_NAME varchar(max)
,@MaxIdentity bigint
,@DATA_TYPE  varchar(max)
,@Query varchar(max)

select @MaxIdentity=max(id) from #TablesList
select @MaxIdentity
while @MaxIdentity>0
	begin
		select top 1 @TABLE_NAME=TABLE_NAME,@COLUMN_NAME=COLUMN_NAME,@DATA_TYPE=DATA_TYPE from #TablesList
		where id= @MaxIdentity

		print (@MaxIdentity)
		set @Query= 'select sum(DATALENGTH('+@COLUMN_NAME+')/1024) from '+@TABLE_NAME
		insert into #DataSize(DataSizeInKb)
		EXEC (@Query)

		update #DataSize
		set TABLE_NAME=@TABLE_NAME,COLUMN_NAME=@COLUMN_NAME,DATA_TYPE=@DATA_TYPE
		where TABLE_NAME is null

		set @MaxIdentity=@MaxIdentity-1
		print (@MaxIdentity)

	end
select * from #DataSize
