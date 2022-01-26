USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspViewAdoptiveResourceProfile
	Purpose: Returns adoptive resource profile information. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspViewAdoptiveResourceProfile
	@iAdoptiveResourceID int, 
	@bIncludeDeactivated bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtCurrentTimestampUTC datetime2 = CAST(GETUTCDATE() AS datetime2); 

	SELECT ARV.AdoptiveResourceID, ARV.AdoptiveResourceName, ARV.FamilyResourceWorkerID, 
		ARV.LicenseNumber, ARV.LicenseExpirationDate, ARV.HomestudyAttachmentPath, 
		ARV.AdoptiveResourcePhotoPath, ARV.FamilyMatchUploadConsentPath,
		ARV.AdoptiveResourcePlacementPreferencesID, ARV.AdoptiveResourceHouseholdInfoID, 
		ARV.IsDeleted, ARV.UserID
	FROM dbo.tbAdoptiveResource_Versioned 
	FOR SYSTEM_TIME AS OF @dtCurrentTimestampUTC ARV
	WHERE ARV.AdoptiveResourceID = @iAdoptiveResourceID
		AND CASE WHEN @bIncludeDeactivated = 0 AND ARV.IsDeleted = 0 THEN 1 
				 WHEN @bIncludeDeactivated = 1 THEN 1 
				 ELSE 0 END = 1; 


END
GO
