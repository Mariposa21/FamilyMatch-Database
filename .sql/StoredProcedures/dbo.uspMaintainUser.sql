USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainUser
	Purpose: Maintains application user credentials/information.

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainUser
	@iUserID int = 0, 
	@iUserRoleID tinyint, 
	@iAgencyID smallint, 
	@vcUserLastName varchar(50), 
	@vcUserFirstName varchar(50), 
	@vcUserEmail varchar(250), 
	@vcPassword varchar(100) = NULL, 
	@bIsValidUser bit, 
	@iRecordCreationUserID int, 
	@iReturnedUserID int OUTPUT, 
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 
	DECLARE @uSalt uniqueidentifier = NEWID(); 
	DECLARE @dtUTCCurrentTimestamp datetime = GETUTCDATE(); 
	DECLARE @dtCurrentTimestamp datetime = CURRENT_TIMESTAMP; 
	SET @iReturnedUserID = @iUserID; 

	BEGIN TRY
		IF (@iUserID = 0)
		BEGIN
		   IF EXISTS (SELECT 1
					  FROM dbo.tbUser_Versioned 
					  FOR SYSTEM_TIME AS OF @dtUTCCurrentTimestamp UV
					  WHERE UV.UserEmail = @vcUserEmail
					  AND UV.IsValidUser = 1)
		   BEGIN
			;THROW 50001, 'Error: Email is already in use by an active user.', 1
		   END

		   INSERT INTO dbo.tbUser_Versioned (UserRoleID, AgencyID, UserLastName, UserFirstName, 
										UserEmail, UserSalt, UserPasswordHash, MostRecentPasswordUpdateDateTime, IsValidUser, 
										RecordCreationUserID)
		   VALUES (@iUserRoleID, @iAgencyID, @vcUserLastName, @vcUserFirstName, 
				@vcUserEmail, @uSalt, HASHBYTES('SHA2_512', @vcPassword + CAST(@uSalt AS varchar(36))), @dtCurrentTimestamp, 1, 
				@iRecordCreationUserID); 
		   SELECT @iReturnedUserID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new system user.', 1
		   END
		END
		ELSE --Should be an update
		BEGIN 
		   IF EXISTS (SELECT 1
					  FROM dbo.tbUser_Versioned 
					  FOR SYSTEM_TIME AS OF @dtUTCCurrentTimestamp UV
					  WHERE UV.UserEmail = @vcUserEmail
					  AND UV.UserID <> @iUserID
					  AND UV.IsValidUser = 1)
		   BEGIN
			;THROW 50001, 'Error: Email is already in use by another active user.', 1
		   END

		   UPDATE UV
				SET UV.UserRoleID = @iUserRoleID, 
					UV.AgencyID = @iAgencyID, 
					UV.UserLastName = @vcUserLastName, 
					UV.UserFirstName = @vcUserFirstName, 
					UV.UserEmail = @vcUserEmail, 
					UV.UserSalt = CASE WHEN @vcPassword IS NULL THEN UV.UserSalt ELSE @uSalt END, 
					UV.UserPasswordHash = CASE WHEN @vcPassword IS NULL THEN UV.UserPasswordHash ELSE HASHBYTES('SHA2_512', @vcPassword + CAST(@uSalt AS varchar(36))) END,
					UV.MostRecentPasswordUpdateDateTime = CASE WHEN @vcPassword IS NOT NULL THEN @dtCurrentTimestamp ELSE UV.MostRecentPasswordUpdateDateTime END, 
					UV.IsValidUser = @bIsValidUser,
					UV.RecordCreationUserID = @iRecordCreationUserID
		   FROM dbo.tbUser_Versioned UV
		   WHERE UV.UserID = @iUserID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update existing system user.', 1
		   END

		END
	END TRY
	BEGIN CATCH 
		    SELECT @vcErrorMessage = ERROR_MESSAGE(); 
            RETURN 1; 
	END CATCH 

	RETURN 0

END
GO
