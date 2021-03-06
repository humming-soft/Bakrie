
/****** Object:  StoredProcedure [Accounts].[LedgerReport]    Script Date: 27/11/2015 3:21:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--======================================================          
-- Created By : Kumaravel        
-- Created date:  Jan 27 2010       
-- Modified By: Kumaravel ,SivaSubramanian    
-- Last Modified Date:June 17 2010 ,  June 22 2010        
-- Module     : Accounts     
-- Screen(s)  : Ledger Reports      
-- Description: To Select Record in Ledger All Module  & Journal Detail       
--======================================================  
ALTER PROCEDURE [Accounts].[LedgerReport]

 @EstateID nvarchar(50),
    @AYear int,
    @Amonth Int,
    @Modid int
  --  @LedgerType nvarchar(50)
    ,@sort nvarchar(50)='asc'
 
AS
 BEGIN TRY
 
 SET NOCOUNT ON;
 set arithabort on  -- SET THIS ALONE ON
 set concat_null_yields_null on
 set ansi_nulls on
 set cursor_close_on_commit off
 set ansi_null_dflt_on on
 set implicit_transactions off
 set ansi_padding on
 set ansi_warnings on
 set quoted_identifier on

 
 --BEGIN
 
              select
 		      Distinct 
 			  A_LAM.LedgerType,
 			  G_E .Abbrevation 
 			  from Accounts .LedgerAllModule A_LAM
 			  INNER Join General .Estate as G_E On G_E .EstateID = A_LAM .EstateID  		  
				where A_LAM.EstateID = @EstateID 
				 AND A_LAM.AMonth  =@Amonth
				 AND A_LAM.AYear =@Ayear 
				 AND A_LAM.ModID =@Modid 
				 
		 
 
 BEGIN 
     SELECT 
      A_LAM.LedgerType ,
     G_E .EstateCode as EstateCode,
    G_E .EstateName as EstateName,
    G_E .Abbrevation as Abbrevation,
    A_COA .COACode as AccountCode,
    A_COA .OldCOACode  as oldAccountCode,
    CONVERT(VARCHAR(10), A_LAM .LedgerDate  , 103) AS TransactionDate, 
    A_LAM .LedgerNo as TransactionReference,
    SUBSTRING ( A_JD .Descp , 1 , 50 ) as Description, 
    A_JD .DC as Deb,
    ISNULL( SUM( A_JD .Value),0) as BaseAmount,
    G_T0 .TValue as T0,
    G_T1 .TValue as T1,
    G_T2 .TValue as T2,
    G_T3 .TValue as T3,
    G_T4 .TValue as T4,
    CONVERT(VARCHAR(10),  G_FY.FromDT, 103) AS  FromDT,
    CONVERT(VARCHAR(10),  G_FY.ToDT, 103) AS ToDT ,
     SUBSTRING ( A_JD .Descp , 1 , 50 ) as Descp  
    --A_JD .CreatedOn 
    --A_JD .Id     
      from Accounts .LedgerAllModule A_LAM
      Inner Join Accounts .JournalDetail as A_JD On A_JD .LedgerID = A_LAM .LedgerID 
      LEFT Join Accounts .COA as A_COA On A_COA .COAID = A_JD .COAID 
      LEFT JOIN General.TAnalysis G_T0 ON A_JD.T0=G_T0.TAnalysisID
     LEFT JOIN General.TAnalysis G_T1 ON A_JD.T1=G_T1.TAnalysisID
     LEFT JOIN General.TAnalysis G_T2 ON A_JD.T2=G_T2.TAnalysisID
     LEFT JOIN General.TAnalysis G_T3 ON A_JD.T3=G_T3.TAnalysisID
     LEFT JOIN General.TAnalysis G_T4 ON A_JD.T4=G_T4.TAnalysisID
     INNER JOIN General .Estate as G_E ON G_E.EstateID =A_LAM .EstateID 
     INNER JOIN General .ActiveMonthYear As G_AMY ON G_AMY .AMonth  = A_LAM .AMonth AND G_AMY .AYear =A_LAM .AYear  and G_AMY.ModID=A_LAM.ModID and G_AMY.EstateID=A_LAM.EstateID 
     INNER JOIN General .FiscalYear as G_FY ON G_FY .FYear = G_AMY .AYear AND G_FY .Period =G_AMY .AMonth 
   WHERE 
   A_LAM.EstateID = @EstateID 
     AND A_LAM.AMonth  =@Amonth
     AND A_LAM.AYear =@Ayear 
     AND A_LAM.ModID =@Modid 
    AND 
    A_LAM .LedgerType in  (select
 		      Distinct 
 			  A_LAM.LedgerType
 			  from Accounts .LedgerAllModule A_LAM
 			LEFT Join General .Estate as G_E On G_E .EstateID = A_LAM .EstateID  		  
				where A_LAM.EstateID = @EstateID 
				 AND A_LAM.AMonth  =@Amonth
				 AND A_LAM.AYear =@Ayear 
				 AND A_LAM.ModID =@Modid
				)
	--   ORDER BY CASE WHEN @Modid ='2' AND @sort='desc' THEN (RANK() OVER (ORDER BY A_JD.JournalDetID,A_LAM .LedgerNo , A_JD.DC)) 
    --     ORDER BY CASE WHEN @Modid =2 AND @sort='asc' THEN (RANK() OVER (ORDER BY A_JD.ID)) 
    --ORDER BY CASE WHEN @Modid =2 AND @sort='asc' THEN (RANK() OVER (ORDER BY A_LAM.LedgerType,A_LAM.Ledgerid,A_JD.JournalDetID)) 
    --   WHEN @Modid <>2    THEN (RANK() OVER (ORDER BY A_LAM.LedgerType,A_LAM.Ledgerno, A_JD.DC DESC)) end
    --   asc
    GROUP BY  A_LAM.LedgerType ,
     G_E .EstateCode ,
    G_E .EstateName ,
    G_E .Abbrevation ,
    A_COA .COACode ,
    A_COA .OldCOACode,
     A_LAM .LedgerDate  , 
    A_LAM .LedgerNo ,
    A_JD .Descp ,
    A_JD .DC ,
    G_T0 .TValue ,
    G_T1 .TValue ,
    G_T2 .TValue ,
    G_T3 .TValue ,
    G_T4 .TValue ,
    G_FY.FromDT
    , G_FY.ToDT,
    A_JD .Descp  
    
    
    order by LedgerType 
    
   END
    
END TRY

BEGIN CATCH
 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

 RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
 
END CATCH;


