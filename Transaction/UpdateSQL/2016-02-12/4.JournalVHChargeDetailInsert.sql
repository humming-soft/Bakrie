
/****** Object:  StoredProcedure [Vehicle].[JournalVhChargeDetailInsert]    Script Date: 23/2/2016 9:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










--============================================================================================================================
-- Created By : Kumaravel
-- Created date:  11-Nov-2009
-- Modified By:Kumaravel
-- Last Modified Date: 
-- Module     : Accounts
-- Screen(s)  :Journal Approval
-- Description: To Save Values in Vehicle. VHChargeDetail from approval screens
--============================================================================================================================

ALTER PROCEDURE [Vehicle].[JournalVhChargeDetailInsert]
--@JournalDetID nvarchar(50) output,
	@EstateCodeL nvarchar(50),
	@EstateCode nvarchar(50),
	@VHWSCode nvarchar(50),
	@VHDetailCostCode nvarchar(50),
	@Type char(1),
	@AYear numeric(18,0),
	@AMonth int,
	@ModName nvarchar(50),	
	@LedgerType nvarchar(50),
	@LedgerNo nvarchar(50),
	@Value numeric(18,0),
	@JDescp nvarchar(300),
	--@ConcurrencyId rowversion output,
	@CreatedBy nvarchar(50),
	@CreatedOn datetime,
	@ModifiedBy nvarchar(50),
	@ModifiedOn datetime,
	@UOMID nvarchar(50),
	@QtyUsed numeric(18,3),
	@RefNo nvarchar(50) 	

AS	
DECLARE @VHChargeDetailID nvarchar(50)
	
BEGIN TRY
    
    Declare @count int
    Declare  @ModID int
    BEGIN 
    SET @count = 0;
    

    
		SELECT @count =CAST(( CASE WHEN (ISNULL(MAX(Id), -1) = -1 ) THEN 1 WHEN MAX(Id) >= 0 THEN MAX(Id) + 2 END ) AS VARCHAR) 
					   FROM Vehicle.VHChargeDetail 
		SET @VHChargeDetailID = @EstateCode + 'R' + CONVERT(NVARCHAR,@count);
		SELECT @ModID=ModID    FROM General.Module WHERE ModName=@ModName


		--select * from Vehicle.JournalDetail
		INSERT INTO Vehicle.VHChargeDetail
			(VHChargeDetailID,
			EstateCodeL,
			VHWSCode,
			EstateCode,
			VHDetailCostCode,
			Type,
			ModID ,
			LedgerType ,
			LedgerNo ,
			Ayear,
			Amonth ,
			Value,
			JDescp ,
			CreatedBy,
			CreatedOn,
			ModifiedBy,
			ModifiedOn,
			Uomid,
			Qtyused,
			RefNo)
		VALUES
			(@VHChargeDetailID,
			@EstateCodeL,
			@VHWSCode,
			@EstateCode,
			@VHDetailCostCode,
			@Type,
			@ModID,
			@LedgerType,
			@LedgerNo,
			@AYear,
			@AMonth ,
			@Value,
			@JDescp ,
			@CreatedBy,
			@Createdon,
			@ModifiedBy,
			@ModifiedOn,
			@UOMID,
			@QtyUsed,
			@RefNo
			);

		--SELECT @ConcurrencyId = ConcurrencyId FROM Vehicle.JournalDetail WHERE JournalDetID=@JournalDetID;
		
END

--	RETURN SCOPE_IDENTITY();	
	
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










