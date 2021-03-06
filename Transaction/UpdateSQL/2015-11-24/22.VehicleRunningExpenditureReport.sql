

ALTER PROCEDURE [Vehicle].[VehicleRunningExpenditureReport]

	-- Add the parameters for the stored procedure here
	
	@EstateID	nvarchar(50),
	@ActiveMonthYearID nvarchar(50)
	
	
AS 

DECLARE
		@EstateCode NVARCHAR(50),
        @AYear NUMERIC(18,2),
        @AMonth INT
        

--Select * FROM	Vehicle.VHChargeDetail 
	
		BEGIN
		
		SET @EstateCode =
        (SELECT EstateCode
        FROM    General.Estate
        WHERE   EstateID = @EstateID
        )
		
		SET @AYear =
        (SELECT AYear
        FROM    General.ActiveMonthYear
        WHERE   ActiveMonthYearID = @ActiveMonthYearID
        )

		SET @AMonth =
        (SELECT AMonth
        FROM    General.ActiveMonthYear
        WHERE   ActiveMonthYearID = @ActiveMonthYearID
        )        
		
		
		SELECT			VC.Category,
				--VHM.VHModel,
				VHType = CASE VHM.Type WHEN 'V' THEN 'Vehicle' WHEN 'W' THEN 'Workshop' WHEN 'O' THEN 'Others' END,
				VHC.VHWSCode, 
				UOM = CASE VHM.UOM WHEN 'H' THEN 'Hrs' WHEN 'K' THEN 'Kms' END,
				COA.COACode,
				Running =	COALESCE(CASE @AMonth
							WHEN 1 THEN VHR.M1 
							WHEN 2 THEN VHR.M2
							WHEN 3 THEN VHR.M3
							WHEN 4 THEN VHR.M4
							WHEN 5 THEN VHR.M5
							WHEN 6 THEN VHR.M6
							WHEN 7 THEN VHR.M7
							WHEN 8 THEN VHR.M8
							WHEN 9 THEN VHR.M9
							WHEN 10 THEN VHR.M10
							WHEN 11 THEN VHR.M11
							WHEN 12 THEN VHR.M12
							END,0),
				 --VHC.JDescp, 
				 COA.COADescp, 
				 --COA.OldCOACode, 
				 VHC.Value, 
				 VHD.VHDescp AS VHDetailCostCode,
				 VHD.VHDetailCostCode AS VHDetailCode
				 
			    
		FROM	Vehicle.VHChargeDetail VHC
				--INNER JOIN Vehicle.VHMaster VHM ON VHC.VHWSCode = VHM.VHWSCode 
				--INNER JOIN Vehicle.VHMaster AS VHM
   				--ON       VRL.VHID = VHM.VHID
   				--INNER JOIN General.ActiveMonthYear GMY 
   				--ON VHC.ActiveMonthYearID = GMY.ActiveMonthYearID
   				INNER JOIN Vehicle.VHWSMasterHistory AS VHM ON VHC.VHWSCode = VHM.VHWSCode AND VHM.AMonth = VHC.AMonth AND VHM.AYear = VHC.AYear 
				LEFT JOIN Vehicle.VHCategory VC ON VHM.VHCategoryID = VC.VHCategoryID
				LEFT JOIN Vehicle.VHRunningDetail VHR ON VHR.VHWSCode = VHC.VHWSCode AND VHR.AYear = @AYear
				LEFT JOIN Accounts.COA COA ON COA.COAID		=	VHM.COAID 
				LEFT JOIN Vehicle.VHDetailCostCode VHD ON VHC.VHDetailCostCode = VHD.VHDetailCostCode AND VHD.EstateID = @EstateID
		WHERE 
				VHC.EstateCodeL = @EstateCode
				AND VHC.AMonth = @AMonth 
				AND VHC.AYear = @AYear 
				--AND VHC.Type = 'V'
				
		UNION ALL
		SELECT	VC.Category,
				--VHM.VHModel,
				VHType = CASE VHM.Type WHEN 'V' THEN 'Vehicle' WHEN 'W' THEN 'Workshop' WHEN 'O' THEN 'Others' END,
				VUD.VHWSCode, 
				UOM = CASE VHM.UOM WHEN 'H' THEN 'Hrs' WHEN 'K' THEN 'Kms' END,
				COA.COACode,
				Running =	COALESCE(CASE @AMonth
							WHEN 1 THEN VHR.M1 
							WHEN 2 THEN VHR.M2
							WHEN 3 THEN VHR.M3
							WHEN 4 THEN VHR.M4
							WHEN 5 THEN VHR.M5
							WHEN 6 THEN VHR.M6
							WHEN 7 THEN VHR.M7
							WHEN 8 THEN VHR.M8
							WHEN 9 THEN VHR.M9
							WHEN 10 THEN VHR.M10
							WHEN 11 THEN VHR.M11
							WHEN 12 THEN VHR.M12
							END, 0),
				 --VHC.JDescp, 
				 COA.COADescp, 
				 --COA.OldCOACode, 
				 VUD.Value, 
				 VHD.VHDescp AS VHDetailCostCode,
				 VHD.VHDetailCostCode AS VHDetailCode
				 
			    
		FROM	Vehicle.VHUnDistributedCost VUD
				--INNER JOIN Vehicle.VHMaster VHM ON VHC.VHWSCode = VHM.VHWSCode 
				--INNER JOIN Vehicle.VHMaster AS VHM
   				--ON       VRL.VHID = VHM.VHID
   				--INNER JOIN General.ActiveMonthYear GMY 
   				--ON VHC.ActiveMonthYearID = GMY.ActiveMonthYearID
   				LEFT JOIN Vehicle.VHWSMasterHistory AS VHM ON VUD.VHWSCode = VHM.VHWSCode AND VHM.AMonth = VUD.AMonth AND VHM.AYear = VUD.AYear 
				LEFT JOIN Vehicle.VHCategory VC ON VHM.VHCategoryID = VC.VHCategoryID
				LEFT JOIN Vehicle.VHRunningDetail VHR ON VHR.VHWSCode = VUD.VHWSCode AND VHR.AYear = @AYear
				LEFT JOIN Accounts.COA COA ON COA.COAID		=	VHM.COAID 
				LEFT JOIN Vehicle.VHDetailCostCode VHD ON VUD.VHDetailCostCode = VHD.VHDetailCostCode AND VHD.EstateID = @EstateID
		WHERE 
				VUD.EstateCode = @EstateCode
				AND VUD.AMonth = @AMonth 
				AND VUD.AYear = @AYear 
		
END	

	













