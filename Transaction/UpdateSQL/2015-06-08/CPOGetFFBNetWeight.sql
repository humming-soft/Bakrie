
/****** Object:  StoredProcedure [Production].[CPOGetFFBNetWeight]    Script Date: 8/6/2015 12:46:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- ALTERd By : Reeta Sheba .D
-- Modified By: kumar
-- ALTERd date: 13thNov  2009
-- Last Modified Date: Apr 13 2010
-- Module     : Production
-- Screen(s)  : CPOProduction
-- Description: Procedure to Get Net weight of FFB from Weigh Bridge
-- ==================================================================
ALTER PROCEDURE [Production].[CPOGetFFBNetWeight]    
 @EstateID as nvarchar(50),
 @ProductionLogDate as  nvarchar(50)
 AS     
     
 declare @ActiveMonthYearID nvarchar(50)
--declare @ActiveMonthYearIDProd nvarchar(50)

		select @ActiveMonthYearID=ActiveMonthYearID 
		 from  General.ActiveMonthYear 
		 where ModID='4' and Status = 'A' 
		 and EstateID=@EstateID   --'M1'--   

------For Month--------------
   BEGIN     
            
   SELECT SUM(WeighBridge.NetWeight) as NetWeight
    from Weighbridge.WBWeighingInOut  as WeighBridge 
	left join Weighbridge.WBProductMaster as Product on Weighbridge.ProductID = Product.ProductID
    where 
    Weighbridge.EstateID=@EstateID  And 
    Weighbridge.ActiveMonthYearID=@ActiveMonthYearID And
    Weighbridge.WeighingDate = @ProductionLogDate And
    Product.ProductCode = '001'
    
        
	
END
