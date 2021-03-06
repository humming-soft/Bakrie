
/****** Object:  StoredProcedure [Checkroll].[PieceRateInsert]    Script Date: 25/11/2015 12:35:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--================================================
-- Created By : Naxim
-- Created date: 2-Oct-2012 
-- Modified By:
-- Last Modified Date: 
-- Module     : PieceRate
-- Screen(s)  : PieceRate Insert Master
-- Description: Add records to PieceRate
 --================================================  
ALTER PROCEDURE [Checkroll].[PieceRateInsert]
	@EstateID nvarchar(50),
	@EstateCode nvarchar(50),
	@BudgetYear int,
	@ReferenceNo varchar(50),
	@ActivityBy char(1),
	@Description varchar(300),
	@AllowanceDeductionCode varchar(10),
	@COAID nvarchar(50)
AS	

	
BEGIN TRY
    DECLARE @EstateRefNo nvarchar(50)
    BEGIN 
		SET @EstateRefNo = @EstateID + @ReferenceNo
		IF @Description is null 
		Begin
			Set @Description =@ReferenceNo
		End
		INSERT INTO Checkroll.PieceRate
			(ReferenceNo,
			EstateID,
			ActivityBy,
			[Description],AllowanceDeductionCode,COAID)
		VALUES
			(@ReferenceNo,
			@EstateID,
			@ActivityBy,
			@Description,@AllowanceDeductionCode,@COAID);
	END

	
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
