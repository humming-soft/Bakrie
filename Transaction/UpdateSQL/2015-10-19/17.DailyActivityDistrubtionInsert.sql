/****** Object:  StoredProcedure [Checkroll].[DailyActivityDistributionWithTeamInsert]    Script Date: 1/10/2015 2:46:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author        : Dadang Adi Hendradi,,Name>
-- Create date   : 9 Oct 2009
-- Modifed date  : unday, 18 Oct 2009, 16:33
-- Modified dated: Senin, 26 Oct 2009, 22:47
--
-- Modified date : Jum'at, 20 Nov 2009, 11:51
--                 Tambahan Overtime COAID
-- Description   :
-- =============================================

ALTER PROCEDURE [Checkroll].[DailyActivityDistributionWithTeamInsert]
	-- Add the parameters for the stored procedure here
	@DailyDistributionID nvarchar(50) output,
	@EstateID nvarchar(50),
	@EstateCode nvarchar(50),
	@DailyReceiptionID nvarchar(50),
	@ActiveMonthYearID nvarchar(50),
	@DistbDate datetime,
	@GangMasterID nvarchar(50),
	@TotalHK numeric(18,2), 
	@TotalOT  numeric(18,2),
	@ContractID nvarchar(50),
	@COAID nvarchar(50),
	@OvertimeCOAID nvarchar(50),
	@StationID nvarchar(50),
	@DivID nvarchar(50),
	@YOPID nvarchar(50),
	@BlockID nvarchar(50),
	@T0 nvarchar(50),
	@T1 nvarchar(50),
	@T2 nvarchar(50),
	@T3 nvarchar(50),
	@T4 nvarchar(50),
	@Mandays numeric(18,2),
	@Ha numeric(18,2),
	@UOMID nvarchar(50),
	@OT numeric(18,2),
	@CreatedBy nvarchar(50),
	@CreatedOn datetime,
	@ModifiedBy nvarchar(50),
	@ModifiedOn datetime,
	@Brondolan numeric(18,2),
	@MachineID nvarchar(50),
	@VhID nvarchar(50),
	@VHDetailCostCodeID nvarchar(50)
AS

	
BEGIN TRY
    -- Get New Primary key
  --  Declare @count int
     SELECT @DailyDistributionID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
                FROM   Checkroll.DailyActivityDistribution
                DECLARE @i INT = 2
                WHILE EXISTS
                (SELECT id
                FROM    Checkroll.DailyActivityDistribution
                WHERE   DailyDistributionID = @DailyDistributionID
                )
                BEGIN
                        SELECT @DailyDistributionID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
                        FROM   Checkroll.DailyActivityDistribution
                        SET @i = @i + 1
                END
 
    
    --SELECT @count = (ISNULL(MAX(Id),0) + 1) FROM Checkroll.DailyActivityDistribution ;
    --SET @DailyDistributionID = @EstateCode+'R'+ CONVERT(NVARCHAR,@count);;
    
	-- Insert statements for procedure here
	INSERT INTO Checkroll.DailyActivityDistribution
		(
		DailyDistributionID,
		EstateID,
		DailyReceiptionID,
		ActiveMonthYearID,
		DistbDate,
		GangMasterID,
		TotalHK, 
		TotalOT,
		ContractID,
		COAID,
		OvertimeCOAID,
		StationID,
		DivID,
		YOPID,
		BlockID,
		T0,
		T1,
		T2,
		T3,
		T4,
		Mandays,
		Ha,
		UOMID,
		OT,
		CreatedBy,
		CreatedOn,
		ModifiedBy,
		ModifiedOn,
		Brondolan,
		MachineID,
		Vhid,
		VHDetailCostCodeID)
	VALUES
		(
		@DailyDistributionID,
		@EstateID,
		@DailyReceiptionID,
		@ActiveMonthYearID,
		@DistbDate,
		@GangMasterID,
		@TotalHK, 
		@TotalOT,
		@ContractID,
		@COAID,
		@OvertimeCOAID,
		@StationID,
		@DivID,
		@YOPID,
		@BlockID,
		@T0,
		@T1,
		@T2,
		@T3,
		@T4,
		@Mandays,
		@Ha,
		@UOMID,
		@OT,
		@CreatedBy,
		@CreatedOn,
		@ModifiedBy,
		@ModifiedOn,
		@Brondolan,
		@MachineID,
		@VhID,
		@VHDetailCostCodeID);

	--SELECT @ConcurrencyId = ConcurrencyId FROM Checkroll.DailyActivityDistribution WHERE DailyDistributionID=@DailyDistributionID;

	RETURN SCOPE_IDENTITY();	
	
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
