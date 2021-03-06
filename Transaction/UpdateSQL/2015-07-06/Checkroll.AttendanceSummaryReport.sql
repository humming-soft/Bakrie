
/****** Object:  StoredProcedure [Checkroll].[AttendanceSumReport]    Script Date: 6/7/2015 6:45:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
--  
--==================================================  
Alter PROCEDURE [Checkroll].[AttendanceSumReport]  
  
 @EstateID nvarchar(50),  
 @ActiveMonthYearID nvarchar(50)  
   
AS  

SELECT       
   C_ATTDSUM.ActiveMonthYearID  
   , C_ATTDSUM.EstateID  
   , G_ESTATE.EstateName  
   , C_GM.GangName  
   , C_ATTDSUM.EmpID  
   , C_EMP.EmpCode  
   , C_EMP.EmpName  
   , C_EMP.Category  
   , C_ATTDSUM.[11]  
   , C_ATTDSUM.CT  
   , C_ATTDSUM.CB  
   , C_ATTDSUM.CH  
   , C_ATTDSUM.CD  
   , C_ATTDSUM.I0  
   , C_ATTDSUM.I1  
   , C_ATTDSUM.I2  
   , C_ATTDSUM.S0  
   , C_ATTDSUM.S1  
   , C_ATTDSUM.S2  
   , C_ATTDSUM.AB  
   , C_ATTDSUM.S3  
   , C_ATTDSUM.S4  
   , C_ATTDSUM.SG  
   , C_ATTDSUM.H1  
   , C_ATTDSUM.L1  
   , C_ATTDSUM.M1  
   , C_ATTDSUM.J1  
   , C_ATTDSUM.[51]  
   , C_ATTDSUM.L0  
   , C_ATTDSUM.M0  
   , C_ATTDSUM.JL  
    ,C_ATTDSUM.[56],
	C_ATTDSUM.TP3 ,	
	C_ATTDSUM.TP2 ,
	C_ATTDSUM.TP1 ,
	C_ATTDSUM.TP ,
	C_ATTDSUM.MP ,
	C_ATTDSUM.MT ,
	C_ATTDSUM.[52] ,
	C_ATTDSUM.[53] ,
	C_ATTDSUM.[54] ,
	C_ATTDSUM.[55] ,
	PercentDay =  
   (  
   (  
   SUM(ISNULL(C_ATTDSUM.[11] ,0)  
   + ISNULL(C_ATTDSUM.CT, 0)  
   + ISNULL(C_ATTDSUM.CB, 0)  
   + ISNULL(C_ATTDSUM.CH, 0)  
   + ISNULL(C_ATTDSUM.CD, 0)  
   + ISNULL(C_ATTDSUM.I0, 0)  
   + ISNULL(C_ATTDSUM.I1, 0)  
   + ISNULL(C_ATTDSUM.I2, 0)  
   + ISNULL(C_ATTDSUM.S0, 0)  
   + ISNULL(C_ATTDSUM.S1, 0)  
   + ISNULL(C_ATTDSUM.S2, 0)  
   + ISNULL(C_ATTDSUM.AB, 0)  
   + ISNULL(C_ATTDSUM.S3, 0)  
   + ISNULL(C_ATTDSUM.S4, 0)  
   + ISNULL(C_ATTDSUM.SG, 0)  
   + ISNULL(C_ATTDSUM.H1, 0)  
   + ISNULL(C_ATTDSUM.L1, 0)  
   + ISNULL(C_ATTDSUM.M1, 0)  
   + ISNULL(C_ATTDSUM.J1, 0)  
   + ISNULL(C_ATTDSUM.[51], 0)  
   + ISNULL(C_ATTDSUM.L0, 0)  
   + ISNULL(C_ATTDSUM.M0, 0)
   + ISNULL(C_ATTDSUM.[56], 0)  
   + ISNULL(C_ATTDSUM.TP3, 0)  
   + ISNULL(C_ATTDSUM.TP2, 0)  
   + ISNULL(C_ATTDSUM.TP1, 0)  
   + ISNULL(C_ATTDSUM.TP, 0)  
   + ISNULL(C_ATTDSUM.MP, 0)  
   + ISNULL(C_ATTDSUM.MT, 0)  
   + ISNULL(C_ATTDSUM.[52], 0)  
   + ISNULL(C_ATTDSUM.[53], 0)  
   + ISNULL(C_ATTDSUM.[54], 0)  
   + ISNULL(C_ATTDSUM.[55], 0)  
   )   
   - SUM( ISNULL(C_ATTDSUM.AB, 0) + ISNULL(C_ATTDSUM.I0, 0) + ISNULL(C_ATTDSUM.S0, 0) + ISNULL(C_ATTDSUM.JL, 0))  
   ) / (DATEDIFF(DAY, G_FY.FromDT, G_FY.ToDT) + 1)  
   ) * 100  
   ,JmlHari = DATEDIFF(DAY, G_FY.FromDT, G_FY.ToDT) + 1  
     
   , G_AMY.AMonth  
   , G_AMY.AYear  
FROM           
  Checkroll.AttendanceSummary AS C_ATTDSUM   
  INNER JOIN Checkroll.CREmployee AS C_EMP ON C_ATTDSUM.EmpID = C_EMP.EmpID   
  INNER JOIN General.Estate AS G_ESTATE ON C_ATTDSUM.EstateID = G_ESTATE.EstateID   
  INNER JOIN General.ActiveMonthYear G_AMY ON C_ATTDSUM.ActiveMonthYearID = G_AMY.ActiveMonthYearID  
  INNER JOIN General.FiscalYear AS G_FY ON G_AMY.AMonth = G_FY.Period AND G_AMY.AYear = G_FY.FYear  	
-- 22-07-2011  LEFT JOIN Checkroll.GangEmployeeSetup AS C_GES ON C_ATTDSUM.EmpID = C_GES.EmpID  
-- 22-07-2011  LEFT JOIN Checkroll.GangMaster AS C_GM ON C_GES.GangMasterID = C_GM.GangMasterID  
-- 22-07-2011
  INNER JOIN Checkroll.Salary as C_SAL on C_SAL.ActiveMonthYearID =@ActiveMonthYearID and C_EMP.EmpID = C_SAL.EmpID  
  LEFT JOIN Checkroll.GangMaster AS C_GM ON C_SAL.GangMasterID = C_GM.GangMasterID  
-- 22-07-2011 
    
  where C_ATTDSUM.EstateID = @EstateID   
   AND C_ATTDSUM.ActiveMonthYearID = @ActiveMonthYearID  
   
    
GROUP BY  
  C_ATTDSUM.ActiveMonthYearID  
  ,C_ATTDSUM.EstateID  
  ,G_ESTATE.EstateName  
  ,C_GM.GangName  
  ,C_ATTDSUM.EmpID  
  ,C_EMP.EmpCode  
  ,C_EMP.EmpName  
  ,C_EMP.Category  
  ,C_ATTDSUM.[11]  
  ,C_ATTDSUM.CT  
  ,C_ATTDSUM.CB  
  ,C_ATTDSUM.CH  
  ,C_ATTDSUM.CD  
  ,C_ATTDSUM.I0  
  ,C_ATTDSUM.I1  
  ,C_ATTDSUM.I2  
  ,C_ATTDSUM.S0  
  ,C_ATTDSUM.S1  
  ,C_ATTDSUM.S2  
  ,C_ATTDSUM.AB  
  ,C_ATTDSUM.S3  
  ,C_ATTDSUM.S4  
  ,C_ATTDSUM.SG  
  ,C_ATTDSUM.H1  
  ,C_ATTDSUM.L1  
  ,C_ATTDSUM.M1  
  ,C_ATTDSUM.J1  
  ,C_ATTDSUM.[51]  
  ,C_ATTDSUM.L0  
  ,C_ATTDSUM.M0  
  ,C_ATTDSUM.JL  
  ,C_ATTDSUM.[56],
	C_ATTDSUM.TP3 ,	
	C_ATTDSUM.TP2 ,
	C_ATTDSUM.TP1 ,
	C_ATTDSUM.TP ,
	C_ATTDSUM.MP ,
	C_ATTDSUM.MT ,
	C_ATTDSUM.[52] ,
	C_ATTDSUM.[53] ,
	C_ATTDSUM.[54] ,
	C_ATTDSUM.[55]  
  ,G_AMY.AMonth  
  ,G_AMY.AYear  
  ,G_FY.FromDT  
  ,G_FY.ToDT
