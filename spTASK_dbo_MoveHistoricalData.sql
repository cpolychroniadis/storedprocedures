USE [RFID_STW]
GO
/****** Object:  StoredProcedure [dbo].[spSELECT_dbo_Configuration]    Script Date: 5/18/2022 2:45:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		CB993277
-- Create date: 05/18/2022
-- Description:	Move old transaction data to historical tables
-- =============================================================
CREATE PROCEDURE [dbo].[spTASK_dbo_MoveHistoricalData] 
	-- Add the parameters for the stored procedure here
	@_tableId as smallint
AS
DECLARE
   
	@_cur_readerId nchar(17),
	@_cur_antennaId smallint,
	@_cur_rssi smallint,
	@_cur_tagid varchar(50),
	@_cur_ikey varchar(10),
	@_cur_icut varchar(10),
	@_cur_dtin datetime,
	@_cur_tagEvent varchar(100),
	@_cur_fexEvent varchar(10),
	@_cur_sc bigint,
	@_cur_dtout datetime,
	@_cur_status int,
	@_cur_dtdb datetime,
	@_cur_basket varchar(10), 
	@_cur_aisle varchar(10),
	@_cur_tg1 bit,
	@_cur_tg2 bit,
	@_cur_comment varchar(200)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

			if @_tableId = 1 
			  BEGIN
			    INSERT INTO [dbo].[sreading_hist]
				-- Insert statements for procedure here
				SELECT [readerId]
					  ,[antennaId]
					  ,[rssi]
					  ,[tagId]
					  ,[ikey]
					  ,[icut]
					  ,[dtin]
					  ,[tagEvent]
					  ,[fexEvent]
					  ,[sc]
					  ,[dtout]
					  ,[syncStatus]
					  ,[dtdb]
					  ,[basket]
					  ,[aisle]
					  ,[tg1]
					  ,[tg2]
					  ,[comment]
				  FROM [dbo].[sreading]
				  WHERE [dtin] <= DATEADD(day,-60,getdate())

				  DELETE [dbo].[sreading]
				  WHERE [dtin] <= DATEADD(day,-60,getdate())
				     
			END

	
END
