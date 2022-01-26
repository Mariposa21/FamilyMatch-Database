/*Script to create FamilyMatch database and tables for corresponding FamilyMatch database.*/

--Create FamilyMatch database
USE [master]

GO

CREATE DATABASE [FamilyMatch]

GO

USE [FamilyMatch]

GO

/*Create FamilyMatch tables
 *Static tables first: 
  1. dbo.stbAgency
  2. dbo.stbGender
  3. dbo.stbHouseholdType
  4. dbo.stbHouseType
  5. dbo.stbLanguage
  6. dbo.stbLegalRisk
  7. dbo.stbNeedsLevel
  8. dbo.stbRacialBackground
  9. dbo.stbRole
  10. dbo.stbUserAccessType
*/ 

CREATE TABLE dbo.stbAgency  (
	AgencyID smallint IDENTITY(1,1) NOT NULL, 
	Agency varchar(100) NOT NULL, 
	PRIMARY KEY (AgencyID)
); 

CREATE TABLE dbo.stbGender (
	GenderID tinyint IDENTITY(1,1) NOT NULL, 
	Gender varchar(20) NOT NULL, 
	PRIMARY KEY (GenderID) 
); 

CREATE TABLE. dbo.stbHouseholdType (
	HouseholdTypeID tinyint IDENTITY(1,1) NOT NULL, 
	HouseholdType varchar(25) NOT NULL
	PRIMARY KEY (HouseholdTypeID) 
); 

CREATE TABLE dbo.stbHouseType (
	HouseTypeID tinyint IDENTITY(1,1) NOT NULL, 
	HouseType varchar(25) NOT NULL, 
	PRIMARY KEY (HouseTypeID) 
); 

CREATE TABLE dbo.stbLanguage (
	LanguageID tinyint IDENTITY(1,1) NOT NULL, 
	[Language] varchar(20) NOT NULL, 
	PRIMARY KEY (LanguageID)
); 

CREATE TABLE dbo.stbLegalRisk (
	LegalRiskID tinyint IDENTITY(1,1) NOT NULL, 
	LegalRisk varchar(25) NOT NULL, 
	PRIMARY KEY (LegalRiskID)
); 

CREATE TABLE dbo.stbNeedsLevel (
	NeedsLevelID tinyint IDENTITY(1,1) NOT NULL, 
	NeedsLevel varchar(25) NOT NULL
	PRIMARY KEY (NeedsLevelID) 
); 

CREATE TABLE dbo.stbRacialBackground (
	RacialBackgroundID tinyint IDENTITY(1,1) NOT NULL, 
	RacialBackground varchar(25) NOT NULL, 
	PRIMARY KEY (RacialBackgroundID)
); 

CREATE TABLE dbo.stbRole (
	RoleID tinyint IDENTITY(1,1) NOT NULL, 
	[Role] varchar(50) NOT NULL, 
	PRIMARY KEY (RoleID) 
); 

CREATE TABLE dbo.stbUserAccessType (
	UserAccessTypeID tinyint IDENTITY(1,1) NOT NULL, 
	UserAccessType varchar(25) NOT NULL, 
	PRIMARY KEY (UserAccessTypeID) 
); 

/*Create FamilyMatch tables
 *Dynamic tables next: 
	1. dbo.tbUser_Versioned
	2. dbo.tbFamilyResourceWorker_Versioned
	3. dbo.tbAdoptiveResourceHouseholdInfo_Versioned
	4. dbo.tbAdoptiveResourcePlacementPreferences_Versioned
	5. dbo.tbAdoptiveResource_Versioned
	6. dbo.tbUserAccessLog
	7. dbo.tbFamilyMatchEmailAlerts_Versioned

*/ 

