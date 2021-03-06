USE [BSPMS_SR]
GO
/****** Object:  StoredProcedure [Checkroll].[AttendanceHarvNoReceiptionExists]    Script Date: 12/6/2014 3:11:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================  
-- Created By : Stanley  
-- Modified By:  
-- Created date: 08-Dec-2011
-- Last Modified Date:
-- ===================================================== 
ALTER PROCEDURE [Checkroll].[AttendanceHarvNoReceiptionExists]
-- Add the parameters for the stored procedure here
(
@EstateID nvarchar(50),                
@ActiveMonthYearID nvarchar(50),                
@FromDT date,                
@ToDT date
)

AS

Declare @Amonth int    
Declare @Ayear int    
Select @Amonth =Amonth, @Ayear =ayear from General.ActiveMonthYear where EstateID = @EstateID and ActiveMonthYearID = @ActiveMonthYearID    

select DTA.GangName, DA.RDate, C_Emp.EmpCode, C_Emp.EmpName from Checkroll.DailyAttendance DA 
left join Checkroll.AttendanceSetup ASE on (DA.AttendanceSetupID = ASE.AttendanceSetupID)                
left join Checkroll.DailyTeamActivity DTA on (DA.DailyTeamActivityID = DTA.DailyTeamActivityID)                    
left join Checkroll.CREmployee C_Emp on (C_Emp.EmpID = DA.EmpID)                    
where ASE.AttendanceCode in ('11','J1','51') and (DA.RDate between @FromDT and  @ToDT) and upper(DTA.Activity) = 'PANEN'
and DA.DailyReceiptionID not in ( 
select DA.DailyReceiptionID from Checkroll.DailyAttendance DA                      
inner join (select DailyReceiptionID,DivID,YOPID,BlockID, BlkHK from Checkroll.DailyReceiption) DR on (DA.DailyReceiptionID = DR.DailyReceiptionID)                    
left JOIN General.yop AS GYOP on DR.YOPID = GYOP.YOPID                    
left join Checkroll.AttendanceSetup ASE on (DA.AttendanceSetupID = ASE.AttendanceSetupID)                
left join Checkroll.DailyTeamActivity DTA on (DA.DailyTeamActivityID = DTA.DailyTeamActivityID)                    
left outer join General.BlockMaster G_Bl  on DR.BlockID=G_Bl.BlockID and DR.YOPID = G_Bl.YOPID and DR.DivID = G_Bl.DivID
where ASE.AttendanceCode in ('11','J1','51') and (DA.RDate between @FromDT and  @ToDT) and upper(DTA.Activity) = 'PANEN'                    
group by DTA.GangName, DA.RDate, DA.DailyReceiptionID
)

union

select DTA.GangName, DA.RDate, C_Emp.EmpCode, C_Emp.EmpName from Checkroll.DailyAttendance DA 
left join Checkroll.AttendanceSetup ASE on (DA.AttendanceSetupID = ASE.AttendanceSetupID)                
left join Checkroll.DailyTeamActivity DTA on (DA.DailyTeamActivityID = DTA.DailyTeamActivityID)                    
left join Checkroll.CREmployee C_Emp on (C_Emp.EmpID = DA.EmpID)                    
where ASE.AttendanceCode in ('11','J1','51') and (DA.RDate between @FromDT and  @ToDT) and upper(DTA.Activity) = 'DERES'
and DA.DailyReceiptionID not in ( 
select DA.DailyReceiptionID from Checkroll.DailyAttendance DA                      
inner join (select DailyReceiptionID, FieldNo from Checkroll.DailyReceptionForRubber) DR on (DA.DailyReceiptionID = DR.DailyReceiptionID)                    
left join Checkroll.AttendanceSetup ASE on (DA.AttendanceSetupID = ASE.AttendanceSetupID)                
left join Checkroll.DailyTeamActivity DTA on (DA.DailyTeamActivityID = DTA.DailyTeamActivityID)                    
left outer join General.BlockMaster G_Bl  on DR.FieldNo=G_Bl.BlockID 
where ASE.AttendanceCode in ('11','J1','51') and (DA.RDate between @FromDT and  @ToDT) and upper(DTA.Activity) = 'DERES'                    
group by DTA.GangName, DA.RDate, DA.DailyReceiptionID
)

order by DTA.GangName, DA.RDate, C_Emp.EmpCode

