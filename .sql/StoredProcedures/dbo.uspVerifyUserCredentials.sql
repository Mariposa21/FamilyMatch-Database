USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspVerifyUserCredentials
	Purpose: Verifies user credentials. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspVerifyUserCredentials
	@vcUserEmail varchar(250), 
	@vcPassword varchar(100), 
	@iUserID int = 0 OUTPUT, 
	@iUserRoleID tinyint OUTPUT, 
	@bPasswordExpired bit OUTPUT, 
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iRecordCount int; 
	DECLARE @dtUTC_CurrentTimestamp datetime = GETUTCDATE(); 
	DECLARE @dtPasswordUpdateDateTime datetime;
	DECLARE @iTotalPasswordChanges int;
	SET @bPasswordExpired = 0; 

	BEGIN TRY 
		SELECT @iUserID = UV.UserID, @iUserRoleID = UV.UserRoleID, @dtPasswordUpdateDateTime = UV.MostRecentPasswordUpdateDatetime
		FROM dbo.tbUser_Versioned 
		FOR SYSTEM_TIME AS OF @dtUTC_CurrentTimestamp UV
		WHERE UV.UserEmail = @vcUserEmail 
		AND UV.UserPasswordHash = HASHBYTES('SHA2_512', @vcPassword + CAST(UV.UserSalt AS varchar(36)))
		AND UV.IsValidUser = 1; 
		SET @iRecordCount = @@ROWCOUNT; 

		IF (@iRecordCount <> 1)
		BEGIN 
			;THROW 50001, 'Error: Unable to verify user credentials.', 1
		END 

		--See if password has been changed after initial password creation. If not, it's going to need to be updated by the user. 
		SELECT @iTotalPasswordChanges = COUNT(DISTINCT UV.MostRecentPasswordUpdateDateTime)
		FROM dbo.tbUser_Versioned 
		FOR SYSTEM_TIME ALL UV
		WHERE UV.UserID = @iUserID; 

		PRINT(@iTotalPasswordChanges)

		IF (((DATEDIFF(DAY, CAST(@dtPasswordUpdateDateTime AS date), CAST(CURRENT_TIMESTAMP AS date))) > 90) OR (@iTotalPasswordChanges = 1))
		BEGIN 
			SET @bPasswordExpired = 1; 
			;THROW 50001, 'Password expired. Please update.', 1
		END

	END TRY 
	BEGIN CATCH 
			SELECT @vcErrorMessage = ERROR_MESSAGE(); 
            RETURN 1; 
	END CATCH; 

	RETURN 0; 

END 
GO
