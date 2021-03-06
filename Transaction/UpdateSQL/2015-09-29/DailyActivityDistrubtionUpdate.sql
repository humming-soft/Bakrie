/****** Object:  StoredProcedure [Checkroll].[DailyActivityDistributionWithTeamUpdate]    Script Date: 1/10/2015 2:55:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author        : Dadang Adi Hendradi
-- Create date   : 9 Oct 2009
-- Modified date : Sunday, 18 Oct 2009, 16:33
-- Modified date : Senin, 26 Oct 2009, 22:47
-- Modified date : Jum'at, 20 Nov 2009, 14:09
--                 Adding OvertimeCOAID field
-- Description:	for module DailyActivityWithTeam
--
-- =============================================
ALTER PROCEDURE [Checkroll].[DailyActivityDistributionWithTeamUpdate]
	-- Add the parameters for the stored procedure here
	@DailyDistributionID nvarchar(50) output,
	@EstateID nvarchar(50),
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
	--@UOMID nvarchar(50),
	@OT numeric(18,2),
	@ModifiedBy nvarchar(50),
	@ModifiedOn datetime,
	@Brondolan numeric(18,2),
	@MachineID nvarchar(50),
	@VhID nvarchar(50),
	@VHDetailCostCodeID nvarchar(50)
AS

BEGIN TRY

	    UPDATE Checkroll.DailyActivityDistribution SET
		EstateID=@EstateID,
		DailyReceiptionID=@DailyReceiptionID,
		ActiveMonthYearID=@ActiveMonthYearID,
		DistbDate=@DistbDate,
		GangMasterID=@GangMasterID,
		TotalHK=@TotalHK, 
		TotalOT=@TotalOT,
		ContractID=@ContractID,
		COAID = @COAID,
		OvertimeCOAID = @OvertimeCOAID,
		StationID = @StationID,
		DivID = @DivID,
		YOPID = @YOPID,
		BlockID = @BlockID,
		T0=@T0,
		T1=@T1,
		T2=@T2,
		T3=@T3,
		T4=@T4,
		Mandays=@Mandays,
		Ha=@Ha,
		--UOMID = @UOMID,
		OT=@OT,
		ModifiedBy=@ModifiedBy,
		ModifiedOn=@ModifiedOn,
		Brondolan=@Brondolan,
		MachineID=@MachineID,
		VhId = @vhid,
		VHDetailCostCodeID = @VHDetailCostCodeID
	
	WHERE DailyDistributionID=@DailyDistributionID 
	--and ConcurrencyId=@ConcurrencyId;
    --SELECT @ConcurrencyId = ConcurrencyId FROM Checkroll.DailyActivityDistribution WHERE DailyDistributionID=@DailyDistributionID;
END TRY
BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );

END CATCH;
