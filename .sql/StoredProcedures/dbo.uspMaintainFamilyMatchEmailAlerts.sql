USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainFamilyMatchEmailAlerts
	Purpose: Maintains search paramaters for family matches users request alerts for. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainFamilyMatchEmailAlerts
	@iFamilyMatchAlertID int = 0, 
	@vcEmailAlertRequestName varchar(100), 
	@vcAdoptiveResourceName varchar(200) = NULL, 
	@iFamilyResourceWorkerID int = NULL,
	@iFamilyResourceWorkerAgencyID smallint = NULL, 
	@cAddressState char(2) = NULL, 
	@cAddressZipCode char(5) = NULL, 
	@vcIncludeHouseholdLanguages varchar(25) = NULL, 
	@iHouseholdTypeID tinyint = NULL, 
	@iHouseTypeID tinyint = NULL, 
	@iNumChildrenInHome tinyint = NULL, 
	@vcIncludeHouseholdRacialBackgrounds varchar(25) = NULL, 
	@vcIncludePlacementRacialBackgrounds varchar(25) = NULL, 
	@iLegalRiskID tinyint = NULL, 
	@iNeedsLevelID tinyint = NULL, 
	@vcIncludePlacementGenders varchar(10) = NULL, 
	@iMinAge tinyint = NULL, 
	@iMaxAge tinyint = NULL, 
	@iChildCapacityPlacementNum tinyint = NULL, 
	@bIsActive bit = 1, 
	@iUserID int = NULL, 
	@iReturnedFamilyMatchAlertID int OUTPUT,
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 

	SET @iReturnedFamilyMatchAlertID = @iFamilyMatchAlertID; 

	BEGIN TRY
		IF (@iFamilyMatchAlertID = 0)
		BEGIN
		   INSERT INTO dbo.tbFamilyMatchEmailAlerts_Versioned (EmailAlertRequestName, AdoptiveResourceName, FamilyResourceWorkerID, FamilyResourceWorkerAgencyID, AddressState, AddressZipCode, 
															IncludeHouseholdLanguages, HouseholdTypeID, HouseTypeID, NumChildrenInHome, 
															IncludeHouseholdRacialBackgrounds, IncludePlacementRacialBackgrounds, 
															LegalRiskID, NeedsLevelID, IncludePlacementGenders, MinAge, MaxAge, 
															ChildCapacityPlacementNum, IsActive, UserID)
		   VALUES (@vcEmailAlertRequestName, @vcAdoptiveResourceName, @iFamilyResourceWorkerID, @iFamilyResourceWorkerAgencyID, @cAddressState, @cAddressZipCode, 
				   @vcIncludeHouseholdLanguages, @iHouseholdTypeID, @iHouseTypeID, @iNumChildrenInHome, 
				   @vcIncludeHouseholdRacialBackgrounds, @vcIncludePlacementRacialBackgrounds, 
				   @iLegalRiskID, @iNeedsLevelID, @vcIncludePlacementGenders, @iMinAge, @iMaxAge, 
				   @iChildCapacityPlacementNum, @bIsActive, @iUserID); 
		   SELECT @iReturnedFamilyMatchAlertID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new family match alert request.', 1
		   END
		END
		ELSE --Should be an update
		BEGIN 

		   UPDATE FM
				SET FM.EmailAlertRequestName = @vcEmailAlertRequestName, 
					FM.AdoptiveResourceName = @vcAdoptiveResourceName, 
					FM.FamilyResourceWorkerID = @iFamilyResourceWorkerID, 
					FM.FamilyResourceWorkerAgencyID = @iFamilyResourceWorkerAgencyID, 
					FM.AddressState = @cAddressState, 
					FM.AddressZipCode = @cAddressZipCode, 
					FM.IncludeHouseholdLanguages = @vcIncludeHouseholdLanguages, 
					FM.HouseholdTypeID = @iHouseholdTypeID, 
					FM.HouseTypeID = @iHouseTypeID, 
					FM.NumChildrenInHome = @iNumChildrenInHome, 
					FM.IncludeHouseholdRacialBackgrounds = @vcIncludeHouseholdRacialBackgrounds, 
					FM.IncludePlacementRacialBackgrounds = @vcIncludePlacementRacialBackgrounds, 
					FM.LegalRiskID = @iLegalRiskID, 
					FM.NeedsLevelID = @iNeedsLevelID, 
					FM.IncludePlacementGenders = @vcIncludePlacementGenders, 
					FM.MinAge = @iMinAge, 
					FM.MaxAge = @iMaxAge, 
					FM.ChildCapacityPlacementNum = @iChildCapacityPlacementNum, 
					FM.IsActive = @bIsActive, 
					FM.UserID = @iUserID
		   FROM dbo.tbFamilyMatchEmailAlerts_Versioned FM
		   WHERE FM.FamilyMatchAlertID = @iFamilyMatchAlertID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new family match alert request.', 1
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
