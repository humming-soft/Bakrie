GO
/****** Object:  StoredProcedure [Production].[DailyQualityProductionsReport]    Script Date: 15/9/2015 9:14:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Production].[DailyQualityProductionsReport]
	@Date DATETIME,
	@EstateID NVARCHAR(50)--,
AS 
	
BEGIN
SET ANSI_WARNINGS OFF
--DECLARE --@Date DATETIME,
--		@MonthFromDate DATETIME,
--		@YearFromDate DATETIME
		

--SET @MonthFromDate = (SELECT FY.FromDT FROM General.FiscalYear FY WHERE FY.FYear = DATEPART(YEAR, @Date) AND FY.Period = DATEPART(MONTH, @Date))
--SET @YearFromDate = (SELECT FY.FromDT FROM General.FiscalYear FY WHERE FY.FYear = DATEPART(YEAR, @Date) AND FY.Period = 1)
		

Select	SOP.QltCPOFFA AS CPOFFA, SOP.QltCPOMoisture AS CPOMoisture, SOP.QltCPODirt AS CPODirt, 
		SOP.QltCPKOFFA AS CPKOFFA, SOP.QltCPKOMoisture AS CPKOMoisture, SOP.QltCPKODirt AS CPKODirt, 
		SOP.QltFKMoisture AS FKMoisture, SOP.QltFKDirt AS FKDirt, SOP.QltFKBrokenKernel AS FKBrokenKernel, SOP.QltFKNutPressCake AS FKNutPressCake, 
		SOP.QltKAMoisture AS KAMoisture, SOP.QltKADirt AS KADirt, SOP.QltKABrokenKernel AS KABrokenKernel, SOP.QltKANutPressCake AS KANutPressCake,
		LA.CPOProductionFFAP as DayCPOFFA, LA.CPOProductionMoistureP as DAYCPOMoisture, LA.CPOProductionDirtP as DAYCPODIrt, 
		LA.KERProductionBrokenKernel as DAYKABrokenKernel,LA.KERProductionMoistureP as DayKAMoisture, LA.KERProductionDirtP as DAYKADirt
from Production.SOP SOP
inner join Production.LaboratoryAnalysis LA on 
SOP.EstateID = LA.EstateID
where LA.LabAnalysisDate = @Date AND LA.EstateID = @EstateID


--CPKO Production

SELECT	PTM.TankNo, ISNULL(CPS.CurrentReading,0) AS CurrentReading, CPS.FFAP, CPS.MoistureP,CPS.DirtP
FROM Production.CPOProductionStockCPO CPS INNER JOIN Production.TankMaster PTM ON CPS.TankID = PTM.TankID 
INNER JOIN Production.CPOProduction CPO ON CPS.ProductionID = CPO.ProductionID	
INNER JOIN General.CropYield GCY ON CPO.CropYieldID = GCY.CropYieldID AND GCY.CropYieldCode = 'PKO'  
WHERE CPO.EstateID = @EstateID AND CPO.CPOProductionDate = @Date

SELECT	('Loading At ' + CLL.Descp) AS Location,	ISNULL(SUM(CPL.Qty), 0) AS CurrentReading
FROM Production.LoadingLocation CLL INNER JOIN Production.CPOProductionLoadingCPO CPL ON CPL.LoadingLocationID = CLL.LoadingLocationID 
INNER JOIN Production.CPOProduction CPO ON CPL.LoadingDate  = CPO.CPOProductionDate 
INNER JOIN General.CropYield GCY ON CPO.CropYieldID = GCY.CropYieldID AND GCY.CropYieldCode = 'PKO'  
WHERE CPO.EstateID = @EstateID AND CPO.CPOProductionDate = @Date
GROUP BY CLL.Descp

--CPO Production

SELECT	PTM.TankNo, ISNULL(CPS.CurrentReading,0) AS CurrentReading, CPS.FFAP, CPS.MoistureP,CPS.DirtP
FROM Production.CPOProductionStockCPO CPS INNER JOIN Production.TankMaster PTM ON CPS.TankID = PTM.TankID 
INNER JOIN Production.CPOProduction CPO ON CPS.ProductionID = CPO.ProductionID	
INNER JOIN General.CropYield GCY ON CPO.CropYieldID = GCY.CropYieldID AND GCY.CropYieldCode = 'CPO'  
WHERE CPO.EstateID = @EstateID AND CPO.CPOProductionDate = @Date


SELECT	('Loading At ' + CLL.Descp) AS Location,	ISNULL(SUM(CPL.Qty), 0) AS CurrentReading
FROM Production.LoadingLocation CLL INNER JOIN Production.CPOProductionLoadingCPO CPL ON CPL.LoadingLocationID = CLL.LoadingLocationID 
INNER JOIN Production.CPOProduction CPO ON CPL.LoadingDate  = CPO.CPOProductionDate 
INNER JOIN General.CropYield GCY ON CPO.CropYieldID = GCY.CropYieldID AND GCY.CropYieldCode = 'CPO'  
WHERE CPO.EstateID = @EstateID AND CPO.CPOProductionDate = @Date
GROUP BY CLL.Descp
		
END	


















