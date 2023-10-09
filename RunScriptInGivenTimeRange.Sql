------------------Run Script In Given Time Range------------------ 

declare @start_time datetime= getdate() -----Script Starting Time   
,@min_pk_id  bigint= 23963980 ------Min PK ID
,@max_pk_id  bigint= 33016488 ------MAX PK ID
,@cur_pk_id  bigint= 33016488 ------MAX PK ID FOR CONDITION
,@rows_to_delete  bigint= 5000 ----ROW TO DELETION COUNT FOR EXEC
,@complete_flg int = 0 ---JUST A FLAG
,@date_time datetime= dateadd(year,-1,getdate())----DATE RANGE


WHILE (@complete_flg = 0 AND dateadd(minute, -15, getdate()) < @start_time)

begin

			
			set @cur_pk_id = @cur_pk_id - @rows_to_delete ---TAKING RECORD TO BE DELETE
			
			delete top(5000)  from tblPortalGeneratedFullEOB  
			WHERE [PortalGeneratedFullEOBID] >= @cur_pk_id and instamp >dateadd(year,-1,getdate())
			
            print @cur_pk_id			   



    IF @cur_pk_id < @min_pk_id 
		begin
			set @cur_pk_id = @min_pk_id
			set @complete_flg = 1
		end
		
end
