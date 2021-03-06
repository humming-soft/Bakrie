
/****** Object:  StoredProcedure [Production].[DispatchCPOandPKOForMonth]    Script Date: 15/9/2015 10:08:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- ALTERd By : Raja
-- Modified By: Kumar
-- ALTERd date: 3rd August 2010
-- Last Modified Date: 26 August  2010
-- Module     : Production
-- Screen(s)  : Dispatch - CPO and PKO for the Month of May 
-- Description: 
-- =============================================

ALTER PROCEDURE [Production].[DispatchCPOandPKOForMonth] 
	
 @EstateID nVarchar(50),
-- @ActiveMonthYearID nvarchar(50),
 @Period Int,
 @FYear Int,
 @ToDate datetime,
 @ToDateYear datetime

AS
BEGIN

		DECLARE @CPOProductID nVarchar(50);
		DECLARE @PKOProductID nVarchar(50);
		--DECLARE @FromDateMonth datetime;
		--DECLARE @FromDateYear datetime;
		DECLARE @CPOCropYieldID nVarchar(50);
		DECLARE @PKOCropYieldID nVarchar(50);
			
		SELECT @CPOProductID = ProductID FROM  Weighbridge.WBProductMaster WHERE ProductDescp  = 'Crude Palm Oil'and EstateID =@EstateID 

		SELECT @PKOProductID = ProductID FROM  Weighbridge.WBProductMaster WHERE ProductDescp = 'Palm Kernel' and EstateID =@EstateID 
		
		SELECT @CPOCropYieldID = CropYieldID   FROM General.CropYield WHERE CropYieldCode = 'CPO'
		
		SELECT @PKOCropYieldID = CropYieldID   FROM General.CropYield WHERE CropYieldCode = 'Kernel'

		Declare @ActiveMonthYearID nvarchar(50) ,@a nvarchar (10)
		Select @ActiveMonthYearID= ActiveMonthYearID 
		from General .ActiveMonthYear 
		where AMonth =@Period  
		AND AYear =@FYear 
		AND EstateID =@EstateID 
		AND ModID = 4


		Declare @FromDt as Date 
		Declare @LastDt as Date 
				
     	Select @FromDt = FromDT  from General .FiscalYear 
     	where FYear =  @FYear  
     	AND Period =1
       	
		Select @LastDt = ToDT   from General .FiscalYear 
     	where FYear = @FYear
     	AND Period =@Period
     		
		
		
		SELECT ISNull(SUM(MillWeight),0)AS CPOMillWeightMonth--, WBProductMaster.ProductCode 
		FROM Production.CPODispatch 
		--INNER JOIN Weighbridge.WBProductMaster ON WBProductMaster.ProductID = CPODispatch.ProductID 
		WHERE CPODispatch.EstateID = @EstateID 
		AND ActiveMonthYearID = @ActiveMonthYearID 
		AND CPODispatch.ProductID = @CPOProductID 
		--AND  DispatchDate <= @ToDate
		
		SELECT ISNull(SUM(MillWeight),0) AS CPOMillWeightYear --CPO Report for Year
		FROM Production.CPODispatch 
		WHERE EstateID = @EstateID
		AND ProductID = @CPOProductID AND  
		DispatchDate   Between @FromDt and @LastDt	
	--	AND  DispatchDate <= @ToDate
	--	AND DispatchDate   Between @ProdFromDt AND @ToDate
		
		SELECT ISNull(SUM(MillWeight),0) AS PKOMillWeightMonth 
		FROM Production.CPODispatch 
		WHERE EstateID = @EstateID 
		AND ActiveMonthYearID = @ActiveMonthYearID 
		AND ProductID = @PKOProductID  
	--	DispatchDate <= @ToDate
		
		SELECT ISNull(SUM(MillWeight),0) AS PKOMillWeightYear 
		FROM Production.CPODispatch 
		WHERE EstateID = @EstateID 
		AND ProductID = @PKOProductID AND  
		DispatchDate   Between @FromDt and @LastDt	
	--	DispatchDate <= @ToDate
		
	--	AND DispatchDate   Between @ProdFromDt AND @ToDate

		
		SELECT DispatchDate, 
		WBProductMaster.ProductCode ,
		ShipPontoon,
		DOA,
		DCL,
		DepartureDate,
		MillWeight, 
		BAPNo ,
		Case when LoadingLocation .Descp <>''then
		LoadingLocation.LoadingLocationCode + '-' +LoadingLocation.Descp 
		when LoadingLocation .Descp ='' then
		LoadingLocation.LoadingLocationCode
		end as LoadingLocationCode  
		FROM Production.CPODispatch 
		INNER JOIN Weighbridge.WBProductMaster ON WBProductMaster.ProductID = CPODispatch.ProductID 
		LEFT JOIN Production.LoadingLocation ON LoadingLocation.LoadingLocationID = CPODispatch.LoadingLocationID 
		WHERE CPODispatch.EstateID = @EstateID 
		AND CPODispatch.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPODispatch.ProductID = @CPOProductID
 
		SELECT DispatchDate, 
		WBProductMaster.ProductCode , 
		ShipPontoon, DOA, DCL, DepartureDate, MillWeight, 
		 BAPNo  ,
		 Case when LoadingLocation .Descp <>''then
		 LoadingLocation.LoadingLocationCode + '-' +LoadingLocation.Descp 
		 when LoadingLocation .Descp ='' then
		 LoadingLocation.LoadingLocationCode
		 end as LoadingLocationCode 
		FROM Production.CPODispatch 
		INNER JOIN Weighbridge.WBProductMaster ON WBProductMaster.ProductID = CPODispatch.ProductID 
		LEFT JOIN Production.LoadingLocation ON LoadingLocation.LoadingLocationID = CPODispatch.LoadingLocationID 
		WHERE CPODispatch.EstateID = @EstateID 
		AND CPODispatch.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPODispatch.ProductID = @PKOProductID
 
		 
		
		
		
			set @a=(Select COUNT (*) a  from  Production.CPOProduction where ActiveMonthYearID =@ActiveMonthYearID)
if @a =0
		
		SELECT top 1 0 'QtyMonthToDate', --ISNull(QtyMonthToDate,0) as QtyMonthToDate,
		ISNull(QtyYearToDate,0) as QtyYearToDate,
		CropYield.CropYieldCode 
		FROM Production.CPOProduction
		INNER JOIN General.CropYield ON CropYield.CropYieldID = CPOProduction.CropYieldID 
		WHERE CPOProduction.EstateID = @EstateID AND
		--CPOProduction.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPOProduction.CropYieldID  = @CPOCropYieldID 
		order by CPOProduction.CPOProductionDate desc
Else

		SELECT top 1  ISNull(QtyMonthToDate,0) as QtyMonthToDate,
		ISNull(QtyYearToDate,0) as QtyYearToDate,
		CropYield.CropYieldCode 
		FROM Production.CPOProduction
		INNER JOIN General.CropYield ON CropYield.CropYieldID = CPOProduction.CropYieldID 
		WHERE CPOProduction.EstateID = @EstateID 
		AND CPOProduction.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPOProduction.CropYieldID  = @CPOCropYieldID 
		order by CPOProduction.CPOProductionDate desc
		
		
	set @a=(Select COUNT (*) a  from  Production.CPOProduction where ActiveMonthYearID =@ActiveMonthYearID)
if @a =0

		SELECT top 1 0 'QtyMonthToDate',-- ISNull(QtyMonthToDate,0) as QtyMonthToDate, 
		ISNull(QtyYearToDate, 0) as QtyYearToDate,
		CropYield.CropYieldCode 
		FROM Production.CPOProduction
		INNER JOIN General.CropYield ON CropYield.CropYieldID = CPOProduction.CropYieldID 
		WHERE CPOProduction.EstateID = @EstateID AND --CPOProduction.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPOProduction.CropYieldID  = @PKOCropYieldID 
		order by CPOProduction.CPOProductionDate desc
Else
		SELECT top 1 ISNull(QtyMonthToDate,0) as QtyMonthToDate, 
		ISNull(QtyYearToDate, 0) as QtyYearToDate,
		CropYield.CropYieldCode 
		FROM Production.CPOProduction
		INNER JOIN General.CropYield ON CropYield.CropYieldID = CPOProduction.CropYieldID 
		WHERE CPOProduction.EstateID = @EstateID AND CPOProduction.ActiveMonthYearID = @ActiveMonthYearID AND 
		CPOProduction.CropYieldID  = @PKOCropYieldID 
		order by CPOProduction.CPOProductionDate desc
		
		select 
		FromDT ,ToDT  
		from General .FiscalYear 
		where FYear =@FYear and Period = @Period 

			
END






















