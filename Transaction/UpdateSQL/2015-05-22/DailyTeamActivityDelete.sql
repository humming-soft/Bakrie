
GO
/****** Object:  StoredProcedure [Checkroll].[DailyTeamActivityDelete]    Script Date: 19/5/2015 10:47:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Checkroll].[DailyTeamActivityDelete]

@DailyTeamActivityID nvarchar(50),
@ActivityCode nvarchar(10),
@DDate DATE,
@OutputType nvarchar(1) OUTPUT
 
AS
BEGIN

	DECLARE @OutputReturn nvarchar
			
		IF @ActivityCode='PANEN' or @ActivityCode = 'DERES'
				BEGIN -- Deletion for #PANEN Activity
				
				DECLARE @Panen TABLE
						(DTA_DailyTeamActivityID varchar(50),
						 DA_DailyReceiptionID varchar(50),
						 DR_DailyReceiptionDetID varchar(50),
						 DRWT_DailyReceiptionDetID varchar(50),
						 RTD_GangMasterID varchar(50),
						 RS_GangMasterID varchar(50))
						   
							BEGIN
							INSERT INTO @Panen
							SELECT a.DailyTeamActivityId as DTA_DailyTeamActivityID,
							       b.DailyReceiptionID as DA_DailyReceiptionID,
							       c.DailyReceiptionDetID as DR_DailyReceiptionDetID,
							       f.DailyReceiptionDetID as DRWT_DailyReceiptionDetID,
							       d.GangMasterID as RTD_GangMasterID,
							       e.GangMasterID as RS_GangMasterID
						    FROM Checkroll.DailyTeamActivity a 
							     left join Checkroll.DailyAttendance b on b.DailyTeamActivityID = a.DailyTeamActivityID
							     left join Checkroll.DailyReceiption c on c.DailyReceiptionID = b.DailyReceiptionID
							     left join Checkroll.DailyReceptionWithTeam f on f.DailyReceiptionDetID = c.DailyReceiptionDetID 
							     left join Checkroll.ReceptionTargeDetail d on d.DailyReceiptionDetID=c.DailyReceiptionDetID
							     left join Checkroll.ReceptionSummary e on e.GangMasterID=a.GangMasterID
							     WHERE a.DailyTeamActivityID = @DailyTeamActivityID AND a.DDate=@DDate
							END
			 
			
				
			DELETE from Checkroll.ReceptionSummary where GangMasterID in (select RS_GangMasterID from @PANEN)
			DELETE from Checkroll.ReceptionTargeDetail where GangMasterID in (select RTD_GangMasterID from @PANEN)
			DELETE from Checkroll.DailyReceptionWithTeam where DailyReceiptionDetID in (select DRWT_DailyReceiptionDetID from @Panen)
			DELETE from Checkroll.DailyReceiption where DailyReceiptionDetID in (select DR_DailyReceiptionDetID from @PANEN)
			DELETE from Checkroll.DailyAttendance where DailyReceiptionID in (select DA_DailyReceiptionID from @PANEN)
			DELETE from Checkroll.DailyTeamActivity where DailyTeamActivityID in (select DTA_DailyTeamActivityId from @PANEN)
			Delete from Checkroll.DailyGangEmployeeSetup where DailyTeamActivityID in (Select DTA_DailyTeamActivityId from @Panen)
			Delete from Checkroll.DailyReceptionForRubber where DailyReceiptionID in (select DA_DailyReceiptionID from @PANEN)

			SET @OutputReturn=0
			
			--SELECT * FROM @Panen
			--select * from Checkroll.ReceptionSummary where GangMasterID in (select RS_GangMasterID from #PANEN)
			--select * from Checkroll.ReceptionTargeDetail where GangMasterID in (select RTD_GangMasterID from #PANEN)
			--select * from Checkroll.DailyReceiption where DailyReceiptionDetID in (select DR_DailyReceiptionDetID from #PANEN)
			--select * from Checkroll.DailyAttendance where DailyReceiptionID in (select DA_DailyReceiptionID from #PANEN)
			--select * from Checkroll.DailyTeamActivity where DailyTeamActivityID in (select DTA_DailyTeamActivityId from #PANEN)
		END
		ELSE-- Deletion for #LAIN activity
			BEGIN
			    DECLARE @Lain TABLE
						(DTA_DailyTeamActivityID varchar(50),
						 DA_DailyReceiptionId varchar(50),
						 DAD_DailyDistributionID varchar(50),
						 AMU_DailyDistributionID varchar(50),
						DAD_GangMasterID VARCHAR(50) )
						BEGIN
							INSERT INTO @Lain
							SELECT  a.DailyTeamActivityID as DTA_DailyTeamActivityID, 
							        b.DailyReceiptionID as DA_DailyReceiptionID,
							        c.DailyDistributionID as DAD_DailyDistributionID,
							        d.DailyDistributionID  as AMU_DailyDistributionID,
							       a.GangMasterID AS DAD_GangMasterID 
						    FROM Checkroll.DailyTeamActivity a 
							left join Checkroll.DailyAttendance b on b.DailyTeamActivityID=a.DailyTeamActivityID
							left join Checkroll.DailyActivityDistribution c on c.GangMasterID =a.GangMasterID --change the relation from DailyReceptionid to GangMasterid.
							left join Checkroll.ActivityMaterialUsage d on d.DailyDistributionID=c.DailyDistributionID
							WHERE a.DailyTeamActivityID=@DailyTeamActivityID AND a.DDate=@DDate
					    END
			END
			
			
			DELETE from Checkroll.ActivityMaterialUsage where DailyDistributionID in (select AMU_DailyDistributionID from @Lain) 
			DELETE from Checkroll.DailyActivityDistribution where GangMasterID in (select DAD_GangMasterID from @Lain) AND DistbDate=@DDate
			DELETE from Checkroll.DailyTeamActivity where DailyTeamActivityID in (select DTA_DailyTeamActivityID from @Lain)
			DELETE from Checkroll.DailyAttendance where DailyReceiptionID in (select DA_DailyReceiptionId from @Lain) AND RDate=@DDate
			Delete from Checkroll.DailyGangEmployeeSetup where DailyTeamActivityID in (Select DTA_DailyTeamActivityId from @Panen)

			SET @OutputReturn=0
			--SELECT * FROM @Lain 
			--select * from Checkroll.ActivityMaterialUsage where DailyDistributionID in (select AMU_DailyDistributionID from @Lain) 
			--select * from Checkroll.DailyActivityDistribution where GangMasterID in (select DAD_GangMasterID from @Lain) AND DistbDate=@DDate
			--select * from Checkroll.DailyTeamActivity where DailyTeamActivityID in (select DTA_DailyTeamActivityID from @Lain)
			--select * from Checkroll.DailyAttendance where DailyReceiptionID in (select DA_DailyReceiptionId from @Lain) AND RDate=@DDate
			
				
		BEGIN -- for Attendance Summary
			Delete from Checkroll.AttendanceSummary where DailyTeamActivityID=@DailyTeamActivityID
		END
		
	 --   IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#PANEN'))
		--BEGIN
		--	DROP TABLE #PANEN
		--END
		--IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#LAIN'))
		--BEGIN
		--	DROP TABLE #LAIN
		--END
		
		
	SET @OutputType = @OutputReturn 
	RETURN @OutputType	
END
