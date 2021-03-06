
/****** Object:  StoredProcedure [Store].[InternalTransferNoteReportGet]    Script Date: 4/3/2015 11:38:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- ==================================================
-- Created By : Babu Kumarasamy
-- Modified By: ANNAL
-- Created date: 27th JAN 2010
-- Last Modified Date:14 OCT 2010
-- Module     : Store
-- Screen(s)  : 
-- Description: 
-- ==================================================
ALTER PROCEDURE [Store].[InternalTransferNoteReportGet]
                @EstateID          NVARCHAR(50),
                @ActiveMonthYearID NVARCHAR(50),
                @InOrOut VARCHAR(10),
                @STInternalTransferInID nvarchar(50),
                @STInternalTransferOutID nvarchar(50)
AS
  BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET nocount  ON;
    
    -- Insert statements for procedure here
    
    IF @InOrOut = 'IN'
    BEGIN
    
    SELECT distinct 
		   COA.COACode           AS [Account Code],
           SITI.ItnInNo          AS [ITN No],
           SITI.[ITNDate]        AS Tanggal,
           STM.StockCode         AS [Store Code],
           GDS.DistributionDescp AS [Sender Location],
           GE.EstateName		 AS [Receiver Location], 
           
           STM.StockDesc         AS [Description],
           --SITDI.AvailQty          AS QTY,-- commented by arul
           SITDI.TransferInQty   AS QTY,
           SITDI.[UnitPrice]     AS [Unit Price],
           SITDI.[TransferInValue] AS [Amount],
           SITI.Remarks
    FROM   [Store].[STInternalTransferIn] SITI
           INNER JOIN [General].[GeneralDistributionSetup] GDS
             ON SITI.[SendersLocationID] = GDS.[DistributionSetupID]
           INNER JOIN [Store].[STInternalTransferInDetails] SITDI
             ON SITDI.[STInternalTransferInID] = SITI.[STInternalTransferInID]
           --INNER JOIN [Accounts].[COA] AS COA ON COA.[COAID] = SITD.[COAID]
           LEFT JOIN [Accounts].[COA] AS COA
             ON COA.[COAID] = GDS.COAID
           LEFT JOIN [Store].[STMaster] AS STM
             ON STM.StockID = SITDI.StockID
           LEFT JOIN [General] .[Estate]  AS GE
			ON STM.EstateID  = GE.EstateID 
             
    WHERE  SITI.EstateID = @EstateID AND SITI.Status='APPROVED'
           AND SITI.ActiveMonthYearID = @ActiveMonthYearID
           AND SITI.STInternalTransferInID =@STInternalTransferInID
	END
	ELSE IF  @InOrOut = 'OUT'
	BEGIN
	    SELECT distinct
			COA.COACode              AS [Account Code],
           SITO.ItnOutNo            AS [ITN No],
           SITO.[ITNDate]           AS Tanggal,
           STM.StockCode            AS [Store Code],
            GE.EstateName		    AS [Sender Location],           
           GDS.DistributionDescp    AS [Receiver Location],
           STM.StockDesc            AS [Description],
           --SITDO.AvailQty           AS QTY,-- commented by arul
           SITDO.TransferOutQty     AS QTY,
           SITDO.[UnitPrice]        AS [Unit Price],
           SITDO.[TransferOutValue] AS [Amount],
           SITO.Remarks
    FROM   [Store].[STInternalTransferOut] SITO
           INNER JOIN [General].[GeneralDistributionSetup] GDS
             ON SITO.[ReceiverLocationID] = GDS.[DistributionSetupID]
           INNER JOIN [Store].[STInternalTransferOutDetails] SITDO
             ON SITDO.[STInternalTransferOutID] = SITO.[STInternalTransferOutID]
           LEFT JOIN [Accounts].[COA] AS COA
             ON COA.[COAID] = GDS.COAID
           LEFT JOIN [Store].[STMaster] AS STM
             ON STM.StockID = SITDO.StockID
             LEFT JOIN [Store].[StockDetail] AS STD
             ON STM.StockID = STD.StockID
              INNER JOIN [General] .[Estate]  AS GE
			ON STM.EstateID  = GE.EstateID 
    WHERE  SITDO.EstateID = @EstateID AND SITO.Status='APPROVED'
           AND SITDO.ActiveMonthYearID = @ActiveMonthYearID
           AND SITO.STInternalTransferOutID =@STInternalTransferOutID 
          END 
       ELSE IF @InOrOut = 'INALL'
    BEGIN
    
    SELECT distinct
			COA.COACode             AS [Account Code],
           SITI.ItnInNo            AS [ITN No],
           SITI.[ITNDate]          AS Tanggal,
           STM.StockCode          AS [Store Code],
           GDS.DistributionDescp   AS [Sender Location],
		   GE.EstateName		    AS [Receiver Location],
           STM.StockDesc           AS [Description],
           --SITDI.AvailQty          AS QTY,-- commented by arul
           SITDI.TransferInQty     AS QTY,
           SITDI.[UnitPrice]       AS [Unit Price],
           SITDI.[TransferInValue] AS [Amount],
           SITI.Remarks
    FROM   [Store].[STInternalTransferIn] SITI
           INNER JOIN [General].[GeneralDistributionSetup] GDS
             ON SITI.[SendersLocationID] = GDS.[DistributionSetupID]
           INNER JOIN [Store].[STInternalTransferInDetails] SITDI
             ON SITDI.[STInternalTransferInID] = SITI.[STInternalTransferInID]
           --INNER JOIN [Accounts].[COA] AS COA ON COA.[COAID] = SITD.[COAID]
           LEFT JOIN [Accounts].[COA] AS COA
             ON COA.[COAID] = GDS.COAID
           LEFT JOIN [Store].[STMaster] AS STM
             ON STM.StockID = SITDI.StockID
               LEFT JOIN [General] .[Estate]  AS GE
			ON STM.EstateID  = GE.EstateID 
    WHERE  SITI.EstateID = @EstateID AND SITI.Status='APPROVED'
           AND SITI.ActiveMonthYearID = @ActiveMonthYearID
           
	END
	ELSE IF  @InOrOut = 'OUTALL'
	BEGIN
	    SELECT distinct
			COA.COACode              AS [Account Code],
           SITO.ItnOutNo            AS [ITN No],
           SITO.[ITNDate]           AS Tanggal,
           STM.StockCode            AS [Store Code],
          GE.EstateName				AS [Sender Location] ,           
           GDS.DistributionDescp    AS [Receiver Location],
           STM.StockDesc            AS [Description],
           --SITDO.AvailQty           AS QTY,-- commented by arul
           SITDO.TransferOutQty     AS QTY,
           SITDO.[UnitPrice]        AS [Unit Price],
           SITDO.[TransferOutValue] AS [Amount],
           SITO.Remarks
    FROM   [Store].[STInternalTransferOut] SITO
           INNER JOIN [General].[GeneralDistributionSetup] GDS
             ON SITO.[ReceiverLocationID] = GDS.[DistributionSetupID]
           INNER JOIN [Store].[STInternalTransferOutDetails] SITDO
             ON SITDO.[STInternalTransferOutID] = SITO.[STInternalTransferOutID]
           LEFT JOIN [Accounts].[COA] AS COA
             ON COA.[COAID] = GDS.COAID
           LEFT JOIN [Store].[STMaster] AS STM
             ON STM.StockID = SITDO.StockID
             LEFT JOIN [Store].[StockDetail] AS STD
             ON STM.StockID = STD.StockID
                LEFT JOIN [General] .[Estate]  AS GE
			ON STM.EstateID  = GE.EstateID 
    WHERE  SITDO.EstateID = @EstateID AND SITO.Status='APPROVED'
           AND SITDO.ActiveMonthYearID = @ActiveMonthYearID
	END           
  END










