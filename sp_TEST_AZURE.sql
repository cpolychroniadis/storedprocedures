USE [RFID_STW]
GO
/****** Object:  StoredProcedure [dbo].[sp_TEST]    Script Date: 5/18/2022 10:33:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_TEST]
	@aisle varchar(10), 
	@basket varchar(10),
	@dtlocal datetime,
	@dtin datetime,
	@tagId varchar(50)
AS
BEGIN
   
    DECLARE @URL NVARCHAR(MAX) = 'https://prod-16.centralus.logic.azure.com:443/workflows/e9177d5df98042b8813cbe0f607d51fa/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2';
	DECLARE @Object AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);
	DECLARE @Body AS VARCHAR(8000) =
		'{ 
		  "line": "' + @aisle + '",
		  "basket" : "' + @basket + '",
		  "dt": "local:' + CONVERT(varchar,@dtlocal,131) + ' pacific:' +  CONVERT(varchar,@dtin,131) + '",
		  "tag": "' + @tagId + '"
		}'; 

	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, 'post',
					 @URL,
					 'false'
	EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
	EXEC sp_OAMethod @Object, 'send', null, @body
	EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

	IF CHARINDEX('false',(SELECT @ResponseText)) > 0
	BEGIN
		SELECT @ResponseText As 'Message'
	END

END

