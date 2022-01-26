USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspFindMatchingAdoptiveResourceProfiles
	Purpose: Identifies matching adoptive resource profiles. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspFindMatchingAdoptiveResourceProfiles
	@iAdoptiveResourceID int = NULL, 
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
	@iChildCapacityPlacementNum tinyint = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @vcCurrentTimestampUTC varchar(25) = CONVERT(varchar(25), GETUTCDATE(), 121)
	DECLARE @vcSQLStatement varchar(max)

	CREATE TABLE #HouseholdLanguages  (
		HouseholdLanguageID tinyint
	); 

	CREATE TABLE #HouseholdRacialBackgrounds (
		HouseholdRacialBackgroundID tinyint
	); 

	CREATE TABLE #PlacementRacialBackgrounds (
		PlacementRacialBackgroundID tinyint
	); 

	CREATE TABLE #PlacementGenders (
		IncludePlacementGenders tinyint
	); 

	IF (@vcIncludeHouseholdLanguages IS NOT NULL)
	BEGIN 
		INSERT INTO #HouseholdLanguages (HouseholdLanguageID) 
		SELECT value
		FROM STRING_SPLIT(@vcIncludeHouseholdLanguages, ','); 
	END

	IF @vcIncludeHouseholdRacialBackgrounds IS NOT NULL 
	BEGIN 
		INSERT INTO #HouseholdRacialBackgrounds (HouseholdRacialBackgroundID) 
		SELECT value
		FROM STRING_SPLIT(@vcIncludeHouseholdRacialBackgrounds, ','); 
	END

	IF (@vcIncludePlacementRacialBackgrounds IS NOT NULL)
	BEGIN 
		INSERT INTO #PlacementRacialBackgrounds (PlacementRacialBackgroundID) 
		SELECT value
		FROM STRING_SPLIT(@vcIncludePlacementRacialBackgrounds, ','); 
	END

	IF (@vcIncludePlacementGenders IS NOT NULL)
	BEGIN 
		INSERT INTO #PlacementGenders (IncludePlacementGenders) 
		SELECT value
		FROM STRING_SPLIT(@vcIncludePlacementGenders, ','); 
	END

	--Dynamic SQL creation
	SET @vcSQLStatement = ' SELECT AR.AdoptiveResourceID, AR.AdoptiveResourceName, '
						+ '(FRW.FamilyResourceLastName + '', '' + FRW.FamilyResourceFirstName) AS FamilyResourceWorkerName, '
						+ ' A.Agency AS FamilyResourceWorkerAgencyName, CASE WHEN FRW.IsDeleted = 1 THEN ''Inactive'' ELSE ''Active'' END AS FamilyResourceWorkerStatus '
						+ ' FROM dbo.tbAdoptiveResource_Versioned '
						+ ' FOR SYSTEM_TIME AS OF ''' + @vcCurrentTimestampUTC + ''' AR '
						+ '		INNER JOIN dbo.tbAdoptiveResourceHouseholdInfo_Versioned '
						+ '		FOR SYSTEM_TIME AS OF ''' + @vcCurrentTimestampUTC + ''' ARH '
						+ '			ON AR.AdoptiveResourceHouseholdInfoID = ARH.AdoptiveResourceHouseholdInfoID '
						+ '		INNER JOIN dbo.tbAdoptiveResourcePlacementPreferences_Versioned '
						+ '		FOR SYSTEM_TIME AS OF ''' + @vcCurrentTimestampUTC + ''' ARP '
						+ '			ON AR.AdoptiveResourcePlacementPreferencesID = ARP.AdoptiveResourcePlacementPreferencesID '
						+ '		INNER JOIN dbo.tbFamilyResourceWorker_Versioned '
						+ '		FOR SYSTEM_TIME AS OF ''' + @vcCurrentTimestampUTC + ''' FRW '
						+ '			ON AR.FamilyResourceWorkerID = FRW.FamilyResourceWorkerID '
						+ '		INNER JOIN dbo.stbAgency A '
						+ '			ON FRW.AgencyID = A.AgencyID '
						+ ' WHERE AR.IsDeleted = 0 '; 

	IF (@iAdoptiveResourceID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND AR.AdoptiveResourceID = ' + CAST(@iAdoptiveResourceID AS varchar(10)); 
	END

	IF (@vcAdoptiveResourceName IS NOT NULL) 
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND AR.AdoptiveResourceName LIKE ''%' + @vcAdoptiveResourceName + '%'''; 
	END

	IF (@iFamilyResourceWorkerID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND AR.FamilyResourceWorkerID = ' + CAST(@iFamilyResourceWorkerID AS varchar(10)); 
	END

	IF (@iFamilyResourceWorkerAgencyID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND FRW.AgencyID = ' + CAST(@iFamilyResourceWorkerAgencyID AS varchar(10)); 
	END

	IF (@cAddressState IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.AddressState = ''' + CAST(@cAddressState AS varchar(2)) + ''''; 
	END

	IF (@cAddressZipCode IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.AddressZipCode = ''' + CAST(@cAddressZipCode AS varchar(5)) + ''''; 
	END

	IF (@iHouseholdTypeID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.HouseholdTypeID = ' + CAST(@iHouseholdTypeID AS varchar(3)); 
	END

	IF (@iHouseTypeID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.HouseTypeID = ' + CAST(@iHouseTypeID AS varchar(5)); 
	END

	IF	(@iHouseTypeID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.HouseTypeID = ' + CAST(@iHouseTypeID AS varchar(5)); 
	END

	IF (@iNumChildrenInHome IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARH.NumChildrenInHome = ' + CAST(@iNumChildrenInHome AS varchar(3)); 
	END

	IF (@iLegalRiskID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARP.MaxLegalRiskID >= ' + CAST(@iLegalRiskID AS varchar(3)); 
	END
	
	IF (@iNeedsLevelID IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARP.MaxNeedsLevelID >= ' + CAST(@iNeedsLevelID AS varchar(3)); 
	END

	IF (@iMinAge IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARP.MinAge <= ' + CAST(@iMinAge AS varchar(3)); 
	END
	
	IF (@iMaxAge IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARP.MaxAge >= ' + CAST(@iMaxAge AS varchar(3)); 
	END

	IF (@iChildCapacityPlacementNum IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND ARP.ChildCapacityPlacementNum >= ' + CAST(@iChildCapacityPlacementNum AS varchar(3)); 
	END

	IF (@vcIncludeHouseholdLanguages IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND EXISTS (SELECT 1 '
											  + '			  FROM STRING_SPLIT(ARH.LanguagesSpoken, '','') L '
											  + '	    		INNER JOIN #HouseholdLanguages HL '
											  + '					ON CAST(L.Value AS tinyint) = HL.HouseholdLanguageID) '; 
	END

	IF @vcIncludeHouseholdRacialBackgrounds IS NOT NULL 
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND EXISTS (SELECT 1 '
											  + '			  FROM STRING_SPLIT(ARH.RacialBackground, '','') R '
											  + '	    		INNER JOIN #HouseholdRacialBackgrounds HR '
											  + '					ON CAST(R.Value AS tinyint) = HR.HouseholdRacialBackgroundID) '; 
	END

	IF (@vcIncludePlacementRacialBackgrounds IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND EXISTS (SELECT 1 '
											  + '			  FROM STRING_SPLIT(ARP.RacialBackground, '','') R '
											  + '	    		INNER JOIN #PlacementRacialBackgrounds PR '
											  + '					ON CAST(R.Value AS tinyint) = PR.PlacementRacialBackgroundID) '; 
	END

	IF (@vcIncludePlacementGenders IS NOT NULL)
	BEGIN 
		SET @vcSQLStatement = @vcSQLStatement + ' AND EXISTS (SELECT 1 '
											  + '			  FROM STRING_SPLIT(ARP.Genders, '','') G '
											  + '	    		INNER JOIN #PlacementGenders PG '
											  + '					ON CAST(G.Value AS tinyint) = PG.Gender) '; 
	END

	DECLARE @nvcSQLStatement nvarchar(max) = CAST(@vcSQLStatement as nvarchar(max)); 
	EXEC sp_executesql @nvcSQLStatement,  
			 N'@vcCurrentTimestampUTC datetime2, 
			 @vcAdoptiveResourceName varchar(200),  
			 @iFamilyResourceWorkerID int, 
			 @iFamilyResourceWorkerAgencyID smallint, 
			 @cAddressState char(2), 
			 @cAddressZipCode char(5), 
			 @iHouseholdTypeID tinyint, 
			 @iHouseTypeID tinyint, 
			 @iNumChildrenInHome tinyint, 
			 @iLegalRiskID tinyint,  
			 @iNeedsLevelID tinyint, 
			 @iMinAge tinyint, 
			 @iMaxAge tinyint, 
			 @iChildCapacityPlacementNum tinyint ', 
			 @vcCurrentTimestampUTC, 
			 @vcAdoptiveResourceName, 
			 @iFamilyResourceWorkerID, 
			 @iFamilyResourceWorkerAgencyID, 
			 @cAddressState, 
			 @cAddressZipCode, 
			 @iHouseholdTypeID, 
			 @iHouseTypeID, 
			 @iNumChildrenInHome, 
			 @iLegalRiskID, 
			 @iNeedsLevelID, 
			 @iMinAge, 
			 @iMaxAge, 
			 @iChildCapacityPlacementNum; 

	DROP TABLE #HouseholdLanguages; 
	DROP TABLE #HouseholdRacialBackgrounds; 
	DROP TABLE #PlacementRacialBackgrounds; 
	DROP TABLE #PlacementGenders; 

END
GO
