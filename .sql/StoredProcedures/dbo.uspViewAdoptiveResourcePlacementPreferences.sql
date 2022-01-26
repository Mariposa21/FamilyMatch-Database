USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspViewAdoptiveResourcePlacementPreferences
	Purpose: Returns Adoptive Resource's current placement preferences

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspViewAdoptiveResourcePlacementPreferences
	@iAdoptiveResourcePlacementPreferencesID int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtCurrentTimestampUTC datetime2 = CAST(GETUTCDATE() AS datetime2); 

	SELECT AP.AdoptiveResourcePlacementPreferencesID, AP.RacialBackground, AP.MaxLegalRiskID, 
		AP.MaxNeedsLevelID, AP.Genders, AP.MinAge, AP.MaxAge, AP.ChildCapacityPlacementNum, AP.UserID
	FROM dbo.tbAdoptiveResourcePlacementPreferences_Versioned
	FOR SYSTEM_TIME AS OF @dtCurrentTimestampUTC AP
	WHERE AP.AdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID; 


END
GO