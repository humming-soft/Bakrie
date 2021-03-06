
/****** Object:  StoredProcedure [Checkroll].[DailyReceiptionWithTeamSelect]    Script Date: 26/10/2015 9:02:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Checkroll].[DailyReceiptionWithTeamSelect]
@DailyReceiptionID nvarchar(50)

AS
BEGIN
declare @blNormal bit
set	@blNormal=1
	SELECT		
				CR_EMP.EmpCode, CR_EMP.EmpName,
				CR_DRWT.FKPSerialNo,
				CR_DRWT.DailyReceiptionWithTeamID,
				CR_DR.DailyReceiptionDetID, CR_DR.DailyReceiptionID, 
				CR_DR.EstateID, 
				OTHours = ISNULL(CR_DR.OTHours, 0),
				--CR_DR.StationID, 
				CR_DR.DivID, 
				CR_DR.YOPID, 
				CR_DR.BlockID,
				CR_DR.IsDrivePremi, 
				CR_DR.Tonnage, 
				--NActualBunches = ISNULL(CR_DR.NActualBunches, 0), 
				--NPayedBunches = ISNULL(CR_DR.NPayedBunches, 0), 
				--NLooseFruits = ISNULL(CR_DR.NLooseFruits, 0),
				--BActualBunches = ISNULL( CR_DR.BActualBunches, 0), 
				--BPayedBunches = ISNULL( CR_DR.BPayedBunches, 0), 
				--BLooseFruits = ISNULL(CR_DR.BLooseFruits, 0),
				PremiValue = ISNULL(CR_DR.PremiValue, 0),
				TphNormal  = ISNULL(CR_DRWT.TphNormal, 0),
				UnripeNormal  = ISNULL(CR_DRWT.UnripeNormal, 0),
				UnderRipeNormal = ISNULL(CR_DRWT.UnderRipeNormal, 0),
				OverRipeNormal = ISNULL(CR_DRWT.OverRipeNormal, 0),
				RipeNormal = ISNULL(CR_DRWT.RipeNormal, 0),
				LooseFruitNormal = ISNULL(CR_DRWT.LooseFruitNormal, 0),
				DiscardedNormal = ISNULL(CR_DRWT.DiscardedNormal, 0),
				HarvestedNormal = ISNULL(CR_DRWT.HarvestedNormal, 0),
				DeductedNormal = ISNULL(CR_DRWT.DeductedNormal, 0),
				PaidNormal = ISNULL(CR_DRWT.PaidNormal, 0),
				TphBorongan = ISNULL(CR_DRWT.TphBorongan, 0) ,
				UnripeBorongan = ISNULL(CR_DRWT.UnripeBorongan, 0),
				UnderRipeBorongan = ISNULL(CR_DRWT.UnderRipeBorongan, 0),
				OverRipeBorongan = ISNULL(CR_DRWT.OverRipeBorongan, 0) ,
				RipeBorongan = ISNULL(CR_DRWT.RipeBorongan, 0),
				LooseFruitBorongan = ISNULL(CR_DRWT.LooseFruitBorongan, 0),
				DiscardedBorongan = ISNULL(CR_DRWT.DiscardedBorongan, 0),
				HarvestedBorongan = ISNULL(CR_DRWT.HarvestedBorongan, 0) ,
				DeductedBorongan = ISNULL(CR_DRWT.DeductedBorongan, 0),
				PaidBorongan = ISNULL(CR_DRWT.PaidBorongan, 0),
				Ha = ISNULL(CR_DRWT.Ha, 0),
				CR_DR.ConcurrencyId,
				CR_DR.CreatedBy, CR_DR.CreatedOn, CR_DR.ModifiedBy, CR_DR.ModifiedOn,
				
				G_EST.EstateCode, 
				G_M.BlockName, 
				G_DIV.DivName,
				 G_YOP.YOP,
				--P_STATION.StationDescp,
				CR_DA.DailyTeamActivityID, 
				CR_DTA.GangName,
				@blNormal as blNormal,
				CR_DR .PremiHK,
				CR_DR .BlkHK,
				DeductionLainNormal = ISNULL(CR_DRWT.DeductionLainNormal,0),
				DeductionLainBorongan = ISNULL(CR_DRWT.DeductionLainBorongan,0)
				
	FROM
		Checkroll.DailyReceiption AS CR_DR
		inner join Checkroll.DailyAttendance AS CR_DA on CR_DR.DailyReceiptionID = CR_DA.DailyReceiptionID
		inner join Checkroll.DailyTeamActivity AS CR_DTA on CR_DA.DailyTeamActivityID = CR_DTA.DailyTeamActivityID
		inner join General.Estate AS G_EST on CR_DR.EstateID = G_EST.EstateID
		left join General.BlockMaster AS G_M on CR_DR.BlockID = G_M.BlockID
		left join General.Division As G_DIV on CR_DR.DivID = G_DIV.DivID
		left join General.YOP As G_YOP on CR_DR.YOPID = G_YOP.YOPID
		--left join Production.Station AS P_STATION on CR_DR.StationID = P_STATION.StationID 
		INNER JOIN Checkroll.CREmployee AS CR_EMP on CR_DA.EmpID = CR_EMP.EmpID
		INNER JOIN Checkroll.DailyReceptionWithTeam as CR_DRWT on CR_DR.DailyReceiptionDetID=CR_DRWT.DailyReceiptionDetID
	WHERE
		CR_DR.DailyReceiptionID = @DailyReceiptionID
		--AND CR_DRWT.DailyReceiptionWithTeamID=@DailyReceiptionWithTeamID
END


