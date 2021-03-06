
/****** Object:  StoredProcedure [Checkroll].[CRDailyActivityDistributionIsExist]    Script Date: 20/10/2015 1:56:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================
--
-- Author : Dadang Adi Hendradi
-- Created: Selasa, 20 Oct 2009, 10:54
--
--====================================
ALTER procedure [Checkroll].[CRDailyActivityDistributionIsExist]
@EstateID nvarchar(50),
@GangMasterID nvarchar(50),
@DistbDate date
AS
BEGIN

	SELECT 
		CR_DAD.DailyReceiptionID
	FROM 
		Checkroll.DailyActivityDistribution AS CR_DAD
		--INNER JOIN Checkroll.DailyTeamActivity AS CR_DTA on CR_DAD.GangMasterID = CR_DTA.GangMasterID
		--INNER JOIN Checkroll.DailyAttendance AS CR_DA on CR_DTA.DailyTeamActivityID = CR_DTA.DailyTeamActivityID
	WHERE
		CR_DAD.GangMasterID = @GangMasterID AND
		CONVERT(DATE, CR_DAD.DistbDate) = @DistbDate

END
