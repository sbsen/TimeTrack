/****** Object:  StoredProcedure [dbo].[EMPLOYEE_ACTIVITY_WISE_SUMMARY_REPORT]    Script Date: 11/10/2016 18:20:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE_ACTIVITY_WISE_SUMMARY_REPORT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[EMPLOYEE_ACTIVITY_WISE_SUMMARY_REPORT]
GO

/****** Object:  StoredProcedure [dbo].[EMPLOYEE_DATEWISE_SUMMARY_REPORT]    Script Date: 11/10/2016 18:21:02 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE_DATEWISE_SUMMARY_REPORT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[EMPLOYEE_DATEWISE_SUMMARY_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[GET_EMPLOYEE_BASED_ON_PROJECTID]    Script Date: 11/10/2016 18:21:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[GET_EMPLOYEE_BASED_ON_PROJECTID]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[GET_EMPLOYEE_BASED_ON_PROJECTID]
GO

GO
/****** Object:  StoredProcedure [dbo].[TREX_CATEGORY_REPORT]    Script Date: 12/16/2015 15:55:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TREX_CATEGORY_REPORT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TREX_CATEGORY_REPORT]
GO

/****** Object:  StoredProcedure [dbo].[TREX_CATEGORY_REPORT]    Script Date: 12/16/2015 15:55:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--drop table #FirstTable 

CREATE PROCEDURE [dbo].[TREX_CATEGORY_REPORT](@FROMDATE DATETIME,@TODATE DATETIME)
AS
BEGIN
SET FMTONLY OFF;
CREATE  TABLE  #FirstTable 
(
     Resource    VARCHAR(max)
	  ,Role varchar(max)
	  ,groupname   VARCHAR(max)
      ,hours      decimal
)



insert into #FirstTable(resource,role,groupname,hours) select
 
 e.lastname+ ' '+e.firstname  as Employeename
 ,r.name
 ,mg.group_name,
t.hours
from employees e with(nolock)
inner join EmployeeRoles er with(nolock) on er.employeeid=e.id
inner join roles r with(nolock) on r.id=er.roleid
inner join Tasks t with(nolock) on t.employeeid=e.id
inner join MTS_WORK_GROUP_MAPPING mpgm with(nolock) on mpgm.work_id=t.workcodeid
inner join MTS_GROUPS mg with(nolock) on mg.group_id=mpgm.group_id
where t.executiondate >= @FROMDATE and t.executiondate <= @TODATE

--select * from #FirstTable

DECLARE @cols NVARCHAR (MAX)

SELECT @cols = COALESCE (@cols + ',[' + groupname + ']', '[' + groupname + ']')
               FROM (SELECT DISTINCT groupname FROM #FirstTable) PV 
               ORDER BY groupname 
SELECT @cols += ',[Total]'

DECLARE @NulltoZeroCols NVARCHAR (MAX)
SELECT @NullToZeroCols = SUBSTRING((SELECT ',ISNULL(['+groupname+'],0) AS ['+groupname+']' 
FROM (SELECT DISTINCT groupname FROM #FirstTable)TAB  
ORDER BY groupname FOR XML PATH('')),2,8000) 

SELECT @NullToZeroCols += ',ISNULL([Total],0) AS [Total]'

DECLARE @query NVARCHAR(MAX)
SET @query = 'SELECT P.Resource,T.Role,' + @NulltoZeroCols + ' FROM 
             (                
                 SELECT 
                 ISNULL(CAST(resource AS VARCHAR(MAX)),''Total'')resource, 
                 SUM(hours)hours , 
                 ISNULL(groupname,''Total'')groupname              
                 FROM #FirstTable
                 GROUP BY groupname,resource
                 WITH CUBE                   
             ) x
             PIVOT 
             (
                 SUM(hours)
                 FOR groupname IN (' + @cols + ')
            ) p
            LEFT JOIN
            (  
                SELECT DISTINCT Resource,Role
                FROM #FirstTable  
            )T
            ON P.Resource=T.Resource
            ORDER BY CASE WHEN (P.Resource=''Total'') THEN 1 ELSE 0 END,P.Resource' 

EXEC SP_EXECUTESQL @query

drop table #FirstTable 

END


GO



/****** Object:  StoredProcedure [dbo].[GET_EMPLOYEE_BASED_ON_PROJECTID]    Script Date: 11/11/2016 2:51:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_EMPLOYEE_BASED_ON_PROJECTID]
	-- Add the parameters for the stored procedure here
	(@PROJECT_ID INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT E.ID AS EMPLOYEEID
		,E.LASTNAME + '' + E.FIRSTNAME AS EMPLOYEENAME
	FROM EMPLOYEES E
	INNER JOIN TASKS T ON T.EMPLOYEEID = E.ID
	WHERE T.PROJECTID = ISNULL(@PROJECT_ID, T.PROJECTID)
	GROUP BY E.LASTNAME
		,E.FIRSTNAME
		,E.ID
END
GO



/****** Object:  StoredProcedure [dbo].[EMPLOYEE_ACTIVITY_WISE_SUMMARY_REPORT]    Script Date: 11/10/2016 18:20:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EMPLOYEE_ACTIVITY_WISE_SUMMARY_REPORT] (
	@FROMDATE DATETIME
	,@TODATE DATETIME
	,@PROJECT_ID INT
	,@LOCATION_ID INT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @PROJECT_ID = 0
		SET @PROJECT_ID = NULL

	IF @LOCATION_ID = 0
		SET @LOCATION_ID = NULL

	CREATE TABLE #ACTIVITY_TABLE (
		Resource VARCHAR(MAX)
		,Activity_Name VARCHAR(MAX)
		,Hours DECIMAL
		)

	INSERT INTO #ACTIVITY_TABLE (
		Resource
		,Activity_Name
		,Hours
		)
	SELECT E.LASTNAME + ' ' + E.FIRSTNAME AS Resource
		,REPLACE(WC.NAME, '&', ' AND ') AS ACTIVITY_NAME
		,SUM(T.Hours) AS TOTALHOURS
	FROM EMPLOYEES E WITH (NOLOCK)
	INNER JOIN TASKS T WITH (NOLOCK) ON T.EMPLOYEEID = E.ID
	INNER JOIN WORKCODES WC WITH (NOLOCK) ON WC.ID = T.WORKCODEID
	INNER JOIN PROJECTS PJ WITH (NOLOCK) ON T.PROJECTID = PJ.ID
	INNER JOIN LOCATIONS L WITH (NOLOCK) ON E.LOCATIONID = L.ID
	WHERE T.EXECUTIONDATE >= @FROMDATE
		AND T.EXECUTIONDATE <= @TODATE
		AND T.PROJECTID = isnull(@PROJECT_ID, T.PROJECTID)
		AND L.ID = isnull(@LOCATION_ID, E.LocationId)
	GROUP BY WC.NAME
		,E.FIRSTNAME
		,E.LASTNAME

	--SELECT * FROM #ACTIVITY_TABLE
	DECLARE @COLS NVARCHAR(MAX)

	SELECT @COLS = COALESCE(@COLS + ',[' + Activity_Name + ']', '[' + Activity_Name + ']')
	FROM (
		SELECT DISTINCT Activity_Name
		FROM #ACTIVITY_TABLE
		) AT
	ORDER BY Activity_Name

	SELECT @COLS += ',[Total]'

	--select @COLS
	DECLARE @NULLTOZEROCOLS NVARCHAR(MAX)

	SELECT @NULLTOZEROCOLS = SUBSTRING((
				SELECT ',ISNULL([' + Activity_Name + '],0) AS [' + Activity_Name + ']'
				FROM (
					SELECT DISTINCT Activity_Name
					FROM #ACTIVITY_TABLE
					) NULLTOZEROS
				ORDER BY Activity_Name
				FOR XML PATH('')
				), 2, 8000)

	SELECT @NULLTOZEROCOLS += ',ISNULL([Total],0) AS [Total]'

	--select @NULLTOZEROCOLS
	DECLARE @QUERY NVARCHAR(MAX)

	SET @QUERY = 'SELECT P.Resource,' + @NULLTOZEROCOLS + ' FROM 
				 (                
					 SELECT 
					 ISNULL(CAST(RESOURCE AS VARCHAR(MAX)),''Total'')Resource, 
					 SUM(Hours)Hours , 
					 ISNULL(Activity_Name,''Total'')Activity_Name              
					 FROM #ACTIVITY_TABLE
					 GROUP BY Activity_Name,Resource
					 WITH CUBE                   
				 ) X
				 PIVOT 
				 (
					 SUM(Hours)
					 FOR Activity_Name IN (' + @COLS + ')
				) P
				LEFT JOIN
				(  
					SELECT DISTINCT Resource
					FROM #ACTIVITY_TABLE 
					group by Resource  
				)T
				ON P.Resource=T.Resource
				ORDER BY CASE WHEN (P.Resource=''Total'') THEN 1 ELSE 0 END,P.Resource'

	EXEC SP_EXECUTESQL @QUERY

	DROP TABLE #ACTIVITY_TABLE
END
GO

/****** Object:  StoredProcedure [dbo].[EMPLOYEE_DATEWISE_SUMMARY_REPORT]    Script Date: 11/10/2016 18:21:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[EMPLOYEE_DATEWISE_SUMMARY_REPORT] (
	@FROMDATE DATETIME
	,@TODATE DATETIME
	,@PROJECT_ID INT
	,@RESOURCE_ID INT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	IF @PROJECT_ID = 0
	BEGIN
		SET @PROJECT_ID = NULL
	END

	IF @RESOURCE_ID = 0
	BEGIN
		SET @RESOURCE_ID = NULL
	END

	CREATE TABLE #EMP_TABLE (
		DATE DATETIME
		,Activity_Name VARCHAR(MAX)
		,Hours DECIMAL
		)

	INSERT INTO #EMP_TABLE (
		DATE
		,Activity_Name
		,Hours
		)
	SELECT T.EXECUTIONDATE AS DATE
		,REPLACE(WC.NAME, '&', 'AND') AS ACTIVITY_NAME
		,SUM(T.Hours) AS TOTALHOURS
	FROM EMPLOYEES E WITH (NOLOCK)
	INNER JOIN EMPLOYEEROLES ER WITH (NOLOCK) ON ER.EMPLOYEEID = E.ID
	INNER JOIN TASKS T WITH (NOLOCK) ON T.EMPLOYEEID = E.ID
	INNER JOIN WORKCODES WC WITH (NOLOCK) ON WC.ID = T.WORKCODEID
	INNER JOIN PROJECTS PJ WITH (NOLOCK) ON T.PROJECTID = PJ.ID
	WHERE T.EXECUTIONDATE >= @FROMDATE
		AND T.EXECUTIONDATE < @TODATE + 1
		AND PJ.ID = ISNULL(@PROJECT_ID, PJ.ID)
		AND E.ID = ISNULL(@RESOURCE_ID, E.ID)
	GROUP BY WC.NAME
		,T.EXECUTIONDATE

	-- select * from  #EMP_TABLE
	DECLARE @COLS NVARCHAR(MAX)

	SELECT @COLS = COALESCE(@COLS + ',[' + Activity_Name + ']', '[' + Activity_Name + ']')
	FROM (
		SELECT DISTINCT Activity_Name
		FROM #EMP_TABLE
		) ET
	ORDER BY Activity_Name

	SELECT @COLS += ',[Total]'

	--select @COLS  
	DECLARE @NULLTOZEROCOLS NVARCHAR(MAX)

	SELECT @NULLTOZEROCOLS = SUBSTRING((
				SELECT ',ISNULL([' + Activity_Name + '],0) AS [' + Activity_Name + ']'
				FROM (
					SELECT DISTINCT Activity_Name
					FROM #EMP_TABLE
					) NULLTOZEROS
				ORDER BY Activity_Name
				FOR XML PATH('')
				), 2, 8000)

	SELECT @NULLTOZEROCOLS += ',ISNULL([Total],0) AS [Total]'

	--select @NULLTOZEROCOLS  
	DECLARE @QUERY NVARCHAR(MAX)

	SET @QUERY = 'SELECT P.Date,' + @NULLTOZEROCOLS + ' FROM   
     (                  
      SELECT   
      ISNULL(CONVERT(VARCHAR(10), Date, 101),''Total'')Date,   
      SUM(Hours)Hours ,   
      ISNULL(Activity_Name,''Total'')Activity_Name                
      FROM #EMP_TABLE  
      GROUP BY Activity_Name,Date  
      WITH CUBE                     
     ) X  
     PIVOT   
     (  
      SUM(Hours)  
      FOR Activity_Name IN (' + @COLS + ')  
    ) P  
    LEFT JOIN  
    (    
     SELECT DISTINCT Date  
     FROM #EMP_TABLE   
     group by Date    
    )T  
    ON P.Date=T.Date  
    ORDER BY CASE WHEN (P.Date=''Total'') THEN 1 ELSE 0 END,P.Date'

	EXEC SP_EXECUTESQL @QUERY

	DROP TABLE #EMP_TABLE
END
GO
