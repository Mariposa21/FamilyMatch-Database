/*
	Mariposa21
	dbo.uspViewAdoptiveResourceProfile test
*/
USE [FamilyMatch]

GO

DECLARE  @iAdoptiveResourceID int = 1, 
		 @bIsDeleted bit = 0

EXEC dbo.uspViewAdoptiveResourceProfile
	@iAdoptiveResourceID = @iAdoptiveResourceID, 
	@bIncludeDeactivated = @bIsDeleted




