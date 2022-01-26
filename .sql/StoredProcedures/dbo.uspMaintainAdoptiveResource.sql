USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainAdoptiveResource
	Purpose: Maintains Adoptive Resource's basic info. 
			 --Includes directory paths to homestudy doc, adoptive resource profile photo, 
			 --and family match adoptive resource consent agreement path. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainAdoptiveResource
	@iAdoptiveResourceID int = 0, 
	@vcAdoptiveResourceName varchar(200), 
	@iFamilyResourceWorkerID int, 
	@vcLicenseNumber varchar(50), 
	@dLicenseExpirationDate date, 
	@vcHomestudyAttachmentPath varchar(max), 
	@vcAdoptiveResourcePhotoPath varchar(max), 
	@vcFamilyMatchUploadConsentPath varchar(max), 
	@iAdoptiveResourcePlacementPreferencesID int = NULL, 
	@iAdoptiveResourceHouseholdInfoID int = NULL, 
	@bIsDeleted bit = 0, 
	@iUserID int, 
	@iReturnedAdoptiveResourceID int OUTPUT,
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 

	SET @iReturnedAdoptiveResourceID = @iAdoptiveResourceID; 

	BEGIN TRY
		IF (@iAdoptiveResourceID = 0)
		BEGIN
		   INSERT INTO dbo.tbAdoptiveResource_Versioned (AdoptiveResourceName, FamilyResourceWorkerID, LicenseNumber, 
												LicenseExpirationDate, HomestudyAttachmentPath, AdoptiveResourcePhotoPath, 
												FamilyMatchUploadConsentPath, AdoptiveResourcePlacementPreferencesID, 
												AdoptiveResourceHouseholdInfoID, IsDeleted, UserID)
		   VALUES (@vcAdoptiveResourceName, @iFamilyResourceWorkerID, @vcLicenseNumber, 
				   @dLicenseExpirationDate, @vcHomestudyAttachmentPath, @vcAdoptiveResourcePhotoPath, 
				   @vcFamilyMatchUploadConsentPath, @iAdoptiveResourcePlacementPreferencesID, 
				   @iAdoptiveResourceHouseholdInfoID, @bIsDeleted, @iUserID); 
		   SELECT @iReturnedAdoptiveResourceID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new adoptive resource.', 1
		   END
		END
		ELSE --Should be an update
		BEGIN 

		   UPDATE AR
				SET AR.AdoptiveResourceName = @vcAdoptiveResourceName, 
					AR.FamilyResourceWorkerID = @iFamilyResourceWorkerID, 
					AR.LicenseNumber = @vcLicenseNumber, 
					AR.LicenseExpirationDate = @dLicenseExpirationDate, 
					AR.HomestudyAttachmentPath = @vcHomestudyAttachmentPath, 
					AR.AdoptiveResourcePhotoPath = @vcAdoptiveResourcePhotoPath, 
					AR.FamilyMatchUploadConsentPath = @vcFamilyMatchUploadConsentPath, 
					AR.AdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID, 
					AR.AdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID, 
					AR.IsDeleted = @bIsDeleted, 
					AR.UserID = @iUserID
		   FROM dbo.tbAdoptiveResource_Versioned AR
		   WHERE AR.AdoptiveResourceID = @iAdoptiveResourceID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update existing adoptive resource.', 1
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
