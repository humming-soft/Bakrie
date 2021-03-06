
/****** Object:  StoredProcedure [Checkroll].[PieceRateSelect]    Script Date: 25/11/2015 12:44:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ahmed Naxim
-- Alter date: 6 Oct 2012
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Checkroll].[PieceRateSelect]
	-- Add the parameters for the stored procedure here
	@EstateID nvarchar(50),
	@ReferenceNo nvarchar(50) = null
	
AS

	SET NOCOUNT ON;
	
IF (@ReferenceNo IS NULL)
	BEGIN
		SELECT        Checkroll.PieceRate.Id, Checkroll.PieceRate.ReferenceNo, Checkroll.PieceRate.EstateID, Checkroll.PieceRate.ActivityBy, Checkroll.PieceRate.Description, 
                         Checkroll.PieceRate.AllowanceDeductionCode, Checkroll.AllowanceDeductionSetup.Remarks,Checkroll.PieceRate.COAID
FROM            Checkroll.PieceRate LEFT OUTER JOIN
                         Checkroll.AllowanceDeductionSetup ON Checkroll.PieceRate.AllowanceDeductionCode = Checkroll.AllowanceDeductionSetup.AllowDedID AND 
                         Checkroll.PieceRate.EstateID = Checkroll.AllowanceDeductionSetup.EstateID
		WHERE 
			[Checkroll].[PieceRate].EstateID = @EstateID
		Order By [Checkroll].[PieceRate].Id Desc
	END
ELSE 
	BEGIN		
		SELECT        Checkroll.PieceRate.Id, Checkroll.PieceRate.ReferenceNo, Checkroll.PieceRate.EstateID, Checkroll.PieceRate.ActivityBy, Checkroll.PieceRate.Description, 
                         Checkroll.PieceRate.AllowanceDeductionCode, Checkroll.AllowanceDeductionSetup.Remarks,Checkroll.PieceRate.COAID
FROM            Checkroll.PieceRate LEFT OUTER JOIN
                         Checkroll.AllowanceDeductionSetup ON Checkroll.PieceRate.AllowanceDeductionCode = Checkroll.AllowanceDeductionSetup.AllowDedID AND 
                         Checkroll.PieceRate.EstateID = Checkroll.AllowanceDeductionSetup.EstateID
		WHERE 
			[Checkroll].[PieceRate].EstateID = @EstateID AND 
			[Checkroll].[PieceRate].ReferenceNo = @ReferenceNo
		Order By [Checkroll].[PieceRate].ReferenceNo Asc
	END
