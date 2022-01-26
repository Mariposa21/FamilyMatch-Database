# FamilyMatch Database [Created by Mariposa21 :butterfly:]
## Project Summary	
* This database allows Adoption Workers to view current Adoptive Resources looking for adoption placements.
* In this particular project scenario, Adoption Workers are forced to rely on email exchanges and networking to identify Adoptive Resources that could be potential matches for the children on their caseload currently awaiting adoption placements.
* The FamilyMatch Software Application will be a secure application allowing for Adoption and Family Resource Workers to review and maintain valid Adoptive Resources. * The creation of this application intends to improve the rate of family matching by allowing Family Resource and Adoption Workers to have access to all Adoptive Resource information that meets desired criteria. 
	* This will allow Adoption Workers to consider Adoptive Resources with whom they were previously unaware.

## Required Functionality
1.  User authentication via sign-in credentials is required. 
1.  Users are required to change their password every 90 days and during first-time login. 
1.  Adoption Supervisors/Managers can create and manage existing application users.  
1.  User logins and adoptive resource access are logged for potential system audits. 
1.  Adoption and Family Resource Workers can create and manage existing Adoptive Resource profiles. 
1.  Adoption Workers/Supervisors/Managers can create and manage existing Family Resource Workers in the Family Resource Worker list, which is used to associate a Family Resource worker with an Adoptive Resource. 
	1.  The Family Resource Worker list in the FamilyMatch application is maintained separately from FamilyMatch application users because not all Family Resource Workers associated with Adoptive Resource profiles may have valid access to the FamilyMatch application. 
1.  Users can search for and view valid Adoptive Resource profiles. 
1.  Users can create a FamilyMatch email request to notify them of any Adoptive Resources created or updated in the last week that meet a specific set of search criteria. A weekly corresponding process will send out email notifications to respective recipients.  

## Family match database script deployment order: 
1. *Create_FamilyMatchDatabaseAndTables.sql*
1. *dbo.uspQueryToHTMLTable.sql*
1. *dbo.uspCreateUserAccessLogEvent.sql*
1. *dbo.uspFindMatchingAdoptiveResourceProfiles.sql*
1. *dbo.uspMaintainAdoptiveResource.sql*
1. *dbo.uspMaintainAdoptiveResourceHouseholdInfo.sql*
1. *dbo.uspMaintainAdoptiveResourcePlacementPreferences.sql*
1. *dbo.uspMaintainFamilyMatchEmailAlerts.sql*
1. *dbo.uspMaintainFamilyResourceSocialWorker.sql*
1. *dbo.uspMaintainUser.sql*
1. *dbo.uspSendNewFamilyMatchEmailAlerts.sql*
	1. To send email alerts, requires creation of a SQL Server DB Mail Profile *FamilyMatch DB Profile*
1. *dbo.uspVerifyUserCredentials.sql*
1. *dbo.uspViewAdoptiveResourceHouseholdInfo.sql*
1. *dbo.uspViewAdoptiveResourcePlacementPreferences.sql*
1. *dbo.uspViewAdoptiveResourceProfile.sql*
1. *dbo.uspViewFamilyResourceWorkers.sql*

 

