USE [BSPMS_SR]
GO
/****** Object:  StoredProcedure [Checkroll].[OnCostProcess]    Script Date: 12/6/2014 5:16:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------
-- Remarks: On cost is calculated based on Checkroll.OtherPaymentDetail and grouped by Gang
--Modified by : Stanley
--Modified on : 31-07-2011
--Description : Used in Checkroll Monthly Processing
-------------------------------------------------------

--exec [CheckRoll].[OnCostProcess] 'M1','01R81','admin'
--select * from Checkroll.OnCostProcessing
--delete  from Checkroll.OnCostProcessing

ALTER PROCEDURE [Checkroll].[OnCostProcess]
@EstateId nvarchar(50),
@ActiveMonthYearID nvarchar(50),
@Createdby nvarchar(50)
AS
BEGIN
DECLARE @GangMasterID varchar(50)
DECLARE @Activity varchar(50)
DECLARE @BlkHK numeric(18,2)
DECLARE @RawatHK numeric(18,2)
DECLARE @Man int
DECLARE @ManRawat int
DECLARE @OnCost numeric(18,2)
DECLARE @OnCostRawat numeric(18,2)
DECLARE @Rice numeric(18,2)
DECLARE @RicePrice numeric(18,2)
Declare @Amonth int
Declare @Ayear int


Select @Amonth =Amonth, @Ayear =ayear from General.ActiveMonthYear where ActiveMonthYearID = @ActiveMonthYearID

DELETE FROM Checkroll .OnCostProcessing where Estateid=@ESTATEID AND ACTIVEMONTHYEARID= @ActiveMonthYearID 


DECLARE @getGangMasterID
CURSOR
        SET @getGangMasterID=
        CURSOR FOR

        SELECT DISTINCT GANGMASTERID, Activity FROM 
				(
				SELECT C_DTA .GangMasterID,C_DTA.Activity  FROM Checkroll .DailyTeamActivity C_DTA
				INNER JOIN Checkroll .GangMaster C_GM ON C_GM .GangMasterID =C_DTA .GangMasterID 
				WHERE C_DTA .Activity ='PANEN' AND C_DTA.ESTATEID=@ESTATEID --AND C_DTA.ActiveMonthYearID=@ActiveMonthYearID

				UNION ALL 

				SELECT C_DAD .GangMasterID,C_DTA.Activity   FROM Checkroll .DailyActivityDistribution C_DAD
				INNER JOIN Checkroll .GangMaster C_GM ON C_GM .GangMasterID =C_DAD .GangMasterID 
				INNER JOIN Checkroll .DailyTeamActivity C_DTA ON C_DTA .GangMasterID =C_GM .GangMasterID 
				WHERE UPPER (C_GM.DESCP) = 'PANEN' AND C_DAD.ESTATEID=@ESTATEID AND C_DAD.ActiveMonthYearID=@ActiveMonthYearID
				)CR 
				order by GangmasterID

                
                OPEN @getGangMasterID
                FETCH NEXT
                FROM  @getGangMasterID
                INTO  @GangMasterID ,
					  @Activity
                           
	                    WHILE @@FETCH_STATUS = 0
                        BEGIN


						SET @OnCost= (Select ISNULL(SUM(OnCost),0) From 
							(Select ISNULL(Holidayrate,0) + ISNULL(SundayRATE,0) + ISNULL(RaindayRATE,0) + ISNULL(SickdayRATE ,0) +  ISNULL(AdjdayRATE ,0) 
							+ ISNULL(Roundupvalue  ,0) AS OnCost from Checkroll.OtherPaymentDetail  
							Where ActiveMonthYearID = @ActiveMonthYearID AND GangMasterID = @GangMasterID AND EstateID =@ESTATEID ) B)
						
						-- SAI: check for RUBBER
						IF @Activity= 'PANEN'
						BEGIN 
						
						SET @Man=	(SELECT ISNULL(MAX (T.AA),0)   From 
								(Select Count(B.EmpID ) AA ,B .DailyTeamActivityID   From Checkroll .DailyTeamActivity A  
								INNER JOIN Checkroll .DailyAttendance B ON A .DailyTeamActivityID =B .DailyTeamActivityID 
								Where A .GangMasterID=@GangMasterID  AND A.EstateID=@ESTATEID AND B.ActiveMonthYearID=@ActiveMonthYearID
								  Group by B.DailyTeamActivityID,B.RDate )T)
							
						SET @BlkHK= (SELECT ISNULL (SUM (C_DR.BlkHK ) ,0) FROM Checkroll .DailyReceiption C_DR
							INNER JOIN Checkroll .DailyAttendance C_DA ON C_DA .DailyReceiptionID =C_DR .DailyReceiptionID 
							INNER JOIN Checkroll.DailyTeamActivity  C_TA ON C_TA.DailyTeamActivityID =C_DA .DailyTeamActivityID 
							WHERE C_TA .GangMasterID =@GangMasterID  AND C_DA.ESTATEID=@ESTATEID AND C_DA.ActiveMonthYearID=@ActiveMonthYearID)
												
						END
						SET @RawatHK = 0
						IF @Activity= 'LAIN'
						BEGIN
						SET @ManRawat  =(Select ISNULL(MAX (T.AA),0) From 
									(Select Count(B.EmpID ) AA ,B .DailyTeamActivityID   From Checkroll .DailyTeamActivity A  
									INNER JOIN Checkroll .DailyAttendance B ON A .DailyTeamActivityID =B .DailyTeamActivityID Where A .Activity ='LAIN' and A .GangMasterID=@GangMasterID 
									AND A.EstateID=@ESTATEID AND B.ActiveMonthYearID=@ActiveMonthYearID
									  Group by B.DailyTeamActivityID,B.RDate  )T)
															
						SET @RawatHK =( select ISNULL(SUM(Mandays ),0)   from Checkroll .DailyActivityDistribution C_DAD 
										INNER JOIN Checkroll .DailyTeamActivity  C_DA ON C_DA .GangMasterID     = C_DAD.GangMasterID  
										where C_DAD.GangMasterID =@GangMasterID AND C_DAD.EstateID =@ESTATEID AND C_DAD .ActiveMonthYearID =@ActiveMonthYearID
										AND C_DA.Activity ='LAIN'
										GROUP BY C_DAD.GangMasterID  )
																		
						END
											
						SET @Rice =(Select  SUM(Rice)  From 

									( Select  (ISNULL(C_RAL.RiceMax,0)* (ISNULL(C_ASUM.[11],0) + ISNULL(C_ASUM.J1, 0) + ISNULL(C_ASUM.[51], 0) + ISNULL(C_ASUM.CB, 0) 
									+ ISNULL(C_ASUM.CH, 0) + ISNULL(C_ASUM.CT, 0) + ISNULL(C_ASUM.I1, 0) + ISNULL(C_ASUM.I2, 0)+ ISNULL(C_ASUM.S1, 0) + ISNULL(C_ASUM.S2, 0)
									+ ISNULL(C_ASUM.S3, 0) + ISNULL(C_ASUM.S4, 0) + ISNULL(C_ASUM.CD, 0) + ISNULL(C_ASUM.H1,0) ))  /

									((SELECT DATEDIFF(DAY , G_FY.FromDT, G_FY.ToDT) + 1 FROM General.FiscalYear AS G_FY
									WHERE G_FY.FYear = G_AMY.AYear AND G_FY.Period = G_AMY.AMonth )	- 
									(Select  DATEDIFF(WEEK, G_FY.FromDT, G_FY.ToDT) from General.FiscalYear AS G_FY	
									WHERE G_FY.FYear = G_AMY.AYear AND G_FY.Period = G_AMY.AMonth) 
									- (SELECT COUNT(*)	FROM	Checkroll.PublicHolidaySetup
									WHERE 	MONTH(PHDate) = G_AMY.AMonth AND YEAR(PHDATE) = G_AMY.AYear AND EstateID = C_ASUM.EstateID
									))AS Rice

									FROM Checkroll.RiceAdvanceLog AS C_RAL
									INNER JOIN Checkroll.GangMaster AS C_GMASTER ON C_RAL.GangMasterID = C_GMASTER.GangMasterID
									INNER JOIN Checkroll .AttendanceSummary as C_ASUM ON C_ASUM .EmpID = C_RAL.EmpID 
									INNER JOIN General.ActiveMonthYear AS G_AMY ON C_RAL.ActiveMonthYearID = G_AMY.ActiveMonthYearID 
									where C_RAL.EstateID = @EstateId AND C_RAL.ActiveMonthYearID = @ActiveMonthYearID AND C_GMASTER.GangMasterID = @GangMasterID) A)
			
						--SAI: Check stock description for rice
						SET @RicePrice= 	(select  AvgPrice   from Store.StockDetail WHERe StockID=(Select Stockid from
									Store.Stmaster WHERE LTRIM(RTRIM(StockDesc)) = 'BERAS')
									AND EstateID =@EstateId AND ActiveMonthYearID =(Select ActiveMonthYearID from 
-- Commented by Stanley@31-07-2011									General.ActiveMonthYear where AMonth  = @Amonth AND AYear =  @Ayear AND ModID = 2 AND Status ='A'))
									General.ActiveMonthYear where EstateID = @EstateId AND AMonth  = @Amonth AND AYear =  @Ayear AND ModID = 2 AND Status ='A'))					
						
						
						IF @RawatHK =0
						BEGIN
						INSERT INTO [Checkroll].[OnCostProcessing]
								   ([EstateID]
								   ,[ActiveMonthYearID]
								   ,[GangMasterID]
								   ,[Activity]
								   ,[Man]
								   ,[TotHK]
								   ,[OnCost]
								   ,[Rice]
								   ,[RicePrice]
								   ,[CreatedBy]
								   ,[CreatedOn]
								   ,[ModifiedBy]
								   ,[ModifiedOn])
						VALUES			
									(@ESTATEID ,
									 @ActiveMonthYearID ,
									 @GangMasterID ,
									 'PANEN',
									 @Man ,
									 @BlkHK ,
									 @OnCost ,
									 @Rice ,
									 @RicePrice ,
									 @CreatedBY,
									 GETDATE (),
									 @CreatedBY,
									 GETDATE()) 
									
						END	
						
						IF @RawatHK <>0
						BEGIN
						Declare @CalcCost Numeric(18,0)
						
						SET @CalcCost = ROUND((@BlkHK / (@BlkHK +@RawatHK )) *@OnCost ,0)
						--Panen Team Insert
						
						UPDATE [Checkroll].[OnCostProcessing]
						SET [OnCost]=@CalcCost
						where EstateID= @ESTATEID AND ActivemonthYearID= @ActiveMonthYearID 
							  AND GangMasterID= @GangMasterID AND Activity= 'PANEN'					 
						--LIAN Team Insert		
						 
						INSERT INTO [Checkroll].[OnCostProcessing]
								   ([EstateID]
								   ,[ActiveMonthYearID]
								   ,[GangMasterID]
								   ,[Activity]
								   ,[Man]
								   ,[TotHK]
								   ,[OnCost]
								   ,[Rice]
								   ,[RicePrice]
								   ,[CreatedBy]
								   ,[CreatedOn]
								   ,[ModifiedBy]
								   ,[ModifiedOn])
						VALUES			
									(@ESTATEID ,
									 @ActiveMonthYearID ,
									 @GangMasterID ,
									 'LAIN',
									 @ManRawat  ,
									 @RawatHK  ,
									 (@OnCost - @CalcCost) ,
									 @Rice ,
									 @RicePrice ,
									 @CreatedBY,
									 GETDATE (),
									 @CreatedBY,
									 GETDATE()) 									 
																	
						END						
						FETCH NEXT
						FROM  @getGangMasterID
						INTO  @GangMasterID,
							  @Activity
						END
						
						
						
				CLOSE @getGangMasterID
				DEALLOCATE @getGangMasterID	
				
END