CREATE TABLE dbo.tbUser_Versioned
(
    UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, 
	UserRoleID tinyint NOT NULL REFERENCES dbo.stbRole (RoleID), 
	AgencyID smallint NOT NULL REFERENCES dbo.stbAgency (AgencyID), 
	UserLastName varchar(50) NOT NULL, 
	UserFirstName varchar(50) NOT NULL, 
	UserEmail varchar(250) NOT NULL, 
	UserSalt uniqueidentifier NOT NULL, 
	UserPasswordHash binary(64) NOT NULL, 
	MostRecentPasswordUpdateDateTime datetime2 NOT NULL, 
	IsValidUser bit NOT NULL, 
	RecordCreationUserID int NOT NULL, 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tbUserHistory_Versioned));

CREATE TABLE dbo.tbFamilyResourceWorker_Versioned
(
    FamilyResourceWorkerID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, 
	AgencyID smallint NOT NULL REFERENCES dbo.stbAgency (AgencyID), 
	FamilyResourceLastName varchar(50) NOT NULL, 
	FamilyResourceFirstName varchar(50) NOT NULL, 
	FamilyResourceEmail varchar(250) NOT NULL, 
	IsDeleted bit NOT NULL, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID), 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tbFamilyResourceWorkerHistory_Versioned));

CREATE TABLE dbo.tbAdoptiveResourceHouseholdInfo_Versioned
(
    AdoptiveResourceHouseholdInfoID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, 
	StreetAddress1 varchar(100) NOT NULL, 
	StreetAddress2 varchar(100) NULL, 
	AddressCity varchar(50) NOT NULL, 
	AddressState char(2) NOT NULL, 
	AddressZipCode char(5) NOT NULL, 
	LanguagesSpoken varchar(25) NOT NULL, 
	HouseholdTypeID tinyint NOT NULL REFERENCES dbo.stbHouseholdType (HouseholdTypeID), 
	HouseTypeID tinyint NOT NULL REFERENCES dbo.stbHouseType (HouseTypeID), 
	NumChildrenInHome tinyint NOT NULL, 
	RacialBackground varchar(25) NOT NULL, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID), 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tbAdoptiveResourceHouseholdInfoHistory_Versioned));

 CREATE TABLE  dbo.tbAdoptiveResourcePlacementPreferences_Versioned
(
    AdoptiveResourcePlacementPreferencesID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, 
	RacialBackground varchar(25) NOT NULL, 
	MaxLegalRiskID tinyint NOT NULL REFERENCES dbo.stbLegalRisk (LegalRiskID), 
	MaxNeedsLevelID tinyint NOT NULL REFERENCES dbo.stbNeedsLevel (NeedsLevelID), 
	Genders varchar(10) NOT NULL, 
	MinAge tinyint NOT NULL, 
	MaxAge tinyint NOT NULL, 
	ChildCapacityPlacementNum tinyint NOT NULL, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID), 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE =  dbo.tbAdoptiveResourcePlacementPreferencesHistory_Versioned));

 CREATE TABLE dbo.tbAdoptiveResource_Versioned
(
    AdoptiveResourceID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, 
	AdoptiveResourceName varchar(200) NOT NULL, 
	FamilyResourceWorkerID int NOT NULL REFERENCES dbo.tbFamilyResourceWorker_Versioned (FamilyResourceWorkerID), 
	LicenseNumber varchar(50) NOT NULL, 
	LicenseExpirationDate date NOT NULL, 
	HomestudyAttachmentPath varchar(max) NOT NULL, 
	AdoptiveResourcePhotoPath varchar(max) NOT NULL, 
	FamilyMatchUploadConsentPath varchar(max) NOT NULL, 
	AdoptiveResourcePlacementPreferencesID int NULL REFERENCES dbo.tbAdoptiveResourcePlacementPreferences_Versioned (AdoptiveResourcePlacementPreferencesID), 
	AdoptiveResourceHouseholdInfoID int NULL REFERENCES dbo.tbAdoptiveResourceHouseholdInfo_Versioned (AdoptiveResourceHouseholdInfoID), 
	IsDeleted bit NOT NULL, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID), 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tbAdoptiveResourceHistory_Versioned));

