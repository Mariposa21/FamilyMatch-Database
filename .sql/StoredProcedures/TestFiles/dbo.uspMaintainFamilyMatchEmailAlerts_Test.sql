/*
	Mariposa21
	dbo.uspMaintainFamilyMatchEmailAlerts test
*/
USE [FamilyMatch]

GO

DECLARE @vcEmailAlertRequestName varchar(100) = 'EmailRequest1', 
		@iFamilyMatchAlertID int = 0,
		@vcAdoptiveResourceName varchar(200), 
		@iFamilyResourceWorkerID int = 1,
		@iFamilyResourceWorkerAgencyID smallint, 
		@cAddressState char(2) = 'ma', 
		@cAddressZipCode char(5), 
		@vcIncludeHouseholdLanguages varchar(25), 
		@iHouseholdTypeID tinyint, 
		@iHouseTypeID tinyint, 
		@iNumChildrenInHome tinyint, 
		@vcIncludeHouseholdRacialBackgrounds varchar(25), 
		@vcIncludePlacementRacialBackgrounds varchar(25), 
		@iLegalRiskID tinyint, 
		@iNeedsLevelID tinyint, 
		@vcIncludePlacementGenders varchar(10), 
		@iMinAge tinyint = NULL, 
		@iMaxAge tinyint = NULL, 
		@bIsActive bit = 1, 
		@iUserID int = 1, 
		@iReturnedFamilyMatchAlertID int,
		@vcErrorMessage varchar(4000)

EXEC dbo.uspMaintainFamilyMatchEmailAlerts
	@iFamilyMatchAlertID = @iFamilyMatchAlertID, 
	@vcEmailAlertRequestName = @vcEmailAlertRequestName, 
	@vcAdoptiveResourceName = @vcAdoptiveResourceName, 
	@iFamilyResourceWorkerID = @iFamilyResourceWorkerID, 
	@iFamilyResourceWorkerAgencyID = @iFamilyResourceWorkerAgencyID, 
	@cAddressState = @cAddressState, 
	@cAddressZipCode = @cAddressZipCode, 
	@vcIncludeHouseholdLanguages = @vcIncludeHouseholdLanguages, 
	@iHouseholdTypeID = @iHouseholdTypeID,  
	@iHouseTypeID = @iHouseTypeID, 
	@iNumChildrenInHome = @iNumChildrenInHome, 
	@vcIncludeHouseholdRacialBackgrounds = @vcIncludeHouseholdRacialBackgrounds, 
	@vcIncludePlacementRacialBackgrounds = @vcIncludePlacementRacialBackgrounds, 
	@iLegalRiskID = @iLegalRiskID, 
	@iNeedsLevelID = @iNeedsLevelID, 
	@vcIncludePlacementGenders  = @vcIncludePlacementGenders, 
	@iMinAge = @iMinAge, 
	@iMaxAge = @iMaxAge, 
	@bIsActive = @bIsActive, 
	@iUserID = @iUserID, 
	@iReturnedFamilyMatchAlertID = @iReturnedFamilyMatchAlertID OUTPUT, 
	@vcErrorMessage = @vcErrorMessage OUTPUT

	SELECT * 
	FROM dbo.tbFamilyMatchEmailAlerts_Versioned 
	FOR SYSTEM_TIME ALL
	WHERE FamilyMatchAlertID = @iReturnedFamilyMatchAlertID



