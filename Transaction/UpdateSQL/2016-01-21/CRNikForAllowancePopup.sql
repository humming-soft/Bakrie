
/****** Object:  StoredProcedure [Checkroll].[CRDailyAttendanceNikSelectNoTeam]    Script Date: 21/1/2016 4:02:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Checkroll].[CRNikForAllowanceDeduction]
@EmpCode nvarchar(50),
@EmpName nvarchar (50),
@EstateID nvarchar(50),
@Status nvarchar (50),
@Mandor nvarchar (50),
@AttDate Date




AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

IF @EmpCode = ''  and @EmpName=''  and @Mandor = ''
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK], Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
          Checkroll.CREmployee.RestDay, '' as GangEmployeeID
FROM      Checkroll.CREmployee FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
                       
WHERE  CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))

ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
			
END
		
IF @EmpCode <> ''  and @EmpName='' and @Mandor <> '' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
          Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE  (EmpCode LIKE  '%'+ @empcode	+ '%') and  CREmployee.EmpJobDescriptionId =@Mandor 
and CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END

IF @EmpCode <> ''  and @EmpName='' and @Mandor = '' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
          Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE  (EmpCode LIKE  '%'+ @empcode	+ '%') and CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END
		
IF @EmpCode = ''  and @EmpName <>'' and @Mandor <>'' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
          Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee  FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE (EmpName LIKE  '%'+ @EmpName	+ '%') and  CREmployee.EmpJobDescriptionId =@Mandor
 and CREmployee.EstateID =@EstateID AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END



IF @EmpCode  <>''  and @EmpName ='' and @Mandor <>'' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
           Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE (EmpCode LIKE  '%'+ @EmpCode	+ '%') and  Mandor =@Mandor 
 and CREmployee.EstateID =@EstateID AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END


IF @EmpCode <> ''  and @EmpName <>'' and @Mandor ='' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
          Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee  FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE  (EmpCode LIKE  '%'+ @empcode	+ '%') and  (EmpName LIKE  '%'+ @EmpName	+ '%') 
and CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END

IF @EmpCode = ''  and @EmpName ='' and @Mandor <>'' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
           Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee  FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE CREmployee.EmpJobDescriptionId =@Mandor  and CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
END

IF @EmpCode <> ''  and @EmpName <>'' and @Mandor <>'' 
BEGIN
SELECT    DISTINCT Checkroll.CREmployee.EmpCode AS NIK, Checkroll.CREmployee.AccountNo AS [Old NIK],Checkroll.CREmployee.EmpName AS Name, Checkroll.CREmployee.EmpID AS [Employee ID], 
          Checkroll.CREmployee.TransferLocation AS [Transfer Location], Checkroll.CREmployee.Category, Checkroll.RateSetup.BasicRate AS [Basic Rate], 
          Checkroll.RateSetup.OTDivider, Checkroll.CREmployee.Mandor, Checkroll.CREmployee.Krani, Checkroll.CREmployee.Status, 
           Checkroll.CREmployee.RestDay
FROM      Checkroll.CREmployee FULL OUTER JOIN
          Checkroll.RateSetup ON Checkroll.CREmployee.Category = Checkroll.RateSetup.Category
WHERE EmpCode LIKE  '%'+ @empcode	+ '%' and EmpName LIKE  '%'+ @EmpName	+ '%' and  CREmployee.EmpJobDescriptionId =@Mandor 
 and CREmployee.EstateID =@EstateID 
AND ( CREmployee .DOJ < = @AttDate ) 
 AND ((case when CREmployee.StatusDate IS NOT NULL then 1  end =1 AND CREmployee.StatusDate >  @AttDate    )
 or (case when CREmployee.StatusDate IS NULL then 1 end= 1 AND CREmployee.Status= 'Active' ))
ORDER BY Checkroll.CREmployee.Category ,Checkroll.CREmployee.EmpName
			
END
	
END

		
	

