CREATE TABLE dbo.tbUserAccessLog (
	UserAccessLogID bigint IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID),
	UserAccessTypeID tinyint NOT NULL REFERENCES dbo.stbUserAccessType (UserAccessTypeID), 
	AdoptiveResourceID int NULL REFERENCES dbo.tbAdoptiveResource_Versioned (AdoptiveResourceID), 
	AccessActivityDateTime datetime2 NOT NULL
); 

 CREATE TABLE dbo.tbFamilyMatchEmailAlerts_Versioned
(
    FamilyMatchAlertID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	EmailAlertRequestName varchar(100) NOT NULL, 
	AdoptiveResourceName varchar(200) NULL, 
	FamilyResourceWorkerID int NULL REFERENCES dbo.tbFamilyResourceWorker_Versioned (FamilyResourceWorkerID), 
	FamilyResourceWorkerAgencyID smallint NULL REFERENCES dbo.stbAgency (AgencyID), 
	AddressState char(2) NULL, 
	AddressZipCode char(5) NULL, 
	IncludeHouseholdLanguages varchar(25) NULL, 
	HouseholdTypeID tinyint NULL, 
	HouseTypeID tinyint NULL, 
	NumChildrenInHome tinyint NULL, 
	IncludeHouseholdRacialBackgrounds varchar(25) NULL, 
	IncludePlacementRacialBackgrounds varchar(25) NULL, 
	LegalRiskID tinyint NULL REFERENCES dbo.stbLegalRisk (LegalRiskID), 
	NeedsLevelID tinyint NULL REFERENCES dbo.stbNeedsLevel (NeedsLevelID), 
	IncludePlacementGenders varchar(10) NULL, 
	MinAge tinyint NULL, 
	MaxAge tinyint NULL, 
	ChildCapacityPlacementNum tinyint NULL, 
	IsActive bit NOT NULL, 
	UserID int NOT NULL REFERENCES dbo.tbUser_Versioned (UserID), 
    RecordStartDateTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    RecordEndDateTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME (RecordStartDateTime, RecordEndDateTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.tbFamilyMatchEmailAlertsHistory_Versioned));

--Static table data population 
INSERT INTO dbo.stbAgency (Agency) 
VALUES ('Office 2'), ('Office 1'), ('Outside Agency 1'), ('Outside Agency 2'); 

INSERT INTO dbo.stbGender (Gender) 
VALUES ('Cisgender Male'), ('Cisgender Female'), ('Transgender Female'), ('Transgender Male'); 

INSERT INTO dbo.stbHouseholdType (HouseholdType)
VALUES ('Single female'), ('Single male'), ('Heterosexual couple'), ('Same-sex couple (male)'), ('Same-sex couple (female)'); 

INSERT INTO dbo.stbHouseType (HouseType) 
VALUES ('1 bed apt.'), ('2 bed apt.'), ('3 bed apt.'), ('4 bed apt.'), ('5+ bed apt.'), ('1 bed house'), ('2 bed house'), ('3 bed house'), ('4 bed house'), ('5+ bed house'); 

INSERT INTO stbLanguage (Language) 
VALUES ('English'), ('Spanish'), ('Portuguese'), ('ASL'), ('French'), ('Hatian Creole'), ('Mandarin'), ('Arabic'); 

INSERT INTO dbo.stbLegalRisk (LegalRisk) 
VALUES ('Legally free'), ('Low legal risk'), ('Moderate legal risk'), ('High legal risk'); 

INSERT INTO stbNeedsLevel (NeedsLevel) 
VALUES ('Minimum need'), ('Moderate need'), ('High need'); 

INSERT INTO stbRacialBackground (RacialBackground)
VALUES ('White'), ('Hispanic/Latino'), ('African-American'), ('African'), ('Asian'), ('Hawaiian/Pacific Islander'), ('Native American'), ('Middle Eastern'), ('Multiracial'), ('Other'); 

INSERT INTO stbRole (Role)
VALUES ('Adoptions Manager'), ('Adoptions Supervisor'), ('Family Resource Supervisor'), ('Family Resource Worker'), ('Adoptions Worker'); 

INSERT INTO stbUserAccessType (UserAccessType) 
VALUES ('Login'), ('Adoptive Resource Profile'); 
