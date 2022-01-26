/*
	Mariposa21
	dbo.uspCreateUserAccessLogEvent
*/
USE [FamilyMatch]

GO

DECLARE @iUserID int = 1, 
		@vcUserAccessType varchar(25) = 'Login', 
		@iAdoptiveResourceID int, --Leave null if not accessing an adoptive resource ID
		@iUserAccessLogID bigint, 
		@vcErrorMessage varchar(4000)

EXEC dbo.uspCreateUserAccessLogEvent
	@iUserID = @iUserID, 
	@vcUserAccessType = @vcUserAccessType,  
	@iAdoptiveResourceID = @iAdoptiveResourceID, 
	@iUserAccessLogID = @iUserAccessLogID OUTPUT, 
	@vcErrorMessage = @vcErrorMessage OUTPUT
	
SELECT @iUserAccessLogID
SELECT @vcErrorMessage

SELECT * 
FROM dbo.tbUserAccessLog UAL
WHERE UAL.UserAccessLogID = @iUserAccessLogID




