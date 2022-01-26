USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainAdoptiveResourceHouseholdInfo
	Purpose: Maintains Adoptive Resource's household information (type of house, languages spoken, # kids currently in home)

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainAdoptiveResourceHouseholdInfo
	@iAdoptiveResourceHouseholdInfoID int = 0, 
	@iAdoptiveResourceID int = 0, 
	@vcStreetAddress1 varchar(100), 
	@vcStreetAddress2 varchar(100) = NULL, 
	@vcAddressCity varchar(50), 
	@cAddressState char(2), 
	@cAddressZipCode char(5), 
	@vcLanguagesSpoken varchar(25), 
	@iHouseholdTypeID tinyint, 
	@iHouseTypeID tinyint, 
	@iNumChildrenInHome tinyint, 
	@vcRacialBackground varchar(25), 
	@iUserID int, 
	@iReturnedAdoptiveResourceHouseholdInfoID int OUTPUT,
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 

	SET @iReturnedAdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID;  

	BEGIN TRY
		IF (@iAdoptiveResourceHouseholdInfoID = 0)
		BEGIN
		   INSERT INTO dbo.tbAdoptiveResourceHouseholdInfo_Versioned (StreetAddress1, StreetAddress2, AddressCity, AddressState, 
																	AddressZipCode, LanguagesSpoken, HouseholdTypeID, HouseTypeID, 
																	NumChildrenInHome, RacialBackground, UserID)
		   VALUES (@vcStreetAddress1, @vcStreetAddress2, @vcAddressCity, @cAddressState, 
				@cAddressZipCode, @vcLanguagesSpoken, @iHouseholdTypeID, @iHouseTypeID, 
				@iNumChildrenInHome, @vcRacialBackground, @iUserID); 
		   SELECT @iReturnedAdoptiveResourceHouseholdInfoID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new adoptive resource household info.', 1
		   END

		   UPDATE AR
				SET AR.AdoptiveResourceHouseholdInfoID = @iReturnedAdoptiveResourceHouseholdInfoID, 
					AR.UserID = @iUserID
		   FROM dbo.tbAdoptiveResource_Versioned AR 
		   WHERE AR.AdoptiveResourceID = @iAdoptiveResourceID; 
		   SET @iErrorID = @@ERROR

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update adoptive resource with new household info.', 1
		   END

		END
		ELSE --Should be an update
		BEGIN 

		   UPDATE ARHI
				SET ARHI.StreetAddress1 = @vcStreetAddress1, 
					ARHI.StreetAddress2 = @vcStreetAddress2, 
					ARHI.AddressCity = @vcAddressCity, 
					ARHI.AddressState = @cAddressState, 
					ARHI.AddressZipCode = @cAddressZipCode, 
					ARHI.LanguagesSpoken = @vcLanguagesSpoken, 
					ARHI.HouseholdTypeID = @iHouseholdTypeID, 
					ARHI.HouseTypeID = @iHouseTypeID, 
					ARHI.NumChildrenInHome = @iNumChildrenInHome, 
					ARHI.RacialBackground = @vcRacialBackground, 
					ARHI.UserID = @iUserID
		   FROM dbo.tbAdoptiveResourceHouseholdInfo_Versioned ARHI
		   WHERE ARHI.AdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update existing adoptive resource household info.', 1
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
