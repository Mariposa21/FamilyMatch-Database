USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspViewAdoptiveResourceHouseholdInfo
	Purpose: Returns Adoptive Resource's household information. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspViewAdoptiveResourceHouseholdInfo
	@iAdoptiveResourceHouseholdInfoID int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtCurrentTimestampUTC datetime2 = CAST(GETUTCDATE() AS datetime2); 

	SELECT AH.AdoptiveResourceHouseholdInfoID, AH.StreetAddress1, AH.StreetAddress2, 
		AH.AddressCity, AH.AddressState, AH.AddressZipCode, AH.LanguagesSpoken, 
		AH.HouseholdTypeID, AH.HouseTypeID, AH.NumChildrenInHome, AH.RacialBackground, 
		AH.UserID
	FROM dbo.tbAdoptiveResourceHouseholdInfo_Versioned
	FOR SYSTEM_TIME AS OF @dtCurrentTimestampUTC AH
	WHERE AH.AdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID; 


END
GO