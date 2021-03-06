
GO
/****** Object:  StoredProcedure [Checkroll].[PremiSalaryUpdate]    Script Date: 02/02/2015 8:19:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [Checkroll].[PremiSalaryUpdate]
	-- Add the parameters for the stored procedure here
	@Class as varchar(2), 
	@Date as varchar(7),
	@EmpId as varchar(50),
	@ActiveMonthYearID as varchar(50)
AS
BEGIN
	DECLARE 
	@IsExistEmpSalary as int,
	@Premi as numeric(18,2)

	/*
	-- Begin
	-- 1. Search Premi for Employee
	*/
	SELECT	@Premi = FindPremi.Premi FROM (
		SELECT			Checkroll.GradeMonth.Id, 
						Checkroll.GradeMonth.ZMonth, 
						Checkroll.GradeMonth.ZYear, 
						Checkroll.GradeMonth.TotalBudget, 
						Checkroll.GradeMonthDetails.GradeMonthId, 
						Checkroll.GradeMonthDetails.EmpId, 
						Checkroll.GradeMonthDetails.Class, 
						Checkroll.CREmployee.EmpName, 
						SumRubber.Latex, 
						SumRubber.CupLump, 
						SumRubber.TreeLace, 
						LATEX_T.Rate as RATELatex,		--Rate of Latex
						CUPLUMP_T.Rate as RATECupLump,	--Rate of CupLump
						TREELACE_T.Rate as RATETreeLace,	--Rate of TreeLace
						(LATEX_T.Rate * Latex) as TOTALLatex,			--Rate of Latex * Latex
						(TREELACE_T.Rate * TreeLace) as TOTALTreeLace,	--Rate of CupLump * CupLump
						(CUPLUMP_T.Rate * CupLump) as TOTALCupLump,		--Rate of TreeLace * TreeLace
						((LATEX_T.Rate * Latex) + (CUPLUMP_T.Rate * CupLump) + (TREELACE_T.Rate * TreeLace)) as Premi	--Sum of (Rate * (Latex | CupLump | TreeLace)) <--- *** PREMI ***

		FROM            Checkroll.CREmployee 
						INNER JOIN Checkroll.GradeMonthDetails 
						ON Checkroll.CREmployee.EmpID = Checkroll.GradeMonthDetails.EmpId 
						RIGHT OUTER JOIN Checkroll.GradeMonth 
						ON Checkroll.GradeMonthDetails.GradeMonthId = Checkroll.GradeMonth.Id 
						LEFT OUTER JOIN (
							SELECT			NIK, 
											SUM(Latex) AS Latex, 
											SUM(CupLamp) AS CupLump, 
											SUM(TreeLace) AS TreeLace, 
											CONVERT(char(7), DateRubber, 20) AS Daterubber
							FROM            Checkroll.DailyReceptionForRubber
							WHERE			(CONVERT(char(7), DateRubber, 20) = @Date)
							GROUP BY		NIK, 
											CONVERT(char(7), DateRubber, 20)) AS SumRubber 
											ON Checkroll.CREmployee.EmpCode = SumRubber.NIK 
											LEFT JOIN (
												select	* 
												from	Checkroll.PremiSetupRubber 
												where	Class = @Class 
														AND Product = 'Latex') as LATEX_T 
														on Checkroll.GradeMonthDetails.Class = LATEX_T.Class
											LEFT JOIN (
												select	* 
												from	Checkroll.PremiSetupRubber 
												where	Class = @Class 
														AND Product = 'Cup Lump') as CUPLUMP_T
														on Checkroll.GradeMonthDetails.Class = CUPLUMP_T.Class
											LEFT JOIN (
												select	* 
												from	Checkroll.PremiSetupRubber 
												where	Class = @Class 
														AND Product = 'Tree Lace') as TREELACE_T
														on Checkroll.GradeMonthDetails.Class = TREELACE_T.Class

		WHERE			Checkroll.GradeMonth.ZMonth =  RIGHT(@Date,2) 
						AND GradeMonth.ZYear = LEFT(@Date,4)
						AND Checkroll.GradeMonthDetails.Class = @Class 
						AND GradeMonthDetails.EmpId = @EmpId
		) AS FindPremi
	/*
	-- End 1
	*/

	/*
	-- Begin
	-- 2. Check if Employee exist
	*/
	SELECT			@IsExistEmpSalary =  Count(*)
	FROM            Checkroll.Salary WHERE EmpID = @EmpId AND ActiveMonthYearID = @ActiveMonthYearID
	/*
	-- End 2
	*/


	/*
	-- Begin 
	-- 3. Update Premi in Salary Table
	*/
	IF @IsExistEmpSalary = 1
		BEGIN
			PRINT 'DATA IS EXIST'
			IF @Premi IS NOT NULL
				BEGIN
				UPDATE Checkroll.Salary set Premi = @Premi WHERE EmpID = @EmpId AND ActiveMonthYearID = @ActiveMonthYearID
				PRINT 'DATA UPDATED'
				END
		END
	ELSE
		PRINT 'DATA IS NOT EXIST'
	/*
	-- End 3
	*/
END
