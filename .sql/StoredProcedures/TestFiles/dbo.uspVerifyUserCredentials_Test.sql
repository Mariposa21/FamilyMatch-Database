/*
	Mariposa21
	dbo.uspVerifyUserCredentials test
*/
USE [FamilyMatch]

GO

DECLARE @vcUserEmail varchar(250) = 'test2@email.com', 
		@vcPassword varchar(100) =  'Password1', 
		@bRemoveUser bit = 0, 
		@iUserID int = 0, 
		@iUserRoleID tinyint = 0,
		@bPasswordExpired bit, 
		@vcErrorMessage varchar(4000)

EXEC dbo.uspVerifyUserCredentials
	@vcUserEmail = @vcUserEmail, 
	@vcPassword = @vcPassword, 
	@iUserID = @iUserID OUTPUT, 
	@iUserRoleID = @iUserRoleID OUTPUT, 
	@bPasswordExpired = @bPasswordExpired OUTPUT, 
	@vcErrorMessage = @vcErrorMessage OUTPUT
	
SELECT @iUserID
SELECT @iUserRoleID
SELECT @vcErrorMessage




