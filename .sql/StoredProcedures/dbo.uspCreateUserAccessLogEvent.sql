USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspCreateUserAccessLogEvent
	Purpose: Logs a user event (ex: User login, viewing of homestudy)

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspCreateUserAccessLogEvent
	@iUserID int, 
	@vcUserAccessType varchar(25), 
	@iAdoptiveResourceID int = NULL, 
	@iUserAccessLogID bigint OUTPUT, 
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 
	DECLARE @dtCurrentTimestamp datetime = CURRENT_TIMESTAMP;
	DECLARE @iUserAccessTypeID tinyint = (SELECT UAT.UserAccessTypeID 
										  FROM dbo.stbUserAccessType UAT
										  WHERE UAT.UserAccessType = @vcUserAccessType); 

	BEGIN TRY
			
		   INSERT INTO dbo.tbUserAccessLog (UserID, UserAccessTypeID, AdoptiveResourceID, AccessActivityDateTime)
		   VALUES (@iUserID, @iUserAccessTypeID, @iAdoptiveResourceID, @dtCurrentTimestamp); 
		   SELECT @iUserAccessLogID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new user access log event.', 1
		   END

	END TRY
	BEGIN CATCH 
		    SELECT @vcErrorMessage = ERROR_MESSAGE(); 
            RETURN 1; 
	END CATCH 

	RETURN 0

END
GO
