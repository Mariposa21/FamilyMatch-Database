USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainAdoptiveResourcePlacementPreferences
	Purpose: Maintains Adoptive Resource's placement preference information (ex: racial background, legal risk)

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainAdoptiveResourcePlacementPreferences
	@iAdoptiveResourcePlacementPreferencesID int = 0, 
	@iAdoptiveResourceID int = 0, 
	@vcRacialBackground varchar(25), 
	@iMaxLegalRiskID tinyint, 
	@iMaxNeedsLevelID tinyint, 
	@vcGenders varchar(10), 
	@iMinAge tinyint, 
	@iMaxAge tinyint, 
	@iChildCapacityPlacementNum tinyint, 
	@iUserID int, 
	@iReturnedAdoptiveResourcePlacementPreferencesID int OUTPUT,
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 

	SET @iReturnedAdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID

	BEGIN TRY
		IF (@iAdoptiveResourcePlacementPreferencesID = 0)
		BEGIN
		   INSERT INTO dbo.tbAdoptiveResourcePlacementPreferences_Versioned (RacialBackground, MaxLegalRiskID, MaxNeedsLevelID, 
																	Genders, MinAge, MaxAge, ChildCapacityPlacementNum, UserID)																			
		   VALUES (@vcRacialBackground, @iMaxLegalRiskID, @iMaxNeedsLevelID, 
			@vcGenders, @iMinAge, @iMaxAge, @iChildCapacityPlacementNum, @iUserID)
		   SELECT @iReturnedAdoptiveResourcePlacementPreferencesID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new adoptive resource placement preferences info.', 1
		   END

		   UPDATE AR
				SET AR.AdoptiveResourcePlacementPreferencesID = @iReturnedAdoptiveResourcePlacementPreferencesID,
					AR.UserID = @iUserID
		   FROM dbo.tbAdoptiveResource_Versioned AR 
		   WHERE AR.AdoptiveResourceID = @iAdoptiveResourceID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update adoptive resource with new placement preferences info.', 1
		   END

		END
		ELSE --Should be an update
		BEGIN 

		   UPDATE APPP
				SET APPP.RacialBackground = @vcRacialBackground, 
					APPP.MaxLegalRiskID = @iMaxLegalRiskID, 
					APPP.MaxNeedsLevelID = @iMaxNeedsLevelID, 
					APPP.Genders = @vcGenders, 
					APPP.MinAge = @iMinAge, 
					APPP.MaxAge = @iMaxAge, 
					APPP.ChildCapacityPlacementNum = @iChildCapacityPlacementNum,
					APPP.UserID = @iUserID
		   FROM dbo.tbAdoptiveResourcePlacementPreferences_Versioned APPP
		   WHERE APPP.AdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update existing adoptive resource placement info.', 1
		   END

		END
	END TRY
	BEGIN CATCH 
		    SELECT @vcErrorMessage = ERROR_MESSAGE(); 
            RETURN 1; 
	END CATCH 

	RETURN 0; 

END
GO
