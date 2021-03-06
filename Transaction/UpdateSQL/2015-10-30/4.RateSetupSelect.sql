
/****** Object:  StoredProcedure [Checkroll].[RateSetupSelect]    Script Date: 29/10/2015 9:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Checkroll].[RateSetupSelect]
	-- Add the parameters for the stored procedure here
	@RateSetupID nvarchar(50),
	@EstateID nvarchar(50),
	@Category nvarchar(50)
	--@Id int,
	--@startRowIndex int,
	-- @maximumRows int

AS
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
IF (@RateSetupID IS NULL) -- Select all
	BEGIN
		
	if (@Category ='KHT') or (@Category ='KHL') or (@Category ='PKWT')
	SELECT ROW_NUMBER() OVER(ORDER BY C_Rs.id) AS RowRank,C_Rs.Id ,C_Rs.RateSetupID ,C_Rs.EstateID ,C_Rs.Category ,C_Rs.Code ,C_Rs.Grade ,C_Rs.HIPLevel ,C_Rs.StdRate ,C_Rs.BasicRate ,C_Rs.JHT,C_Rs.JHTEmployer  ,C_Rs.JKK ,C_Rs.JK,C_Rs .AIFull,C_Rs .AIHalf  ,C_Rs.OTDivider  , C_Rs.RiceDividerDays, C_Rs.AdvancePremium  ,C_Rs.MandorPremium  ,C_Rs.KraniPremium  ,C_Rs.ConcurrencyId  ,C_Rs.CreatedBy  ,C_Rs.CreatedOn  ,C_Rs.ModifiedBy  ,C_Rs.ModifiedOn ,C_Rs.Type
		From Checkroll .RateSetup   C_Rs
		INNER JOIN General .Estate G_E on G_E.EstateID =C_Rs.EstateID 
		
		 WHERE   C_Rs.EstateID= @EstateID  and C_Rs .Category =@Category ORDER BY C_Rs .ModifiedOn DESC
		 
	if (@Category ='KT')
	--SET @Category ='';
		
		SELECT ROW_NUMBER() OVER(ORDER BY C_Rs.id) AS RowRank,C_Rs.Id ,C_Rs.RateSetupID ,C_Rs.EstateID ,C_Rs.Category ,C_Rs.Code ,C_Rs.Grade ,C_Rs.HIPLevel ,C_Rs.StdRate ,C_Rs.BasicRate ,C_Rs.JHT ,C_Rs.JHTEmployer,C_Rs.JKK ,C_Rs.JK  ,C_Rs .AIFull,C_Rs .AIHalf ,C_Rs.OTDivider , C_Rs.RiceDividerDays ,C_Rs.AdvancePremium  ,C_Rs.MandorPremium  ,C_Rs.KraniPremium  ,C_Rs.ConcurrencyId  ,C_Rs.CreatedBy  ,C_Rs.CreatedOn  ,C_Rs.ModifiedBy  ,C_Rs.ModifiedOn ,C_Rs.Type
		From Checkroll .RateSetup   C_Rs
		INNER JOIN General .Estate G_E on G_E.EstateID =C_Rs.EstateID 
		
		 WHERE   C_Rs.EstateID= @EstateID and C_Rs .Category = @Category ORDER BY C_Rs.ModifiedOn DESC

	END
ELSE
	BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY C_Rs.id) AS RowRank,C_Rs.Id ,C_Rs.RateSetupID ,C_Rs.EstateID ,C_Rs.Category ,C_Rs.Code ,C_Rs.Grade ,C_Rs.HIPLevel ,C_Rs.StdRate ,C_Rs.BasicRate ,C_Rs.JHT,C_Rs.JHTEmployer ,C_Rs.JKK ,C_Rs.JK  ,C_Rs .AIFull,C_Rs .AIHalf ,C_Rs.OTDivider , C_Rs.RiceDividerDays ,C_Rs.AdvancePremium  ,C_Rs.MandorPremium  ,C_Rs.KraniPremium  ,C_Rs.ConcurrencyId  ,C_Rs.CreatedBy  ,C_Rs.CreatedOn  ,C_Rs.ModifiedBy  ,C_Rs.ModifiedOn ,C_Rs.Type
		From Checkroll .RateSetup   C_Rs
		INNER JOIN General .Estate G_E on G_E.EstateID =C_Rs.EstateID 
		
		 WHERE C_Rs.EstateID= @EstateID and C_Rs.RateSetupID=@RateSetupID and C_Rs .Category =@Category ORDER BY C_Rs .ModifiedOn DESC

	END











