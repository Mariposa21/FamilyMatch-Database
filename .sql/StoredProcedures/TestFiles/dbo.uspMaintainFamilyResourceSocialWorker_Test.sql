/*
	Mariposa21
	dbo.uspMaintainFamilyResourceSocialWorker test
*/
USE [FamilyMatch]

GO

DECLARE @iUserID int = 1, 
		@iFamilyResourceWorkerID int = 0, 
		@iAgencyID smallint = 1, 
		@vcFamilyResourceLastName varchar(50) = 'Sarah', 
		@vcFamilyResourceFirstName varchar(50) = 'L', 
		@vcFamilyResourceEmail varchar(250) = 'test3@email.com', 
		@bIsRemove bit = 0,
		@iReturnedFamilyResourceWorkerID int,
		@vcErrorMessage varchar(4000) = NULL

EXEC dbo.uspMaintainFamilyResourceSocialWorker
		@iUserID = @iUserID, 
		@iFamilyResourceWorkerID = @iFamilyResourceworkerID, 
		@iAgencyID = @iAgencyID, 
		@vcFamilyResourceLastName = @vcFamilyResourceLastName, 
		@vcFamilyResourceFirstName = @vcFamilyResourceFirstName, 
		@vcFamilyResourceEmail = @vcFamilyResourceEmail, 
		@bIsRemove = @bIsRemove,
		@iReturnedFamilyResourceWorkerID = @iReturnedFamilyResourceWorkerID OUTPUT,
		@vcErrorMessage = @vcErrorMessage OUTPUT
	
SELECT @iReturnedFamilyResourceWorkerID
SELECT @vcErrorMessage

SELECT * 
FROM dbo.tbFamilyResourceWorker_Versioned
FOR SYSTEM_TIME ALL
WHERE FamilyResourceWorkerID = @iReturnedFamilyResourceWorkerID



