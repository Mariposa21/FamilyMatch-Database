/*
	Mariposa21
	dbo.uspMaintainAdoptiveResourceHouseholdInfo test 
*/
USE [FamilyMatch]

GO

DECLARE @iAdoptiveResourceHouseholdInfoID int = 0, 
	@iAdoptiveResourceID int = 1, 
	@vcStreetAddress1 varchar(100) = '116 Blueberry Lane', 
	@vcStreetAddress2 varchar(100) = NULL, 
	@vcAddressCity varchar(50) = 'Town', 
	@cAddressState char(2) = 'MA', 
	@cAddressZipCode char(5) = '00000', 
	@vcLanguagesSpoken varchar(25) = '1,2', 
	@iHouseholdTypeID tinyint = 1, 
	@iHouseTypeID tinyint = 1, 
	@iNumChildrenInHome tinyint = 2, 
	@vcRacialBackground varchar(25) = '1,2', 
	@iUserID int = 1, 
	@iReturnedAdoptiveResourceHouseholdInfoID int,
	@vcErrorMessage varchar(4000) = NULL 

SELECT @iUserID

SELECT @vcErrorMessage

EXEC dbo.uspMaintainAdoptiveResourceHouseholdInfo
	@iAdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID, 
	@iAdoptiveResourceID = @iAdoptiveResourceID, 
	@vcStreetAddress1 = @vcStreetAddress1, 
	@vcStreetAddress2 = @vcStreetAddress2, 
	@vcAddressCity = @vcAddressCity, 
	@cAddressState = @cAddressState, 
	@cAddressZipCode = @cAddressZipCode, 
	@vcLanguagesSpoken = @vcLanguagesSpoken, 
	@iHouseholdTypeID = @iHouseholdTypeID, 
	@iHouseTypeID = @iHouseTypeID, 
	@iNumChildrenInHome = @iNumChildrenInHome, 
	@vcRacialBackground = @vcRacialBackground, 
	@iUserID = @iUserID, 
	@iReturnedAdoptiveResourceHouseholdInfoID = @iReturnedAdoptiveResourceHouseholdInfoID OUTPUT,
	@vcErrorMessage = @vcErrorMessage OUTPUT

SELECT @iReturnedAdoptiveResourceHouseholdInfoID
SELECT * 
FROM dbo.tbAdoptiveResourceHouseholdInfo_Versioned
FOR SYSTEM_TIME ALL 
WHERE AdoptiveResourceHouseholdInfoID = @iReturnedAdoptiveResourceHouseholdInfoID