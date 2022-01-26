/*
	Mariposa21
	dbo.uspMaintainAdoptiveResourcePlacementPreferences test 
*/
USE [FamilyMatch]

GO

DECLARE @iAdoptiveResourcePlacementPreferencesID int = 0, 
		@iAdoptiveResourceID int = 1, 
		@vcRacialBackground varchar(25) = '1,2', 
		@iMaxLegalRiskID tinyint = 1, 
		@iMaxNeedsLevelID tinyint = 2, 
		@vcGenders varchar(10) = '1', 
		@iMinAge tinyint = 3, 
		@iMaxAge tinyint = 6, 
		@iChildCapacityPlacementNum tinyint = 1, 
		@iUserID int = 1, 
		@iReturnedAdoptiveResourcePlacementPreferencesID int,
		@vcErrorMessage varchar(4000) = NULL

EXEC dbo.uspMaintainAdoptiveResourcePlacementPreferences
	@iAdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID, 
	@iAdoptiveResourceID = @iAdoptiveResourceID,  
	@vcRacialBackground = @vcRacialBackground,  
	@iMaxLegalRiskID = @iMaxLegalRiskID, 
	@iMaxNeedsLevelID = @iMaxNeedsLevelID, 
	@vcGenders = @vcGenders, 
	@iMinAge = @iMinAge, 
	@iMaxAge = @iMaxAge, 
	@iUserID = @iUserID, 
	@iChildCapacityPlacementNum = @iChildCapacityPlacementNum, 
	@iReturnedAdoptiveResourcePlacementPreferencesID = @iReturnedAdoptiveResourcePlacementPreferencesID OUTPUT, 
	@vcErrorMessage = @vcErrorMessage OUTPUT

SELECT @iReturnedAdoptiveResourcePlacementPreferencesID
SELECT * 
FROM dbo.tbAdoptiveResourcePlacementPreferences_Versioned
FOR SYSTEM_TIME ALL 
WHERE AdoptiveResourcePlacementPreferencesID = @iReturnedAdoptiveResourcePlacementPreferencesID