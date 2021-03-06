
/****** Object:  StoredProcedure [Checkroll].[RateSetupAddConfigurableInsert]    Script Date: 7/7/2015 5:58:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Checkroll].[RateSetupAddConfigurableInsert]
--Add the parameters for the stored procedure here
		@Description varchar(200),
        @Category varchar(50),
        @EstateID nvarchar(50),
        @Percentage decimal(18, 2),
        @CalcType smallint,
        @AllowDeductionCode varchar(50)
AS
        BEGIN TRY
              insert into Checkroll.RateSetupAddConfigurable
			  ([Description],Category,Percentage,CalcType,AllowDeductionCode,EstateId)
			  values
			  (@Description,@Category,@Percentage,@CalcType,@AllowDeductionCode,@EstateID)

		END TRY 
		BEGIN CATCH DECLARE @ErrorMessage NVARCHAR(4000);
                 
                 DECLARE @ErrorSeverity INT;
                 DECLARE @ErrorState    INT;
                 SELECT @ErrorMessage  = ERROR_MESSAGE() ,
                        @ErrorSeverity = ERROR_SEVERITY(),
                        @ErrorState    = ERROR_STATE();
                 
                 RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
         END CATCH;








