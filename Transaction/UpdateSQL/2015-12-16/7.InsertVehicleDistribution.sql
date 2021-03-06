/****** Object:  StoredProcedure [Vehicle].[VehicleDistributionINSERT]    Script Date: 16/12/2015 5:30:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- ====================================================
-- Created By : Gopinath
-- Modified By:  1 Nov 2009
-- Created date: 27th Feb 2009
-- Last Modified Date: 9th Apr 2009
-- Module     : Vehicle
-- Screen(s)  : Vehicle Distribution
-- Description: Procedure to Insert Vehicle Distribution
-- =====================================================
ALTER PROCEDURE [Vehicle].[VehicleDistributionINSERT] (
                                                    
                                                    @EstateID NVARCHAR(50),
                                                    @ActiveMonthYearID NVARCHAR(50),
                                                    --@VHDistributionID NVARCHAR(50) OUTPUT,
                                                    @DistributionDT DATETIME,
                                                    @VHID NVARCHAR(50),
                                                    @TotalRunningKmHours     NUMERIC(18,2),
                                                    @TotalKmHoursDistributed NUMERIC(18,2),
                                                    @COAID NVARCHAR(50),
                                                    @KmHours         NUMERIC(18,2),
                                                    @BalanceToDistribute NUMERIC(18,2),
                                                    @PrestasiTonBunchesKm NUMERIC(18,2),
                                                    @T0 NVARCHAR(50),
                                                    @T1 NVARCHAR(50),
                                                    @T2 NVARCHAR(50),
                                                    @T3 NVARCHAR(50),
                                                    @T4 NVARCHAR(50),                                                    
                                                    @DivID NVARCHAR(50),
                                                    @YOPID NVARCHAR(50),
                                                    @BlockID NVARCHAR(50),
                                                    @Remarks NVARCHAR(200),
                                                    @CreatedBy NVARCHAR(50)
                                                    )
AS
        DECLARE @VHDistributionID NVARCHAR(50)
        DECLARE @ISDuplicate NVARCHAR(50),
        		@WorkshopCode NVARCHAR(50),
                @VehicleCode NVARCHAR(50)--,
                
        BEGIN
        
                        
                IF NOT EXISTS(SELECT VHD.VHID FROM Vehicle.VHDistribution VHD WHERE VHD.VHID = @VHID AND VHD.EstateID = @EstateID AND VHD.ActiveMonthYearID = @ActiveMonthYearID AND VHD.DistributionDT = @DistributionDT AND VHD.COAID = @COAID AND VHD.BlockID = @BlockID and VHD.TotalKmHoursDistributed = @TotalKmHoursDistributed) --ISNULL(@ISDuplicate, 'NotDuplicated') = 'NotDuplicated'
                BEGIN
                
                --DECLARE @Count INT
                --        SELECT @Count = (ISNULL(MAX(Id),0) + 1)
                --        FROM   Vehicle.VHDistribution
                --        SELECT @VHDistributionID = (
                --               (SELECT ESTATECODE
                --               FROM    [General].Estate
                --               WHERE   EstateID = @EstateID
                --               ) + 'R' + CONVERT(NVARCHAR,@Count)) --<EstateCode> + 'R' + <Max(ID) + 1>
                
						DECLARE @Count INT, @EstateCode NVARCHAR(50)
        	
        				SELECT @EstateCode = EstateCode FROM    [General].Estate WHERE   EstateID = @EstateID
        	
        				SELECT @VHDistributionID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
						FROM   Vehicle.VHDistribution
		                
						DECLARE @i INT = 2
						WHILE EXISTS
						(SELECT id
						FROM    Vehicle.VHDistribution
						WHERE   VHDistributionID = @VHDistributionID
						)
						BEGIN
								SELECT @VHDistributionID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
								FROM   Vehicle.VHDistribution
								SET @i = @i + 1
						END
               
                /* Procedure body */
                INSERT
                INTO   Vehicle.VHDistribution
                       (
                              VHDistributionID        ,
                              EstateID                ,
                              ActiveMonthYearID       ,
                              DistributionDT        ,
                              VHID                    ,
                              TotalRunningKmHours     ,
                              TotalKmHoursDistributed ,
                              COAID                   ,
                              KmHours              ,
                              BalanceToDistribute      ,
                              PrestasiTonBunchesKm,
                              T0                   ,
                              T1                   ,
                              T2                   ,
                              T3                   ,
                              T4                   ,
                              DivID                   ,
                              YOPID                   ,
                              BlockID                 ,
                              Remarks              ,
                              CreatedBy               ,
                              CreatedOn ,
                              ModifiedBy               ,
                              ModifiedOn 
                       )
                       VALUES
                       (
                              @VHDistributionID		  ,	
                              @EstateID               ,
                              @ActiveMonthYearID      ,
                              @DistributionDT       ,
                              @VHID                   ,
                              --@VehicleCode ,
                              @TotalRunningKmHours    ,
                              @TotalKmHoursDistributed,
                              --@COAID                  ,
                              --@COACode,
                              @COAID,
                              @KmHours             ,
                              @BalanceToDistribute     ,
                              @PrestasiTonBunchesKm,
                              @T0                  ,
                              @T1                 ,
                              @T2                 ,
                              @T3                 ,
                              @T4                ,
                              @DivID                  ,
                              @YOPID                  ,
                              @BlockID                ,
                              @Remarks             ,
                              @CreatedBy              ,
                              GETDATE(),
                              @CreatedBy              ,
                              GETDATE()
                       )
                       
                DECLARE   @D DATETIME, @AYear INT, @AMonth INT
                
                SELECT @D= GETDATE(), @AYear = AYear, @AMonth = AMonth
				FROM    General.ActiveMonthYear
				WHERE   ActiveMonthYearID = @ActiveMonthYearID
			                       
				EXEC General.TaskMonitorUPDATE @EstateID,@AYear,@AMonth,3,'Vehicle Distribution approval','N',@CreatedBy,@D--,@CreatedBy,@D
				
                SELECT 1
                END
                ELSE
                BEGIN
                 SELECT 10
                END
        END
        
        
         










