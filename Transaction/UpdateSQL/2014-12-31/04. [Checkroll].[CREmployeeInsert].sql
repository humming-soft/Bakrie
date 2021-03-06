GO
/****** Object:  StoredProcedure [Checkroll].[CREmployeeInsert]    Script Date: 31/12/2014 21:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- Batch submitted through debugger: SQLQuery3.sql|0|0|C:\Users\Ashok\AppData\Local\Temp\~vsB37E.sql
-- ====================================================
-- Created By : Nelson
-- Modified By: Siva Subramanian S
-- Created date: 15 Sep 2009
-- Last Modified Date: 22 Jun 2010
-- Module     :CheckRoll,Employee Master, RKPMS Web
-- Screen(s)  : EmployeeMaster.aspx
-- Description: Inserting details  of particular employee
-- =====================================================
ALTER PROCEDURE [Checkroll].[CREmployeeInsert]
-- Add the parameters for the stored procedure here
                                                     ( @EmployeeID nvarchar(50),
                                                     @EmpID nvarchar(50)output,
                                                     @EstateID nvarchar(50),
                                                     @EstateCode nvarchar(50),
                                                     @Category nvarchar(50) ,
                                                     @EmpCode nvarchar(50),
                                                     @EmpName nvarchar(80),
                                                     @EmpImage image ,
                                                     @HomeAdd1 nvarchar(80),
                                                     @FamilyName nvarchar(80),
                                                     @FamilyCardNo nvarchar(80),
                                                     @Insurance nvarchar(80),
                                                     @HomeTelMobileNo nvarchar(50),
                                                     @EthnicGroup nvarchar(50),
                                                     @WorkerType nvarchar(50),
                                                     @BankID nvarchar(50),
                                                     @AccountNo nvarchar(50),
                                                     @Position nvarchar(50),
                                                     @StationID nvarchar(50) ,
                                                     @Gender CHAR(1) ,
                                                     @DOB    DATETIME,
                                                     @KTP nvarchar(50) ,
                                                     @PassportNo nvarchar(50) ,
                                                     @JamsostekNo nvarchar(50) ,
                                                     @NPWP nvarchar(50),
                                                     @Religion nvarchar(50),
                                                     @MaritalStatus CHAR(3),
                                                     @NoOfChildrenforTax nvarchar(50) ,
                                                     @Mandor  CHAR(1),
                                                     @Krani   CHAR(1),
                                                     @RestDay CHAR(3),
                                                     @DOJ     DATETIME ,
                                                     @Status nvarchar(15),
                                                     @statusDate DATETIME,
                                                     @TransferLocation nvarchar(50),
                                                     @WifeEmpWithREA            CHAR(1),
                                                     @WifeNotStayinREA          CHAR(1),
                                                     @WifeStayinREAreceivesRice CHAR(1),
                                                     @FatherName nvarchar(80),
                                                     @FDobAndPlace nvarchar(100),
                                                     @FAddress nvarchar(200),
                                                     @FTribe nvarchar(80),
                                                     @FReligion nvarchar(80),
                                                     @MotherName nvarchar(80),
                                                     @MDobAndPlace nchar(10),
                                                     @MAddress nvarchar(200),
                                                     @MTribe nvarchar(80),
                                                     @MReligion nvarchar(80),
                                                     @HusbWifeName nvarchar(80),
                                                     @HWDOBAndPlace nvarchar(100),
                                                     @HWAddress nvarchar(200),
                                                     @HWIDNo nvarchar(80),
                                                     @HWMarriageCertNo nvarchar(80),
                                                     @HWFamilyCardNo nvarchar(80),
                                                     @HWEthnicGroup nvarchar(80),
                                                     @HWReligion nvarchar(80),
                                                     @Elementry nvarchar(100),
                                                     @Junior nvarchar(100) ,
                                                     @Senior nvarchar(100) ,
                                                     @Diploma nvarchar(100) ,
                                                     @Degree nvarchar(100),
                                                     --@ConcurrencyId rowversion output,
                                                     @CreatedBy nvarchar(50),
                                                     @CreatedOn DATETIME,
                                                     @ModifiedBy nvarchar(50),
                                                     @ModifiedOn DATETIME,
                                                     @MedClaimAllowanceLimit numeric(18,0),
                                                     @HaveNPWP nvarchar(100),
													 @JobDescription int,
													 @Grade nvarchar(100),
													 @Level nvarchar(100)
													 )
AS
        --If NOT @statusDate Between '1/1/1753' and '12/31/9999'
        --SET @statusDate= NULL
        -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
        -- SET NOCOUNT ON;
        BEGIN TRY
                -- Get New Primary key
                IF EXISTS
                ( SELECT *
                FROM    Checkroll.CREmployee
                WHERE   EstateID=@EstateID
                    AND
                        (
                                EmpCode = @EmpCode
                        )
                )
                BEGIN
                        SELECT 'Duplicate'
                END
                ELSE
                BEGIN
                        DECLARE @i INT = 2
                        SELECT @EmpID  = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
                        FROM   Checkroll.CREmployee
                        WHILE EXISTS
                        (SELECT id
                        FROM    Checkroll.CREmployee
                        WHERE   EmpID = @EmpID
                        )
                        BEGIN
                                SELECT @EmpID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
                                FROM   Checkroll.CREmployee
                                SET @i = @i + 1
                        END
                        -- Insert statements for procedure here
                        INSERT
                        INTO   Checkroll.CREmployee
                               (
                                      EmpID                    ,
                                      EstateID                 ,
                                      Category                 ,
                                      EmpCode                  ,
                                      EmpName                  ,
                                      EmpImage                 ,
                                      HomeAdd1                 ,
                                      FamilyName               ,
                                      FamilyCardNo             ,
                                      Insurance                ,
                                      HomeTelMobileNo          ,
                                      EthnicGroup              ,
                                      WorkerType               ,
                                      BankID                   ,
                                      AccountNo                ,
                                      Position                 ,
                                      StationID                ,
                                      Gender                   ,
                                      DOB                      ,
                                      KTP                      ,
                                      PassportNo               ,
                                      JamsostekNo              ,
                                      NPWP                     ,
                                      Religion                 ,
                                      MaritalStatus            ,
                                      NoOfChildrenforTax       ,
                                      Mandor                   ,
                                      Krani                    ,
                                      RestDay                  ,
                                      DOJ                      ,
                                      [Status]                 ,
                                      statusDate               ,
                                      TransferLocation         ,
                                      WifeEmpWithREA           ,
                                      WifeNotStayinREA         ,
                                      WifeStayinREAreceivesRice,
                                      FatherName               ,
                                      FDobAndPlace             ,
                                      FAddress                 ,
                                      FTribe                   ,
                                      FReligion                ,
                                      MotherName               ,
                                      MDobAndPlace             ,
                                      MAddress                 ,
                                      MTribe                   ,
                                      MReligion                ,
                                      HusbWifeName             ,
                                      HWDOBAndPlace            ,
                                      HWAddress                ,
                                      HWIDNo                   ,
                                      HWMarriageCertNo         ,
                                      HWFamilyCardNo           ,
                                      HWEthnicGroup            ,
                                      HWReligion               ,
                                      Elementry                ,
                                      Junior                   ,
                                      Senior                   ,
                                      Diploma                  ,
                                      Degree                   ,
                                      CreatedBy                ,
                                      CreatedOn                ,
                                      ModifiedBy               ,
                                      ModifiedOn               ,
                                      MedClaimAllowanceLimit   ,
                                      HaveNPWP					,
									  EmpJobDescriptionId,
									  Grade,
									  Level
                               )
                               VALUES
                               (
                                      @EmpID                    ,
                                      @EstateID                 ,
                                      @Category                 ,
                                      @EmpCode                  ,
                                      @EmpName                  ,
                                      @EmpImage                 ,
                                      @HomeAdd1                 ,
                                      @FamilyName               ,
                                      @FamilyCardNo             ,
                                      @Insurance                ,
                                      @HomeTelMobileNo          ,
                                      @EthnicGroup              ,
                                      @WorkerType               ,
                                      @BankID                   ,
                                      @AccountNo                ,
                                      @Position                 ,
                                      @StationID                ,
                                      @Gender                   ,
                                      @DOB                      ,
                                      @KTP                      ,
                                      @PassportNo               ,
                                      @JamsostekNo              ,
                                      @NPWP                     ,
                                      @Religion                 ,
                                      @MaritalStatus            ,
                                      @NoOfChildrenforTax       ,
                                      @Mandor                   ,
                                      @Krani                    ,
                                      @RestDay                  ,
                                      @DOJ                      ,
                                      @Status                   ,
                                      @statusDate               ,
                                      @TransferLocation         ,
                                      @WifeEmpWithREA           ,
                                      @WifeNotStayinREA         ,
                                      @WifeStayinREAreceivesRice,
                                      @FatherName               ,
                                      @FDobAndPlace             ,
                                      @FAddress                 ,
                                      @FTribe                   ,
                                      @FReligion                ,
                                      @MotherName               ,
                                      @MDobAndPlace             ,
                                      @MAddress                 ,
                                      @MTribe                   ,
                                      @MReligion                ,
                                      @HusbWifeName             ,
                                      @HWDOBAndPlace            ,
                                      @HWAddress                ,
                                      @HWIDNo                   ,
                                      @HWMarriageCertNo         ,
                                      @HWFamilyCardNo           ,
                                      @HWEthnicGroup            ,
                                      @HWReligion               ,
                                      @Elementry                ,
                                      @Junior                   ,
                                      @Senior                   ,
                                      @Diploma                  ,
                                      @Degree                   ,
                                      @CreatedBy                ,
                                      @CreatedOn                ,
                                      @ModifiedBy               ,
                                      @ModifiedOn               ,
                                      @MedClaimAllowanceLimit   ,
                                      @HaveNPWP,
									  @JobDescription,
									  @Grade,
									  @Level
                               );
                        
                        DECLARE @Id nvarchar(50)
                        SET @Id=
                        (SELECT MAX(id)
                        FROM    Checkroll.CREmployee
                        WHERE   EstateID=@EstateId
                        )
                        SET @EmployeeID=
                        (SELECT EmpId
                        FROM    Checkroll.CREmployee
                        WHERE   EstateID=@EstateId
                            AND Id      =@Id
                        )
                        SELECT @EmployeeID
                        RETURN SCOPE_IDENTITY();
                END
        END TRY
        BEGIN CATCH
                DECLARE @ErrorMessage NVARCHAR(4000);
                DECLARE @ErrorSeverity INT;
                DECLARE @ErrorState    INT;
                SELECT @ErrorMessage  = ERROR_MESSAGE() ,
                       @ErrorSeverity = ERROR_SEVERITY(),
                       @ErrorState    = ERROR_STATE();
                
                RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;




