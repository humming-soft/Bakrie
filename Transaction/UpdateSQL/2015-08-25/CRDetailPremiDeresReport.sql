GO
/****** Object:  StoredProcedure [Checkroll].[CRDetailPremiPanenReport]    Script Date: 27/8/2015 11:09:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [Checkroll].[CRDetailPremiDeresReport]

@EstateID nvarchar(50),
@ActiveMonthYearID nvarchar(50)

AS 

Select b.ActiveMonthYearID,c.GangName, e.EmpCode, e.EmpName,a.DateRubber,i.AttendanceCode,
d.BlockName,a.Latex,a.drc,a.TreeLace,a.DRCTreeLace,a.CupLamp,a.DRCCupLump, a.PremiDasarLatex, a.PremiDasarLump,a.PremiBonusLatex,a.PremiBonusLump,a.PremiProgresifLatex,a.PremiProgresifLump,
a.PremiMinggu,a.PremiTreelace
from Checkroll.DailyReceptionForRubber a
inner join Checkroll.DailyAttendance b on a.DailyReceiptionID = b.DailyReceiptionID
inner join Checkroll.DailyTeamActivity c on b.DailyTeamActivityID = c.DailyTeamActivityID
inner join general.BlockMaster d on a.FieldNo = d.BlockID
inner join Checkroll.AttendanceSetup i on b.AttendanceSetupID = i.AttendanceSetupID
inner join Checkroll.CREmployee e on a.NIK = e.EmpID
WHERE b.EstateID = @EstateID AND b.ActiveMonthYearID = @ActiveMonthYearID
