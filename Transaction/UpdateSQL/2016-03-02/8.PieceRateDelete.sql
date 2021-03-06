
/****** Object:  StoredProcedure [Checkroll].[PieceRateDelete]    Script Date: 3/3/2016 11:46:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------


ALTER PROCEDURE [Checkroll].[PieceRateDelete]
	-- Add the parameters for the stored procedure here
	@EstateID nvarchar(50),
	@Id int
	
AS

	SET NOCOUNT ON;
	DECLARE @RefNo nvarchar(50)

	BEGIN
		SELECT @RefNo= ReferenceNo from Checkroll.PieceRate where Id = @Id

		--Delete related data
		Delete a from Checkroll.PieceRateTransaction a 
		inner join checkroll.PieceRateActivity b on a.PieceRateActivityId = b.Id
		where b.ReferenceNo = @RefNo
		
		delete a from Checkroll.PieceRateEmployee a
		inner join Checkroll.PieceRateActivity b on a.PieceRateActivityId = b.Id
		where b.ReferenceNo = @RefNo
		
		delete a from Checkroll.PieceRateContractor a
		inner join Checkroll.PieceRateActivity b on a.PieceRateActivityId = b.Id
		where b.ReferenceNo = @RefNo

		Delete from Checkroll.PieceRateActivity where ReferenceNo = @RefNo
		
		--delete piece rate
		DELETE FROM [Checkroll].[PieceRate] 
		WHERE 
			EstateID = @EstateID AND 
			Id = @Id
		
	END
