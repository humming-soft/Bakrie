
/****** Object:  StoredProcedure [Checkroll].[CRTHRInsert]    Script Date: 19/1/2016 9:03:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Checkroll].[CRBonusInsertOther]
 @EstateID nvarchar(50),
 @ActiveMonthYearID nvarchar(50),
 @ProcDate datetime,
 @User nvarchar(50),
@Zmonth as int, 
@ZYear as int
AS

DECLARE @EstateCode nvarchar(50);
DECLARE @EmpID nvarchar(50);
DECLARE @YearPeriod int;
DECLARE @count int;
DECLARE @THRID nvarchar(50);
DECLARE @Bruto numeric(18,2);
DECLARE @BasicRate numeric(18,2);
DECLARE @MaritalStatus nvarchar(5)
DECLARE @Netto numeric(18,2);
DECLARE @RoundUP numeric(18,2);
DECLARE @MasaKerjaDlmTahun int;
DECLARE @DedIncomeTax numeric(18,2);
DECLARE @DedSPSI numeric(18,2);
DECLARE @DedSBSP numeric(18,2);
DECLARE @BerasNatura numeric(18,2);
DECLARE @PreviousActiveMonthYearID nvarchar(50);

SELECT @EstateCode = EstateCode
FROM
	General.Estate
WHERE
	EstateID = @EstateID

Set @YearPeriod = @ZYear		
Select @PreviousActiveMonthYearID =  ActivemonthYearID from General.ActiveMonthYear where ModID  =1 and AYear = @ZYear and AMonth = @Zmonth
		
DELETE FROM Checkroll.Bonus
WHERE
	EstateID = @EstateID
	AND ActiveMonthYearID = @ActiveMonthYearID;

DECLARE AttSum_Cursor CURSOR
FOR 
	SELECT C_AS.EmpID, C_EMP.MaritalStatus 
	FROM Checkroll.AttendanceSummary C_AS
	INNER JOIN Checkroll.CREmployee C_EMP ON C_EMP.EmpID = C_AS .EMPID
	WHERE
		C_AS.EstateID = @EstateID
		AND C_AS.ActiveMonthYearID = @ActiveMonthYearID
		AND C_EMp.Category <> 'KHL'
	Order by MaritalStatus

OPEN AttSum_Cursor

	FETCH NEXT FROM AttSum_Cursor
	INTO @EmpID, @MaritalStatus
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	Select @Bruto = Bruto,@DedIncomeTax=DedIncomeTax,@DedSPSI=DedCooper,@DedSBSP=DedOthers
	,@Netto=Netto,@RoundUP=RoundUP,@BerasNatura=BerasNatura from Bonus where EmpID = @EmpID and ActiveMonthYearID = @PreviousActiveMonthYearID 	

	IF @Bruto  > 0
	BEGIN
		IF EXISTS(
			SELECT EmpID
			FROM
				Checkroll.Bonus
			WHERE
				EstateID = @EstateID
				AND ActiveMonthYearID = @ActiveMonthYearID
				AND EmpID = @EmpID
		)
		BEGIN		
			UPDATE Checkroll.Bonus SET
				YearPeriod = @YearPeriod
				,Bruto = @Bruto
				,DedIncomeTax = @DedIncomeTax
				,DedCooper = @DedSPSI
				,DedOthers = @DedSBSP
				,Netto = @Netto
				,RoundUP = @RoundUP
				,BerasNatura = @BerasNatura
				--,DagingNatura = @DagingNatura
				--,
			WHERE
				EstateID = @EstateID
				AND ActiveMonthYearID = @ActiveMonthYearID
				AND CONVERT(DATE, ProcessingDate) = @ProcDate
				AND EmpID = @EmpID
				
		END
		ELSE -- Jika Belum Ada record
			BEGIN
			SELECT @THRID  = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + 1) AS VARCHAR)
                FROM   Checkroll.Bonus
                DECLARE @i INT = 2
                WHILE EXISTS
                (SELECT id
                FROM    Checkroll.Bonus
                WHERE   BonusID  = @THRID
                )
                BEGIN
                        SELECT @THRID = @EstateCode + 'R' + CAST ( (ISNULL(MAX(id),0) + @i) AS VARCHAR)
                        FROM   Checkroll.Bonus
                        SET @i = @i + 1
                END
                
                
			INSERT INTO Checkroll.Bonus
			(
			BonusID,
			EstateID,
			ActiveMonthYearID,
			EmpID,
			ProcessingDate,
			YearPeriod,
			Bruto,
			DedIncomeTax,
			DedCooper,
			DedOthers,
			Netto,
			RoundUP,
			CreatedBy,
			CreatedOn,
			ModifiedBy,
			ModifiedOn,
			--DagingNatura,
			BerasNatura
			)
			VALUES
			(
			@THRID,
			@EstateID,
			@ActiveMonthYearID,
			@EmpID,
			@ProcDate,
			@YearPeriod,
			@Bruto,
			@DedIncomeTax,
			@DedSPSI,
			@DedSBSP,
			@Netto,
			@RoundUP,
			@User,
			GETDATE(),
			@User,
			GETDATE(),
			--@DagingNatura,
			@BerasNatura
			);
			END	
		END
			
		
		PRINT @EmpID
		FETCH NEXT FROM AttSum_Cursor
		INTO @EmpID,@MaritalStatus
	END

CLOSE AttSum_Cursor
DEALLOCATE AttSum_Cursor