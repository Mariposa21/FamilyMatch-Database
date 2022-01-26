/*
	Mariposa21
	dbo.uspMaintainUser test
*/
USE [FamilyMatch]

GO

DECLARE @iUserID int = 0, 
		@iUserRoleID tinyint = 2, 
		@iAgencyID smallint = 1, 
		@vcUserLastName varchar(50) = 'S', 
		@vcUserFirstName varchar(50) = 'Megan', 
		@vcUserEmail varchar(250) = 'test2@email.com', 
		@vcPassword varchar(100) = 'Password1', 
		@bIsValidUser bit = 1, 
		@iRecordCreationUserID int = 0, 
		@iReturnedUserID int, 
		@vcErrorMessage varchar(4000) = NULL

EXEC dbo.uspMaintainUser
	@iUserID = @iUserID,
	@iUserRoleID = @iUserRoleID, 
	@iAgencyID = @iAgencyID, 
	@vcUserLastName = @vcUserLastName, 
	@vcUserFirstName = @vcUserFirstName, 
	@vcUserEmail = @vcUserEmail, 
	@vcPassword = @vcPassword, 
	@bIsValidUser = @bIsValidUser, 
	@iRecordCreationUserID = @iRecordCreationUserID, 
	@iReturnedUserID = @iReturnedUserID OUTPUT, 
	@vcErrorMessage = @vcErrorMessage OUTPUT
	
SELECT @iReturnedUserID
SELECT @vcErrorMessage

SELECT * 
FROM dbo.tbUser_Versioned
FOR SYSTEM_TIME ALL
WHERE UserID = @iReturnedUserID 



