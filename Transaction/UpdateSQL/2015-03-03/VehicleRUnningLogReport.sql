
GO
/****** Object:  StoredProcedure [Vehicle].[VehicleRunningLogReportGet]    Script Date: 4/3/2015 3:44:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Created By : Babu Kumarasamy  
-- Modified By: Babu Kumarasamy, Gopinath 
-- Created date: 1st May 2009
-- Last Modified Date: 5th JUNE 2009
-- Module     : Vehicle  
-- Reports  : Vehicle_RunningLog_VH.rpt  
-- Description:	To fill the report Vehicle_RunningLog_VH.rpt
-- =============================================  
ALTER PROCEDURE [Vehicle].[VehicleRunningLogReportGet]
		@EstateID NVARCHAR(50),
		@ActiveMonthYearID NVARCHAR(50)
        --@LogedInMonth INT,
        --@LogedInYear  INT
        -- Add the parameters for the stored procedure here
AS
        BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
                -- Insert statements for procedure here
                SELECT VWMH.VHWSCode ,
                       ET.EstateCode ,
                       ET.EstateName,
                       --VWMH.VHWSCode,
                       VWMH.VHModel  ,
                       VWMH.VHDescp  ,
                       CASE WHEN VWMH.UOM = 'K' THEN 'Kms' 
                       WHEN VWMH.UOM = 'H' THEN 'Hrs' 
                       END AS UOM,
                       VRL.LogDate   ,
                       CR.EmpName    ,
                       VRL.Activity  ,
                       Cast(VRL.StartTime as nvarchar(50)) as StartTime ,
                       Cast(VRL.EndTime as nvarchar(50)) as EndTime   ,
                       VRL.TotalHrs 
                FROM   Vehicle.VHRunningLog                 AS VRL
                       --INNER JOIN Vehicle.VHWSMasterHistory AS VWMH
                       --ON     VWMH.VHID = VRL.VHID
                       INNER JOIN General.ActiveMonthYear GMY 
       				   ON VRL.ActiveMonthYearID = GMY.ActiveMonthYearID
       				   INNER JOIN Vehicle.VHWSMasterHistory AS VWMH
       				   ON VRL.VHID = VWMH.VHID AND VWMH.AMonth = GMY.AMonth AND VWMH.AYear = GMY.AYear --@LogedInMonth AND VWMH.AYear = @LogedInYear 
                       LEFT JOIN Checkroll.CREmployee AS CR
                       ON     VRL.NIK = CR.EmpID
                       INNER JOIN General.Estate AS ET
                       ON     ET.EstateID = VRL.EstateID
                       INNER JOIN Vehicle.VHCategory VHC
                       ON VHC.VHCategoryID = VWMH.VHCategoryID
                WHERE  VRL.EstateID       = @EstateID
                   --AND YEAR(VRL.LogDate)  = @LogedInYear
                   --AND MONTH(VRL.LogDate) = @LogedInMonth
                   AND VRL.ActiveMonthYearID = @ActiveMonthYearID
                   --AND VRL.TotalHrs <> '00:00'
                   --AND VHC.Category <> 'LV'
                   AND VRL .Posted ='Y'
                ORDER BY VHWSCode, LogDate
         END
