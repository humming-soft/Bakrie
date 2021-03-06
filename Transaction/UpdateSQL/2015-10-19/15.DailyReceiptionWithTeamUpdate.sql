/****** Object:  StoredProcedure [Checkroll].[DailyReceiptionWithTeamUpdate]    Script Date: 26/10/2015 9:59:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Checkroll].[DailyReceiptionWithTeamUpdate]
	-- Add the parameters for the stored procedure here
	@EstateID nvarchar(50),
	@OTHours numeric(18,2),
	@FKPSerialNo VARCHAR(15),
	--@StationID nvarchar(50), 
	@DivID nvarchar(50),
	@YOPID nvarchar(50),
	@BlockID nvarchar(50),
	@IsDrivePremi char(1),
	@Tonnage numeric(18,3),
	--@NActualBunches numeric(18,0),
	--@NPayedBunches numeric(18,0),
	--@NLooseFruits numeric(18,3),
	--@BActualBunches numeric(18,0),
	--@BPayedBunches numeric(18,0),
	--@BLooseFruits numeric(18,3),	
	@PremiValue numeric(18,2),	
	@TphNormal varchar(50),
	@UnripeNormal numeric(8, 0) ,
	@UnderRipeNormal numeric(8, 0),
	@OverRipeNormal numeric(8, 0),
	@RipeNormal numeric(8, 0),
	@LooseFruitNormal numeric(8, 2),
	@DiscardedNormal numeric(8, 0),
	@HarvestedNormal numeric(8, 0),
	@DeductedNormal numeric(8, 0),
	@PaidNormal numeric(8, 0),
	@TphBorongan nvarchar(50) ,
	@UnripeBorongan numeric(8, 0),
	@UnderRipeBorongan numeric(8, 0),
	@OverRipeBorongan numeric(8, 0),
	@RipeBorongan numeric(8, 0),
	@LooseFruitBorongan numeric(8, 0),
	@DiscardedBorongan numeric(8, 2),
	@HarvestedBorongan numeric(8, 0),
	@DeductedBorongan numeric(8, 0),
	@PaidBorongan numeric(8, 0),
	@Ha numeric (18, 3),
	@ConcurrencyId rowversion output,
	@ModifiedBy nvarchar(50),
	@PremiHK numeric(18,2),
	@BlkHK numeric(18,2),
	@DeductionLainNormal numeric(8,3),
	@DeductionLainBorongan numeric(8,3),
	@DailyReceiptionDetID nvarchar(50) output
AS
	
BEGIN TRY
  
	UPDATE Checkroll.DailyReceiption SET
		EstateID = @EstateID,
		OTHours = @OTHours,
		--StationID = @StationID,
		DivID = @DivID,
		YOPID = @YOPID,
		BlockID = @BlockID,
		IsDrivePremi = @IsDrivePremi,
		Tonnage = @Tonnage,
		--NActualBunches =  @NActualBunches,
		--NPayedBunches = @NPayedBunches,
		--NLooseFruits = @NLooseFruits,
		--BActualBunches = @BActualBunches,
		--BPayedBunches = @BPayedBunches,
		--BLooseFruits = @BLooseFruits,
		PremiValue = @PremiValue,
		ModifiedBy = @ModifiedBy,
		ModifiedOn = GETDATE(),
		PremiHK = @PremiHK,
		BlkHK = @BlkHK
	WHERE
		
		DailyReceiptionDetID = @DailyReceiptionDetID --AND
		--ConcurrencyId = @ConcurrencyId
		
	UPDATE 	Checkroll.DailyReceptionWithTeam SET
		FKPSerialNo = @FKPSerialNo,
		TphNormal =@TphNormal,
		UnripeNormal =@UnripeNormal ,
		UnderRipeNormal =@UnderRipeNormal,
		OverRipeNormal=@OverRipeNormal,
		RipeNormal =@RipeNormal,
		LooseFruitNormal =@LooseFruitNormal,
		DiscardedNormal = @DiscardedNormal,
		HarvestedNormal =@HarvestedNormal,
		DeductedNormal =@DeductedNormal,
		PaidNormal =@PaidNormal,
		TphBorongan  =@TphBorongan,
		UnripeBorongan =@UnripeBorongan,
		UnderRipeBorongan = @UnderRipeBorongan,
		OverRipeBorongan = @OverRipeBorongan,
		RipeBorongan =@RipeBorongan,
		LooseFruitBorongan = @LooseFruitBorongan,
		DiscardedBorongan = @DiscardedBorongan,
		HarvestedBorongan =@HarvestedBorongan,
		DeductedBorongan = @DeductedBorongan,
		PaidBorongan = @PaidBorongan,
		Ha = @Ha,
		ModifiedBy = @ModifiedBy,
		ModifiedOn = GETDATE(),
		DeductionLainNormal = @DeductionLainNormal,
		DeductionLainBorongan=@DeductionLainBorongan
		
	WHERE
		DailyReceiptionDetID = @DailyReceiptionDetID
		--And ConcurrencyId=@ConcurrencyId

	--SELECT @ConcurrencyId = ConcurrencyId FROM Checkroll.DailyReceiption 
	--WHERE DailyReceiptionDetID=@DailyReceiptionID;

	--RETURN SCOPE_IDENTITY();	
	
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;


