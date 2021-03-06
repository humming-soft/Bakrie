
/****** Object:  StoredProcedure [Checkroll].[GradeMonthInsert]    Script Date: 14/03/2015 1:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [Checkroll].[GradeMonthInsert]
	-- Add the parameters for the stored procedure here
	@ZMonth as int,
	@ZYear as int,
	@TotalBudget as numeric(18,2)
	--@Id as int output
AS
BEGIN
	declare @isExist as integer
	Select @isExist= Count(*) from Checkroll.GradeMonth where ZMonth = @ZMonth and ZYear = @ZYear
	if @isExist = 0
	BEGIN
		Insert into Checkroll.GradeMonth (ZMonth, ZYear, TotalBudget) values (@ZMonth, @ZYear, @TotalBudget)
		--select top 1 @id = id from Checkroll.GradeMonth order by id desc
		SELECT ID FROM Checkroll.GradeMonth WHERE id = SCOPE_IDENTITY()
	END
	else
	BEGIN
		Update Checkroll.GradeMonth set TotalBudget = @TotalBudget where ZMonth = @ZMonth AND ZYear = @ZYear
		--Update untuk hitung Premi jika sudah ada data yang di simpan
		--declare @index int, @AttCode varchar(3), @DateRubber datetime ,@NIk varchar(15),@DRRubberID varchar(50),@DailyReceiptionID varchar(50),@EstateCode varchar(50),@Latex float,@Drc float,@CupLamp float,@DRCCupLump float,@TreeLace float,@DRCTreeLace float
		--DECLARE cProduct CURSOR local read_only FOR
		--select DateRubber,NIK,DailyReceiptionID,Latex,Drc,CupLamp,DRCCupLump,TreeLace,DRCTreeLace,AttCode,DRRubberID from Checkroll.DailyReceptionForRubber where MONTH(DateRubber) = @ZMonth and YEAR(DateRubber) = @ZYear
		----select * from Checkroll.DailyReceptionForRubber
		--OPEN cProduct
		--FETCH FROM cProduct INTO @DateRubber,@NIk,@EstateCode,@Latex,@Drc,@CupLamp,@DRCCupLump,@TreeLace,@DRCTreeLace,@AttCode,@DRRubberID
		--WHILE @@fetch_status = 0 
		--BEGIN
		--	set @DailyReceiptionID=@EstateCode
		--	SELECT @index =CHARINDEX('R',@EstateCode)
		--	SELECT @EstateCode=LEFT(@EstateCode,6-1)
		--	declare @PremiDasar money=0,@PremiProgresif money =0 ,@PremiBonus money =0  , @PremiMinggu money=0
		--	if(@AttCode ='11')
		--		begin		
		--			set @PremiDasar =@PremiDasar+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,80,@Latex,@Drc,'Latex','D')
		--			set @PremiProgresif =@PremiProgresif+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,80,@Latex,@Drc,'Latex','P')
		--			set @PremiBonus = @PremiBonus+[Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,80,@Latex,@Drc,'Latex','B')

		--			set @PremiDasar =@PremiDasar+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,12,@CupLamp,@DRCCupLump,'Cup Lump','D')
		--			set @PremiProgresif =@PremiProgresif+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,12,@CupLamp,@DRCCupLump,'Cup Lump','P')
		--			set @PremiBonus = @PremiBonus+[Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,12,@CupLamp,@DRCCupLump,'Cup Lump','B')

		--			set @PremiDasar =@PremiDasar+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,8,@TreeLace,@DRCTreeLace,'Tree Lace','D')
		--			set @PremiProgresif =@PremiProgresif+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,8,@TreeLace,@DRCTreeLace,'Tree Lace','P')
		--			set @PremiBonus = @PremiBonus+[Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,8,@TreeLace,@DRCTreeLace,'Tree Lace','B')
		--		end 
		--	else if(@AttCode ='M1')
		--		begin
		--			set @PremiMinggu = @PremiMinggu+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,80,@Latex,@DRC,'Latex','M')
		--			set @PremiMinggu = @PremiMinggu+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,12,@CupLamp,@DRCCupLump,'Cup Lump','M')
		--			set @PremiMinggu = @PremiMinggu+ [Checkroll].[CalculatePremi](@DateRubber,@NIk,@EstateCode,8,@TreeLace,@DRCTreeLace,'Tree Lace','M')
		--		end
		--	update Checkroll.DailyReceptionForRubber set PremiBonus=@PremiBonus,PremiDasar=@PremiDasar,PremiMinggu=@PremiMinggu, PremiProgresif=@PremiProgresif where DailyReceiptionID=@DailyReceiptionID and DRRubberID=@DRRubberID
		--	FETCH NEXT FROM cProduct INTO  @DateRubber,@NIk,@EstateCode,@Latex,@Drc,@CupLamp,@DRCCupLump,@TreeLace,@DRCTreeLace,@AttCode,@DRRubberID
		--END
		--CLOSE cProduct
		--DEALLOCATE cProduct
		SELECT ID From Checkroll.GradeMonth WHERE ZMonth = @ZMonth AND ZYear = @ZYear
	END

	
END

