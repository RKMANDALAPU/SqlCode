-------------------Count No of working days in date range------------------
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = '2023/08/05'
SET @EndDate = '2023/08/11'

SELECT
   (DATEDIFF(dd, @StartDate, @EndDate) + 1)
  -(DATEDIFF(wk, @StartDate, @EndDate) * 2)
  -(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)
