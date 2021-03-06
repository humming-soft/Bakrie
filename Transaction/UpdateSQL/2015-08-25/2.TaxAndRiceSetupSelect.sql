
/****** Object:  StoredProcedure [Checkroll].[TaxAndRiceSetupSelect]    Script Date: 25/8/2015 9:55:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- ====================================================
-- Created By : Gopinath
-- Modified By: SIVA SUBRAMANIAN S
-- Created date: 1 Oct 2009
-- Last Modified Date:07/07/2010
-- Module     : CheckRoll, RKPMS Web
-- Screen(s)  : TaxAndRiceSetup.aspx
-- Description: Procedure to get Tax And Rice Setup
-- =====================================================
ALTER PROCEDURE [Checkroll].[TaxAndRiceSetupSelect]
-- Add the parameters for the stored procedure here
@EstateID NVARCHAR(50)
AS
        SET NOCOUNT ON;
        BEGIN
                SELECT   TaxRiceSetupID       ,
                         DeductionCost        ,
                         DeductionCostMax     ,
                         Jamsostek            ,
                         JkkAndJK             ,
                         RAEmployee           ,
                         RAHusbandOrWife      ,
                         RAChild              ,
                         RAPrice              ,
                         GradeI               ,
                         GradeIRange          ,
                         GradeII              ,
                         GradeIIRangeFrom     ,
                         GradeIIRangeTo       ,
                         GradeIII             ,
                         GradeIIIRangeFrom    ,
                         GradeIIIRangeTo      ,
                         GradeIV              ,
                         GradeIVRangeFrom     ,
                         GradeIVRangeTo       ,
                         GradeV               ,
                         GradeVRange          ,
                         GradeINPWP           ,
                         GradeIRangeNPWP      ,
                         GradeIINPWP          ,
                         GradeIIRangeFromNPWP ,
                         GradeIIRangeToNPWP   ,
                         GradeIIINPWP         ,
                         GradeIIIRangeFromNPWP,
                         GradeIIIRangeToNPWP  ,
                         GradeIVNPWP          ,
                         GradeIVRangeFromNPWP ,
                         GradeIVRangeToNPWP   ,
                         GradeVNPWP           ,
                         GradeVRangeNPWP      ,
                         TaxExemptionWorker   ,
                         TaxExemptionHusbWife ,
                         TaxExemptionChild    ,
                         FunctionalAllowanceP ,
                         MaxAllowance,
						 RANaturaPrice,
						 RAAstekPrice
                FROM     Checkroll.TaxAndRiceSetup
                WHERE    EstateID =@EstateID
                ORDER BY ModifiedOn DESC
        END

