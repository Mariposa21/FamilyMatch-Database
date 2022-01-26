/*
	Mariposa21
	dbo.uspMaintainAdoptiveResource test 
*/
USE [FamilyMatch]

GO

DECLARE  @iAdoptiveResourceID int = 0, 
	     @vcAdoptiveResourceName varchar(200) = 'Mary and Sean Smith', 
		 @iFamilyResourceWorkerID int = 1, 
		 @vcLicenseNumber varchar(50) = 'L1235', 
		 @dLicenseExpirationDate date = '2024/01/01', 
		 @vcHomestudyAttachmentPath varchar(max) = 'E:\ExampleDrive\1', 
		 @vcAdoptiveResourcePhotoPath varchar(max) = 'E:\ExampleDrive\2', 
		 @vcFamilyMatchUploadConsentPath varchar(max) = 'E:\ExampleDrive\3', 
		 @iAdoptiveResourcePlacementPreferencesID int = NULL, 
		 @iAdoptiveResourceHouseholdInfoID int = NULL, 
		 @bIsDeleted bit = 0, 
		 @iUserID int = 1, 
		 @iReturnedAdoptiveResourceID int,
		 @vcErrorMessage varchar(4000) = NULL

EXEC dbo.uspMaintainAdoptiveResource
	@iAdoptiveResourceID = @iAdoptiveResourceID, 
	@vcAdoptiveResourceName = @vcAdoptiveResourceName, 
	@iFamilyResourceWorkerID = @iFamilyResourceWorkerID,  
	@vcLicenseNumber = @vcLicenseNumber, 
	@dLicenseExpirationDate = @dLicenseExpirationDate, 
	@vcHomestudyAttachmentPath = @vcHomestudyAttachmentPath, 
	@vcAdoptiveResourcePhotoPath = @vcAdoptiveResourcePhotoPath, 
	@vcFamilyMatchUploadConsentPath = @vcFamilyMatchUploadConsentPath, 
	@iAdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID, 
	@iAdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID, 
	@bIsDeleted = @bIsDeleted, 
	@iUserID = @iUserID, 
	@iReturnedAdoptiveResourceID = @iReturnedAdoptiveResourceID OUTPUT,
	@vcErrorMessage = @vcErrorMessage OUTPUT
	
SELECT @iReturnedAdoptiveResourceID
SELECT @vcErrorMessage

SELECT * 
FROM dbo.tbAdoptiveResource_Versioned
FOR SYSTEM_TIME ALL
WHERE AdoptiveResourceID = @iReturnedAdoptiveResourceID



