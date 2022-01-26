/*
	Mariposa21
	dbo.uspViewAdoptiveResourceHouseholdInfo test
*/
USE [FamilyMatch]

GO

DECLARE  @iAdoptiveResourceHouseholdInfoID int = 1

EXEC dbo.uspViewAdoptiveResourceHouseholdInfo
	@iAdoptiveResourceHouseholdInfoID = @iAdoptiveResourceHouseholdInfoID


