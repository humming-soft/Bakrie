USE [BSPMS_POM]
GO
/****** Object:  StoredProcedure [Production].[KernalProductionStockUpdate]    Script Date: 12/6/2015 11:45:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Production].[KernalProductionStockUpdate]
	-- Add the parameters for the stored procedure here
	@EstateID nvarchar(50),
	@ActiveMonthYearID nvarchar(50), 
	@EstateCode nvarchar(50),
	@StockKernalID nvarchar(50),
	@StockTankID nvarchar(50),
	--@LoadTankID nvarchar(50),
	--@TransTankID nvarchar(50),
	@ProdStockID nvarchar(50),
	--For StockCPO
	@Capacity numeric(18,2),
	@BalanceBF numeric(18,3),
	@CurrentReading numeric(18,3),
	@Writeoff numeric(18,3),
	@Reason nvarchar(150),
	@Measurement numeric(18,2),
	@Temp numeric(18,2),
	@FFAP numeric(18,2),
	@MoistureP numeric(18,2),
	@DirtP numeric(18,3),
	
	--@LoadingLocationID nvarchar(50),
	--@CropYieldID nvarchar(50),
	--@CPOProductionDate DateTime,
	--@QtyToday numeric(18,3),
	--@QtyMonthToDate numeric(18,3),
	--@QtyYearToDate numeric(18,3),
	--@TransQty numeric(18,2),
	--@TransMonthToDate numeric(18,2),
	--@LoadQty numeric(18,2),
	--@LoadMonthToDate numeric(18,2),
	@CreatedBy nvarchar(50),
	@CreatedOn datetime,
	@ModifiedBy nvarchar(50),
	@ModifiedOn datetime,
	--@TransLocationID nvarchar(50),
	@ProductionID nvarchar(50) 
		
AS
--For CPOSTock

BEGIN 
	UPDATE Production.CPOProductionStockCPO  SET 
	 ProductionID=@ProductionID,
	 EstateID=@EstateID, 
	 ActiveMonthYearID=@ActiveMonthYearID,
	 TankID=@StockTankID,
	 KernelStorageID=@StockKernalID,
	 Capacity=@Capacity,
	 PrevDayReading =@BalanceBF,
	 CurrentReading=@CurrentReading,
	 Writeoff = @Writeoff,
	 Reason = @Reason,
	 Measurement=@Measurement,
	 Temp=@Temp,
	 FFAP=@FFAP,
	 MoistureP=@MoistureP,
	 DirtP=@DirtP,
	 ModifiedBy=@ModifiedBy,
	 ModifiedOn=GETDATE()  
	WHERE ProdStockID=@ProdStockID ;
	
		UPDATE Production.KernelStorage SET BFQty = @CurrentReading WHERE KernelStorageID = @StockKernalID;
		--SELECT @ConcurrencyId = ConcurrencyId FROM Store.STAdjustment WHERE STAdjustmentID=@STAdjustmentID;
END
