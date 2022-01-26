USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspSendNewFamilyMatchEmailAlerts
	Purpose: Creates a new email alert for any family match email alert requests that have a new Family Match. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspSendNewFamilyMatchEmailAlerts
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @vcDBMailProfile varchar(100) = 'FamilyMatch DB Profile'

	CREATE TABLE #ValidFamilyMatchEmailAlertRequests (
		RowNum int NOT NULL PRIMARY KEY, 
		FamilyMatchAlertID int NOT NULL, 
		EmailAlertRequestName varchar(100) NOT NULL, 
		AdoptiveResourceName varchar(200) NULL, 
		FamilyResourceWorkerID int NULL, 
		FamilyResourceWorkerAgencyID smallint NULL, 
		AddressState char(2) NULL, 
		AddressZipCode char(5) NULL, 
		IncludeHouseholdLanguages varchar(25) NULL, 
		HouseholdTypeID tinyint NULL, 
		HouseTypeID tinyint NULL, 
		NumChildrenInHome tinyint NULL, 
		IncludeHouseholdRacialBackgrounds varchar(25) NULL, 
		IncludePlacementRacialBackgrounds varchar(25) NULL, 
		LegalRiskID tinyint NULL, 
		NeedsLevelID tinyint NULL, 
		IncludePlacementGenders varchar(10) NULL, 
		MinAge tinyint NULL, 
		MaxAge tinyint NULL, 
		ChildCapacityPlacementNum tinyint NULL,
		UserID int NOT NULL, 
		UserEmail varchar(250) NOT NULL
	); 

	CREATE TABLE #MatchDataReturn (
		AdoptiveResourceID int, 
		AdoptiveResourceName varchar(200), 
		FamilyResourceWorkerName varchar(100), 
		FamilyResourceWorkerAgencyName varchar(100), 
		FamilyResourceWorkerStatus varchar(10)
	); 

	DECLARE @dtCurrentTimestampUTC datetime = GETUTCDATE(); 
	DECLARE @vcCurrentTimestampUTC varchar(25) = CONVERT(varchar(25), @dtCurrentTimestampUTC, 121); 
	DECLARE @dtOneWeekPriorUTC datetime = DATEADD(WEEK, -1, @dtCurrentTimestampUTC); 

	--Grab all valid family match email alerts requests. 
	INSERT INTO #ValidFamilyMatchEmailAlertRequests (RowNum, FamilyMatchAlertID, EmailAlertRequestName, AdoptiveResourceName, 
											FamilyResourceWorkerID, FamilyResourceWorkerAgencyID, AddressState, AddressZipCode, IncludeHouseholdLanguages, HouseholdTypeID, HouseTypeID, 
											NumChildrenInHome, IncludeHouseholdRacialBackgrounds, IncludePlacementRacialBackgrounds, LegalRiskID, NeedsLevelID, 
											IncludePlacementGenders, MinAge, MaxAge, ChildCapacityPlacementNum, UserID, UserEmail) 
	SELECT ROW_NUMBER() OVER (ORDER BY EA.FamilyMatchAlertID ASC) AS RowNum, EA.FamilyMatchAlertID, EA.EmailAlertRequestName, EA.AdoptiveResourceName, 
		EA.FamilyResourceWorkerID, EA.FamilyResourceWorkerAgencyID, EA.AddressState, EA.AddressZipCode, EA.IncludeHouseholdLanguages, EA.HouseholdTypeID, EA.HouseTypeID, 
		EA.NumChildrenInHome, EA.IncludeHouseholdRacialBackgrounds, EA.IncludePlacementRacialBackgrounds, EA.LegalRiskID, EA.NeedsLevelID, 
		EA.IncludePlacementGenders, EA.MinAge, EA.MaxAge, EA.ChildCapacityPlacementNum, EA.UserID, U.UserEmail
	FROM dbo.tbFamilyMatchEmailAlerts_Versioned 
	FOR SYSTEM_TIME AS OF @vcCurrentTimestampUTC EA
		INNER JOIN dbo.tbUser_Versioned 
		FOR SYSTEM_TIME AS OF @dtCurrentTimestampUTC U
			ON EA.UserID = U.UserID 
	WHERE EA.IsActive = 1
	 AND U.IsValidUser = 1
	 AND EA.RecordStartDateTime >= @dtOneWeekPriorUTC; 

	--Loop through valid family match alerts requests to see if any have new records. 
	IF EXISTS (SELECT 1 FROM #ValidFamilyMatchEmailAlertRequests) 
	BEGIN 
		DECLARE @iCounter int = 1; 
		DECLARE @iTotalAlerts int = (SELECT COUNT(*) FROM #ValidFamilyMatchEmailAlertRequests VR); 

		WHILE @iCounter <= @iTotalAlerts 
		BEGIN 

				DECLARE @iAdoptiveResourceID int = NULL, 
						@vcEmailAlertRequestName varchar(100) = NULL, 
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
						@iUserID int = NULL, 
						@vcRecipientEmail varchar(250), 
						@vcSubject varchar(150), 
						@vcEmailBody varchar(max), 
						@vcQueryOutput varchar(max); 
				TRUNCATE TABLE #MatchDataReturn; 

			SELECT @vcEmailAlertRequestName = VR.EmailAlertRequestName, @vcAdoptiveResourceName = VR.AdoptiveResourceName, @iFamilyResourceWorkerID = VR.FamilyResourceWorkerID, 
				@iFamilyResourceWorkerAgencyID = VR.FamilyResourceWorkerAgencyID, @cAddressState = VR.AddressState, @cAddressZipCode = VR.AddressZipCode, 
				@vcIncludeHouseholdLanguages = VR.IncludeHouseholdLanguages, @iHouseholdTypeID = VR.HouseholdTypeID, @iHouseTypeID = VR.HouseTypeID, 
				@iNumChildrenInHome = VR.NumChildrenInHome, @vcIncludeHouseholdRacialBackgrounds = IncludeHouseholdRacialBackgrounds,
				@vcIncludePlacementRacialBackgrounds = VR.IncludePlacementGenders, @iMinAge = VR.MinAge, @iMaxAge = VR.MaxAge, 	@iChildCapacityPlacementNum = ChildCapacityPlacementNum,
				@iUserID = VR.UserID, @vcRecipientEmail = VR.UserEmail
			FROM #ValidFamilyMatchEmailAlertRequests VR
			WHERE VR.RowNum = @iCounter; 

			INSERT INTO #MatchDataReturn
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
					@iChildCapacityPlacementNum = @iChildCapacityPlacementNum; 
		
			--If there are new records matching alert request criteria, alert should be sent. 
			IF EXISTS (SELECT 1 FROM #MatchDataReturn) 
			BEGIN 

				EXEC uspQueryToHtmlTable @html = @vcQueryOutput OUTPUT,  
										@query = ' SELECT AdoptiveResourceID AS [Adoptive Resource ID], FamilyResourceWorkerName AS [Family Resource Worker Name], FamilyResourceWorkerAgencyName AS [Family Resource Worker Agency Name], FamilyResourceWorkerStatus AS [Family Resource Worker Status] FROM #MatchDataReturn ', 
										@orderBy = ' ORDER BY [Adoptive Resource ID] ASC ';

				SET @vcEmailBody = ' <!DOCTYPE html><html><head><style>
									table, tr, th, td {
										border:1px solid black;
										border-collapse:collapse;
									}
									Caption {font-weight:bold;}</style>
									<h2>New Family Match(es) have been found for the following FamilyMatch Alert Request: ' + 
									@vcEmailAlertRequestName
									+ ' </h2></head><body> '; 
				SET @vcEmailBody = @vcEmailBody + @vcQueryOutput + ' </body></html> '; 

				SET @vcSubject = @vcEmailAlertRequestName + ': New FamilyMatch Alert'; 
				EXEC msdb.dbo.sp_send_dbmail
					@profile_name = @vcDBMailProfile, 
					@recipients = @vcRecipientEmail,  
					@body = @vcEmailBody, 
					@body_format = 'HTML',
					@subject = @vcSubject; 
			END

			SET @iCounter = @iCounter + 1; 
		END
	END

	DROP TABLE #ValidFamilyMatchEmailAlertRequests; 
	DROP TABLE #MatchDataReturn; 


END
GO
