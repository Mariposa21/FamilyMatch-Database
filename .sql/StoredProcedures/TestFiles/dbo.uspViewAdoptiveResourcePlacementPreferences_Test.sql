/*
	Mariposa21
	dbo.uspViewAdoptiveResourcePlacementPreferences_Test
*/
USE [FamilyMatch]

GO

DECLARE  @iAdoptiveResourcePlacementPreferencesID int = 1

EXEC dbo.uspViewAdoptiveResourcePlacementPreferences
	@iAdoptiveResourcePlacementPreferencesID = @iAdoptiveResourcePlacementPreferencesID


