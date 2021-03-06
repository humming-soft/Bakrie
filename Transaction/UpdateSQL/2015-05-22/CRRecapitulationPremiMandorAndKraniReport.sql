
/****** Object:  StoredProcedure [Checkroll].[CRRecapitulationPremiMandorAndKraniReport]    Script Date: 22/5/2015 9:45:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Checkroll].[CRRecapitulationPremiMandorAndKraniReport]
	@EstateID nvarchar(50),
	@ActiveMonthYearID nvarchar(50)
AS
BEGIN
	SELECT 
	ActiveMonthYearID, EstateID, EstateName, AMonth, AYear, GangName, RDate, MandorName,
	SUM(MandorPremi) as MandorPremi, KraniName, SUM(KraniPremi) as KraniPremi, SUM(SUMPREMI) as SUMPREMI, FaktorPembagi, Sum(MandorBesarPremi)
	FROM 
	(
	SELECT 
	a.ActiveMonthYearID, a.EstateID, EstateName, c.AMonth, c.AYear, d.GangName, RDate, e.EmpName as MandorName, 
	(((TValue1+TValue2+TValue3+TotalBoronganValue+TLooseFruitsValue)/z.FaktorPembagi)*1.5) as MandorPremi,
	f.EmpName as KraniName, (((TValue1+TValue2+TValue3+TotalBoronganValue+TLooseFruitsValue)/z.FaktorPembagi)*1.25) as KraniPremi,
	(TValue1+TValue2+TValue3+TotalBoronganValue+TLooseFruitsValue) as SUMPREMI, z.FaktorPembagi,
	(((TValue1+TValue2+TValue3+TotalBoronganValue+TLooseFruitsValue)/z.FaktorPembagi)*2) as MandorBesarPremi 
	FROM [Checkroll].[ReceptionTargetDetail] a
	INNER JOIN [General].[Estate] b on a.EstateID = b.EstateID
	INNER JOIN [General].[ActiveMonthYear] c on a.ActiveMonthYearID = c.ActiveMonthYearID
	INNER JOIN [Checkroll].[GangMaster] d on a.GangMasterID = d.GangMasterID
	INNER JOIN [Checkroll].[CREmployee] e on a.MandoreID = e.EmpID
	INNER JOIN [Checkroll].[CREmployee] f on a.KraniID = f.EmpID
	inner Join (Select Count(*) as FaktorPembagi, GangMasterID,DDAte from Checkroll.dailyGangemployeeSetup Group By Gangmasterid,DDate) Z on a.GangMasterID = z.gangmasterid and a.RDate = z.DDAte
	WHERE a.ActiveMonthYearID = @ActiveMonthYearID AND a.EstateID = @EstateID
	) as tbl
	GROUP BY ActiveMonthYearID, EstateID, EstateName, AMonth, AYear, GangName, RDate, MandorName, KraniName, FaktorPembagi
	ORDER BY GangName, RDate
END
select * from checkroll.PremiSetupRubber