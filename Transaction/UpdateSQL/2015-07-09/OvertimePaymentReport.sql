
/****** Object:  StoredProcedure [Checkroll].[CROvertimePaymentReport]    Script Date: 9/7/2015 9:51:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Checkroll].[CROvertimePaymentReport]
	@EstateID nvarchar(50),
	@ActiveMonthYearID nvarchar(50)


AS
SELECT DISTINCT
	C_OTD.EstateID
	,G_ESTATE.EstateName
	--,C_DA.ActiveMonthYearID
	,C_GM.GangName
	,C_EMP.EmpCode
	,C_EMP.EmpName
	,OT1 = SUM(ISNULL(C_OTD.OT1,0))
	,OT2 = SUM(ISNULL(C_OTD.OT2,0))
	,OT3 = SUM(ISNULL(C_OTD.OT3,0))
	,OT4 = SUM(ISNULL(C_OTD.OT4,0))
	---Modified by kumar
	--,TotalOTHours = (C_DA.TotalOT)
	,TotalOTHours = SUM(ISNULL(C_OTD.OT1,0)) +SUM(ISNULL(C_OTD.OT2,0))+SUM(ISNULL(C_OTD.OT3,0))+SUM(ISNULL(C_OTD.OT4,0))
	,TotalOTPayment = SUM(ISNULL(C_OTD.OTValue1,0)) +SUM(ISNULL(C_OTD.OTValue2 ,0))+SUM(ISNULL(C_OTD.OTValue3 ,0))+SUM(ISNULL(C_OTD.OTValue4 ,0))
	,TotalOTP = SUM(ISNULL(C_OTD.OTValue1,0)) +SUM(ISNULL(C_OTD.OTValue2 ,0))+SUM(ISNULL(C_OTD.OTValue3 ,0))+SUM(ISNULL(C_OTD.OTValue4 ,0))

FROM
	Checkroll.OTDetail AS C_OTD
	INNER JOIN Checkroll.CREmployee AS C_EMP ON C_OTD.EmpID = C_EMP.EmpID
	LEft JOIN Checkroll.GangMaster AS C_GM ON C_OTD.GangMasterID = C_GM.GangMasterID
	INNER JOIN General.Estate AS G_ESTATE ON C_OTD.EstateID = G_ESTATE.EstateID
WHERE C_OTD.EstateID= @EstateID 
	AND C_OTD.ActiveMonthYearID = @ActiveMonthYearID 
GROUP BY
	C_OTD.EstateID
	,G_ESTATE.EstateName
	,C_GM.GangName
	,C_EMP.EmpCode
	,C_EMP.EmpName









