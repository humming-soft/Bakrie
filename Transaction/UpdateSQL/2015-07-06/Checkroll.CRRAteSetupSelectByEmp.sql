
/****** Object:  StoredProcedure [Checkroll].[CRRateSetupSelect]    Script Date: 6/7/2015 9:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Gets Data from Rate setup based on Employee Category And GRade
Create PROCEDURE [Checkroll].[CRRateSetupSelectByEmp]
@EstateID nvarchar(50),
@EmpID nvarchar(50)
AS
BEGIN
	DECLARE @Grade nvarchar(10)
	DECLARE @Category nvarchar(50)
	DECLARE @Level nvarchar(10)

	Select @Grade=Grade,@Category = Category, @Level = Level from Checkroll.CREmployee where Empid = @EmpID
	if @Category = 'KHT' or @Category = 'KHL' 
	begin
		SELECT
				RateSetupID, EstateID, Category, Code, Grade,
				HIPLevel, 
				StdRate, 
				BasicRate, 
				JHT,
				JHTEmployer,
				JKK, 
				JK, 
				OTDivider,
				RiceDividerDays ,				
				(Select RAPrice * RAEmployee from Checkroll.TaxAndRiceSetup WHere EstateID = @EstateID) as RicePayment,
				AdvancePremium,
				MandorPremium, 
				KraniPremium
			FROM
				Checkroll.RateSetup 
			WHERE
				EstateID = @EstateID AND
				Category = @Category 
			
	end 
	else
		BEGIN
			SELECT
				RateSetupID, EstateID, Category, Code, Grade,
				HIPLevel, 
				StdRate/RiceDividerDays as BasicRate, 
				BasicRate as BasicRate1, 
				JHT,
				JHTEmployer,
				JKK, 
				JK, 
				OTDivider,
				RiceDividerDays ,				
				(Select RAPrice * RAEmployee from Checkroll.TaxAndRiceSetup WHere EstateID = @EstateID) as RicePayment,
				AdvancePremium,
				MandorPremium, 
				KraniPremium
			FROM
				Checkroll.RateSetup 
			WHERE
				EstateID = @EstateID AND
				 HIPLevel = @Level AND Grade = @Grade

		EnD
END









