
/****** Object:  StoredProcedure [Checkroll].[AttendSummaryWithTeamProcess]    Script Date: 6/7/2015 6:49:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [Checkroll].[AttendSummaryWithTeamProcess] '01R481', 'M1', '01', 'SuperAdmin'

ALTER PROCEDURE [Checkroll].[AttendSummaryWithTeamProcess]  
@ActiveMonthYearId nvarchar (50),  
@EstateId nvarchar (50),  
@EstateCode nvarchar(50),  
@User nvarchar (50)  
  
AS  
  
Declare @AttCode Nvarchar (50)  
Declare @TotalATT numeric (18,2)  
Declare @TotalMan numeric (18,2)  
Declare @pTotRow Numeric(18,0)   
Declare @AttendanceSummaryId nvarchar(50)  
Declare @count int  
Declare @EmpId nvarchar(50)
  
BEGIN   
  
BEGIN  
 UPDATE  Checkroll.AttendanceSummary   
 SET   
 
  [11]=0,[11M]=0,CT=0,CTM=0,CB=0,CBM=0,CH=0,CHM=0,CD=0,CDM=0,I0=0,I0M=0,I1=0,I1M=0,I2=0,I2M=0,  
  S0=0,S0M=0,S1=0,S1M=0,S2=0,S2M=0,S3=0,S3M=0,S4=0,S4M=0,SG=0,SGM=0,H1=0,H1M=0,L1=0,L1M=0,M1=0,  
  M1M=0,J1=0,J1M=0,[51]=0,[51M]=0,L0=0,L0M=0,M0=0,M0M=0,  
  JL=0, JLM=0, AB=0,[56] = 0,TP3 =0 ,TP2 = 0,TP1 = 0 ,TP =0 ,
  MP = 0 , MT  = 0 , [52]  = 0 , [53]  = 0 , [54]  = 0 , [55]  = 0,
  [56M] = 0,TP3M =0 ,TP2M = 0,TP1M = 0 ,TPM =0 ,
  MPM = 0 , MTM  = 0 , [52M]  = 0 , [53M]  = 0 , [54M]  = 0 , [55M]  = 0, 
  ModifiedBy=@User ,  
  ModifiedOn=GETDATE()  
 WHERE   
  EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId   
 END  
  
 SET XACT_ABORT ON  
 DECLARE CR_DA CURSOR FOR   
  
 SELECT      
  Checkroll.DailyAttendance.EstateID,Checkroll.DailyAttendance.ActiveMonthYearID,  
  Checkroll.DailyAttendance.EmpID,Ltrim(Rtrim(Checkroll.AttendanceSetup.AttendanceCode )) as AttendanceCode,  
  ISNULL(COUNT(Checkroll.AttendanceSetup.AttendanceCode),0) AS TotalATT,ISNULL(SUM(Checkroll.AttendanceSetup.TimesBasic),0) AS TotalMan  
 FROM        
  Checkroll.DailyAttendance with (nolock) INNER JOIN  
  Checkroll.CREmployee  with (nolock) ON Checkroll.DailyAttendance.EmpID = Checkroll.CREmployee.EmpID INNER JOIN  
  Checkroll.AttendanceSetup  with (nolock) ON Checkroll.DailyAttendance.AttendanceSetupID = Checkroll.AttendanceSetup.AttendanceSetupID  
 WHERE        
  Checkroll.DailyAttendance.EmpID IS NOT NULL   
  AND Checkroll.DailyAttendance.EstateID = @EstateId   
  AND Checkroll.DailyAttendance.ActiveMonthYearID =@ActiveMonthYearID  
  GROUP BY Checkroll.DailyAttendance.EstateID, Checkroll.DailyAttendance.ActiveMonthYearID,  
  Checkroll.DailyAttendance.EmpID,Ltrim(Rtrim(Checkroll.AttendanceSetup.AttendanceCode ))  
-- Add Daily Attendance Mandor
UNION
 SELECT      
  Checkroll.DailyAttendanceMandor.EstateID,Checkroll.DailyAttendanceMandor.ActiveMonthYearID,  
  Checkroll.DailyAttendanceMandor.EmpID,Ltrim(Rtrim(Checkroll.AttendanceSetup.AttendanceCode )) as AttendanceCode,  
  ISNULL(COUNT(Checkroll.AttendanceSetup.AttendanceCode),0) AS TotalATT,ISNULL(SUM(Checkroll.AttendanceSetup.TimesBasic),0) AS TotalMan  
 FROM        
  Checkroll.DailyAttendanceMandor with (nolock) INNER JOIN  
  Checkroll.CREmployee  with (nolock) ON Checkroll.DailyAttendanceMandor.EmpID = Checkroll.CREmployee.EmpID INNER JOIN  
  Checkroll.AttendanceSetup  with (nolock) ON Checkroll.DailyAttendanceMandor.AttendanceSetupID = Checkroll.AttendanceSetup.AttendanceSetupID  
 WHERE        
  Checkroll.DailyAttendanceMandor.EmpID IS NOT NULL   
  AND Checkroll.DailyAttendanceMandor.EstateID = @EstateId  
  AND Checkroll.DailyAttendanceMandor.ActiveMonthYearID = @ActiveMonthYearID 
  GROUP BY Checkroll.DailyAttendanceMandor.EstateID, Checkroll.DailyAttendanceMandor.ActiveMonthYearID,  
  Checkroll.DailyAttendanceMandor.EmpID,Ltrim(Rtrim(Checkroll.AttendanceSetup.AttendanceCode ))    
  
  
 Open CR_DA  
  
 FETCH NEXT FROM CR_DA  
 INTO @EstateId, @ActiveMonthYearId, @EmpId, @Attcode, @TotalATT, @TotalMan  
    
 SELECT  @pTotRow = @@CURSOR_ROWS  
 WHILE @@FETCH_STATUS = 0   
 BEGIN  
    
    
  IF NOT EXISTS(  
   SELECT EmpID from Checkroll.AttendanceSummary   
   WHERE   
    EstateID = @EstateId AND ActiveMonthYearID  =@ActiveMonthYearId AND  EmpID = @EmpID )  
  
    
   BEGIN  
    SELECT @count = (ISNULL(MAX(Id),0) + 1) FROM Checkroll.AttendanceSummary ;  
    SET @AttendanceSummaryId  = @EstateCode+'R'+ CONVERT(NVARCHAR,@count);  
    
   IF @AttCode ='11'  
     
    BEGIN  
     INSERT INTO Checkroll.AttendanceSummary  
     (  
     AttendanceSummaryID,   
     EstateID,   
     ActiveMonthYearId ,  
     EmpID,  
     [11],[11M],  
     CreatedBy,CreatedOn,ModifiedBy,ModifiedOn      
     )  
     values (  
     @AttendanceSummaryId,   
     @EstateId,   
     @ActiveMonthYearId,  
     @EmpID,  
     @TotalATT,@TotalMan,   
     @User,GetDate(),@User,GetDate()   
     )  
    END  
     
   IF @AttCode ='CT'  
    BEGIN  
     INSERT INTO Checkroll.AttendanceSummary(  
     AttendanceSummaryID,   
     EstateID,   
     ActiveMonthYearId ,  
     EmpID,  
     CT,CTM,  
     CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
     )  
     values (  
     @AttendanceSummaryId,   
     @EstateId,   
     @ActiveMonthYearId,  
     @EmpID,  
     @TotalATT,@TotalMan,   
     @User,GetDate(),@User,GetDate()   
     )  
    END  
     
   IF @AttCode ='CB'  
    
    BEGIN  
     INSERT INTO Checkroll.AttendanceSummary(  
     AttendanceSummaryID,   
     EstateID,   
     ActiveMonthYearId ,  
     EmpID,  
     CB,CBM,  
     CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
     )  
     values (  
     @AttendanceSummaryId,   
     @EstateId,   
     @ActiveMonthYearId,  
     @EmpID,  
     @TotalATT,@TotalMan,   
     @User,GetDate(),@User,GetDate()   
     )  
    END  
     
   IF @AttCode ='CH'  
    
    BEGIN  
    INSERT INTO Checkroll.AttendanceSummary(  
    AttendanceSummaryID,   
    EstateID,   
    ActiveMonthYearId ,  
    EmpID,  
    CH,CHM,  
    CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
    )  
    values (  
    @AttendanceSummaryId,   
    @EstateId,   
    @ActiveMonthYearId,  
    @EmpID,  
    @TotalATT,@TotalMan,   
    @User,GetDate(),@User,GetDate()   
    )  
    END  
     
   IF @AttCode ='CD'  
    
    BEGIN  
    INSERT INTO Checkroll.AttendanceSummary(  
    AttendanceSummaryID,   
    EstateID,   
    ActiveMonthYearId ,  
    EmpID,  
    CD,CDM,  
    CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
    )  
    values (  
    @AttendanceSummaryId,   
    @EstateId,   
    @ActiveMonthYearId,  
    @EmpID,  
    @TotalATT,@TotalMan,   
    @User,GetDate(),@User,GetDate()   
    )  
    END  
     
   IF @AttCode ='I0'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   I0,I0M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='I1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   I1,I1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='I2'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   I2,I2M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='S0'  
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   S0,S0M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='S1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   S1,S1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='S2'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   S2,S2M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='S3'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   S3,S3M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='S4'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   S4,S4M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='AB'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   AB,ABM,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='SG'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   SG,SGM,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='H1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   H1,H1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='L1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   L1,L1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='M1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   M1,M1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='J1'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   J1,J1M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='51'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   [51],[51M],  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='L0'  
    
   BEGIN  
   INSERT INTO Checkroll.AttendanceSummary(  
   AttendanceSummaryID,   
   EstateID,   
   ActiveMonthYearId ,  
   EmpID,  
   L0,L0M,  
   CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
   )  
   values (  
   @AttendanceSummaryId,   
   @EstateId,   
   @ActiveMonthYearId,  
   @EmpID,  
   @TotalATT,@TotalMan,   
   @User,GetDate(),@User,GetDate()   
   )  
   END  
     
   IF @AttCode ='M0'  
    
   BEGIN  
    INSERT INTO Checkroll.AttendanceSummary(  
    AttendanceSummaryID,   
    EstateID,   
    ActiveMonthYearId ,  
    EmpID,  
    M0,M0M,  
    CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
    )  
    values (  
    @AttendanceSummaryId,   
    @EstateId,   
    @ActiveMonthYearId,  
    @EmpID,  
    @TotalATT,@TotalMan,   
    @User,GetDate(),@User,GetDate()   
    )  
   END  


  
   -- Rabu, 18 Nov 2009, 23:46  
   -- Added by Dadang for JL & JLM  
   IF @AttCode ='JL'  
    
   BEGIN  
    INSERT INTO Checkroll.AttendanceSummary(  
    AttendanceSummaryID,   
    EstateID,   
    ActiveMonthYearId ,  
    EmpID,  
    JL, JLM,  
    CreatedBy,CreatedOn,ModifiedBy,ModifiedOn    
    )  
    values (  
    @AttendanceSummaryId,   
    @EstateId,   
    @ActiveMonthYearId,  
    @EmpID,  
    @TotalATT,@TotalMan,   
    @User,GetDate(),@User,GetDate()   
    )  
   END  
     
    END  
    
    ELSE  
       
    IF EXISTS(SELECT EmpID from Checkroll.AttendanceSummary   
  WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID )  
        
  BEGIN  
     
   IF @AttCode ='11'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
    [11]=@TotalATT,[11M]=@TotalMan,  
    ModifiedBy=@User ,  
    ModifiedOn=GETDATE()  
    WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='CT'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
    CT=@TotalATT,CTM=@TotalMan,  
    ModifiedBy=@User ,  
    ModifiedOn=GETDATE()  
    WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='CB'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   CB=@TotalATT,CBM=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='CH'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   CH=@TotalATT,CHM=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='CD'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   CD=@TotalATT,CDM=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='I0'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   I0=@TotalATT,I0M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='I1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   I1=@TotalATT,I1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='I2'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   I2=@TotalATT,I2M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='S0'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   S0=@TotalATT,S0M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='S1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   S1=@TotalATT,S1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='S2'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   S2=@TotalATT,S2M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='S3'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   S3=@TotalATT,S3M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='S4'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   S4=@TotalATT,S4M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
      
   IF @AttCode ='AB'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   AB=@TotalATT,ABM=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID   
   END  
     
     
   IF @AttCode ='SG'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   SG=@TotalATT,SGM=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END    
     
     
   IF @AttCode ='H1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   H1=@TotalATT,H1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
     
   IF @AttCode ='L1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   L1=@TotalATT,L1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
     
   IF @AttCode ='M1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   M1=@TotalATT,M1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
     
   IF @AttCode ='J1'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   J1=@TotalATT,J1M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='51'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   [51]=@TotalATT,[51M]=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='L0'  
   BEGIN  
   UPDATE  Checkroll.AttendanceSummary   
   SET   
   L0=@TotalATT,L0M=@TotalMan,  
   ModifiedBy=@User ,  
   ModifiedOn=GETDATE()  
   WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   IF @AttCode ='M0'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
    M0=@TotalATT,M0M=@TotalMan,  
    ModifiedBy=@User ,  
    ModifiedOn=GETDATE()  
    WHERE EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
     
   -- Rabu, 18 Nov 2009, 23:46  
   -- Added by Dadang for JL & JLM  
   IF @AttCode ='JL'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     JL= @TotalATT,  
     JLM=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END  
   
    IF @AttCode ='52'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     [52]= @TotalATT,  
     [52M]=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END
	
	IF @AttCode ='53'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     [53]= @TotalATT,  
     [53M]=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END


       IF @AttCode ='54'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     [54]= @TotalATT,  
     [54M]=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END

       IF @AttCode ='55'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     [55]= @TotalATT,  
     [55M]=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END


          IF @AttCode ='TP'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     TP= @TotalATT,  
     TPM=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END


          IF @AttCode ='TP1'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     TP1= @TotalATT,  
     TP1M=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END


          IF @AttCode ='TP2'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     TP2= @TotalATT,  
     TP2M=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END


          IF @AttCode ='TP3'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     TP3= @TotalATT,  
     TP3M=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END

             IF @AttCode ='MP'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     MP= @TotalATT,  
     MPM=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END

   
             IF @AttCode ='MT'  
   BEGIN  
    UPDATE  Checkroll.AttendanceSummary   
    SET   
     MT= @TotalATT,  
     MTM=@TotalMan,  
     ModifiedBy=@User ,  
     ModifiedOn=GETDATE()  
    WHERE   
    EstateID = @EstateId AND ActiveMonthYearID =@ActiveMonthYearId AND  EmpID = @EmpID    
   END

  END -- IF EXIST  
          
   FETCH NEXT FROM CR_DA  
     INTO @EstateId,@ActiveMonthYearId,@EmpID, @Attcode,@TotalATT,@TotalMan  
         
 END  
    
 CLOSE CR_DA  
 DEALLOCATE CR_DA  
    
--SELECT    TOP 100 PERCENT Checkroll.DailyAttendance.ActiveMonthYearID, Checkroll.DailyAttendance.EstateID,   
--          Checkroll.DailyAttendance.EmpID,   
--          SUM(Checkroll.AttendanceSetup.TimesBasic) AS TotalATT  
--FROM      Checkroll.DailyAttendance INNER JOIN  
--          Checkroll.CREmployee ON Checkroll.DailyAttendance.EmpID = Checkroll.CREmployee.EmpID FULL OUTER JOIN  
--          Checkroll.AttendanceSetup ON Checkroll.DailyAttendance.AttendanceSetupID = Checkroll.AttendanceSetup.AttendanceSetupID  
--WHERE     (Checkroll.DailyAttendance.EmpID IS NOT NULL) and Checkroll.DailyAttendance.EstateID = @EstateId and Checkroll.DailyAttendance.ActiveMonthYearID =@ActiveMonthYearID  
--GROUP BY  Checkroll.DailyAttendance.EstateID, Checkroll.DailyAttendance.ActiveMonthYearID,  
--    Checkroll.DailyAttendance.EmpID, Checkroll.CREmployee.EmpName, Checkroll.AttendanceSetup.AttendanceCode  
    
     
END
