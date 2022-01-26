/*
	Mariposa21
	dbo.uspFindMatchingAdoptiveResourceProfiles test
*/
USE [FamilyMatch]

GO

DECLARE @iAdoptiveResourceID int, 
		@vcAdoptiveResourceName varchar(200), 
		@iFamilyResourceWorkerID int = 1,
		@iFamilyResourceWorkerAgencyID smallint, 
		@cAddressState char(2) = 'ma', 
		@cAddressZipCode char(5), 
		@vcIncludeHouseholdLanguages varchar(25) = '1', 
		@iHouseholdTypeID tinyint = 1, 
		@iHouseTypeID tinyint = 1, 
		@iNumChildrenInHome tinyint, 
		@vcIncludeHouseholdRacialBackgrounds varchar(25), 
		@vcIncludePlacementRacialBackgrounds varchar(25), 
		@iLegalRiskID tinyint = 1, 
		@iNeedsLevelID tinyint = 2, 
		@vcIncludePlacementGenders varchar(10), 
		@iMinAge tinyint, 
		@iMaxAge tinyint, 
		@iChildCapacityPlacementNum tinyint; 

EXEC dbo.uspFindMatchingAdoptiveResourceProfiles
	@iAdoptiveResourceID = @iAdoptiveResourceID, 
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
	@iChildCapacityPlacementNum = @iChildCapacityPlacementNum
