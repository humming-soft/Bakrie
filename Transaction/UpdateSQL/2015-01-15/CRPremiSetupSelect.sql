
/****** Object:  StoredProcedure [Checkroll].[CRPremiSetupSelect]    Script Date: 15/1/2015 9:37:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--========
--<Author : Dadang Adi Hendradi >
--<Created : Sunday, 11 Oct 2009 >
--========
ALTER PROCEDURE [Checkroll].[CRPremiSetupSelect]
@EstateID nvarchar(50),
@BlockID nvarchar(50),
@AttendanceSetupID nvarchar(50)
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SELECT
		CR_PS.DivID, CR_PS.YOPID, CR_PS.BlockID,
		CR_PS.AttendanceSetupID,
		CR_PS.MinBunches, CR_PS.MaxBunches, CR_PS.BunchRate,
		CR_PS.MinLooseFruits, CR_PS.MaxLooseFruits, CR_PS.LooseFruitsRate		
	FROM
		Checkroll.PremiSetup AS CR_PS
	WHERE
		CR_PS.EstateID = @EstateID AND
		CR_PS.BlockID = @BlockID AND
		CR_PS.AttendanceSetupID = @AttendanceSetupID
	order by CR_PS.MinBunches	
END













