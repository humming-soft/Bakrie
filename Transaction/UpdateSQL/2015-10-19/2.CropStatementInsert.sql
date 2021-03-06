
/****** Object:  StoredProcedure [Checkroll].[CropStatementInsert]    Script Date: 19/10/2015 10:34:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author	  :	Annal tham ko	
-- Create date: 02/12/2010
-- Description:	Crop statement Insert
-- =============================================
ALTER PROCEDURE  [Checkroll].[CropStatementInsert]
	
	 @EstateID nvarchar(50),
	 @EstateCode nvarchar(50),
	 @CropYieldID nvarchar(50),
	 @DivID nvarchar(50),
	 @YOPID nvarchar(50),
	 @BlockID nvarchar(50),
	 @MilWeight numeric(18,0),
	 @Bunches numeric(18,0),
	 @CreatedBy nvarchar(50),
	 @CreatedOn datetime,
	 @ModifiedBy nvarchar(50),
	 @ModifiedOn datetime,
	 @DDate date

	 
AS

Declare @CropStatementID nvarchar(50)
BEGIN TRY
	BEGIN 
						DECLARE @i INT = 2
                        SELECT @CropStatementID= @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
                        FROM   Checkroll.CropStatement   
                        WHILE EXISTS
                        (SELECT id
                        FROM    Checkroll.CropStatement 
                        WHERE   CropStatementID  = @CropStatementID
                        )
                        BEGIN
                                SELECT @CropStatementID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
                                FROM   Accounts.JournalDetail 
                                SET @i = @i + 1
						END
	
	
					Insert into Checkroll .CropStatement 
					(CropStatementID ,EstateID ,CropYieldID ,DivID ,YOPID , BlockID ,MilWeight ,Bunches,CreatedBy ,CreatedOn ,ModifiedBy ,ModifiedOn,DDate )
					values
					(@CropStatementID ,@EstateID ,@CropYieldID ,@DivID ,@YOPID ,@BlockID ,@MilWeight ,@Bunches, @CreatedBy ,@CreatedOn ,@ModifiedBy ,@ModifiedOn,@DDate )
	
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
 

