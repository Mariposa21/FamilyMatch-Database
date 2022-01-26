/*
	Mariposa21
	dbo.uspViewFamilyResourceWorkers test
*/
USE [FamilyMatch]

GO

DECLARE  @iFamilyResourceWorkerID int = 1, 
		 @bIsDeleted bit = 0

EXEC dbo.uspViewFamilyResourceWorkers
	@iFamilyResourceWorkerID = @iFamilyResourceWorkerID,
	@bIncludeDeactivated = @bIsDeleted




