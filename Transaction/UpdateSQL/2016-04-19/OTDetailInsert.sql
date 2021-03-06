
/****** Object:  StoredProcedure [Checkroll].[OTDetailInsert]    Script Date: 19/4/2016 7:29:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Agung Batricorsila>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Checkroll].[OTDetailInsert]
	-- Add the parameters for the stored procedure here
		 @OTSummaryID nvarchar(50) output,
		 @EstateID nvarchar(50) output,
		 @EstateCode nvarchar(50) output, 
		 @ActiveMonthYearID nvarchar(50) output, 
		 @GangMasterID nvarchar(50) output, 
		 @Activity nvarchar(50) output, 
		 @MandoreID nvarchar(50) output, 
		 @KraniID nvarchar(50) output,
		 @ADate datetime, 
		 @EmpID nvarchar(50) output,
		 @OT1 numeric (18,2), 
		 @OTValue1 numeric (18,2), 
         @OT2 numeric (18,2), 
         @OTValue2 numeric (18,2),
         @OT3 numeric (18,2), 
         @OTValue3 numeric (18,2), 
         @OT4 numeric (18,2), 
         @OTValue4 numeric (18,2), 
         @CreatedOn datetime,
		 @ModifiedBy nvarchar(50),
		 @ModifiedOn datetime,
		 @CreatedBy nvarchar(50)
	
	
	AS

	
BEGIN TRY
    -- Get New Primary key
Set @ADate = cast(@Adate as date) -- Daily Attendance Mandor stores as date time so need to convert to date
    
 IF NOT EXISTS( select OTSummaryID
    from Checkroll .OTDetail 
where EstateID = @Estateid
AND EmpID =@EmpID  
AND ActiveMonthYearID =@ActiveMonthYearID 
AND ADate =@ADate 
 )
    
    
    BEGIN
        
  
   Declare @count int
   Declare @ConcurrencyId timestamp  
   
    
    --SELECT @OTSummaryID =  @EstateCode+'R'+  CAST((CASE WHEN (ISNULL(MAX(Id), -1) = -1) THEN 1 WHEN MAX(Id) >= 1 THEN MAX(Id) + 1 END) AS VARCHAR)   FROM Checkroll.OTDetail ;
  
   SELECT @OTSummaryID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
                FROM    Checkroll.OTDetail
                DECLARE @i INT = 2
                WHILE EXISTS
                (SELECT id
                FROM     Checkroll.OTDetail
                WHERE   OTSummaryID = @OTSummaryID
                )
                BEGIN
                        SELECT @OTSummaryID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
                        FROM    Checkroll.OTDetail
                        SET @i = @i + 1
                END
                
                
                
                
                
                
  
	-- Insert statements for procedure here
	INSERT INTO Checkroll.OTDetail 
		(OTSummaryID,
		 EstateID,
		 EstateCode, 
		 ActiveMonthYearID, 
		 GangMasterID, 
		 Activity, 
		 MandoreID, 
		 KraniID, 
		 ADate, 
		 EmpID,
		 OT1, 
		 OTValue1, 
         OT2, 
         OTValue2, 
         OT3, 
         OTValue3, 
         OT4, 
         OTValue4, 
         CreatedBy, 
         CreatedOn, 
         ModifiedBy, 
         ModifiedOn
		)
	VALUES
		(
		
		 @OTSummaryID,
		 @EstateID,
		 @EstateCode, 
		 @ActiveMonthYearID, 
		 @GangMasterID, 
		 @Activity, 
		 @MandoreID, 
		 @KraniID, 
		 @ADate, 
		 @EmpID,
		 @OT1, 
		 @OTValue1, 
         @OT2, 
         @OTValue2, 
         @OT3, 
         @OTValue3, 
         @OT4, 
         @OTValue4, 
         @CreatedBy, 
         GETDATE (), 
         @ModifiedBy, 
          GETDATE ()
		);


	RETURN SCOPE_IDENTITY();	
END
ELSE
BEGIN

	    UPDATE Checkroll.OTDetail  SET 
	   --  OTSummaryID=@OTSummaryID,
		 EstateID=@EstateID,
		 EstateCode=@EstateCode,
		 ActiveMonthYearID=@ActiveMonthYearID, 
		 GangMasterID= @GangMasterID,
		 Activity= @Activity,
		 MandoreID= @MandoreID,
		 KraniID= @KraniID,
		 ADate= @ADate,
		 EmpID=@EmpID,
		 OT1=@OT1,
		 OTValue1=@OTValue1,
         OT2= @OT2,
         OTValue2=@OTValue2,
         OT3= @OT3,
         OTValue3= @OTValue3,
         OT4= @OT4,
         OTValue4= @OTValue4,
         ModifiedBy=@ModifiedBy,
		 ModifiedOn= GETDATE ()
	  where EstateID = @Estateid
and GangMasterID =@GangMasterID  
AND EmpID =@EmpID  
AND ActiveMonthYearID =@ActiveMonthYearID 
AND ADate =@ADate 

END

DELETE FROM Checkroll.OTDetail WHERE OT1=0 AND OT2=0 AND OT3=0 AND OT4=0 

	  
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


















