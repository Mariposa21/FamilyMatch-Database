USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspMaintainFamilyResourceSocialWorker
	Purpose: Maintains Family Resource Social Worker list. 

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created.  
*/

CREATE OR ALTER PROCEDURE dbo.uspMaintainFamilyResourceSocialWorker
	@iUserID int, 
	@iFamilyResourceWorkerID int = 0, 
	@iAgencyID smallint, 
	@vcFamilyResourceLastName varchar(50), 
	@vcFamilyResourceFirstName varchar(50), 
	@vcFamilyResourceEmail varchar(250), 
	@bIsRemove bit = 0,
	@iReturnedFamilyResourceWorkerID int OUTPUT,
	@vcErrorMessage varchar(4000) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iErrorID int; 
	SET @iReturnedFamilyResourceWorkerID = @@IDENTITY; 

	BEGIN TRY
		IF (@iFamilyResourceWorkerID = 0)
		BEGIN
		   INSERT INTO dbo.tbFamilyResourceWorker_Versioned (AgencyID, FamilyResourceLastName, 
													FamilyResourceFirstName, FamilyResourceEmail, IsDeleted, 
													UserID)
		   VALUES (@iAgencyID, @vcFamilyResourceLastName, @vcFamilyResourceFirstName, @vcFamilyResourceEmail, @bIsRemove, 
				   @iUserID); 
		   SELECT @iReturnedFamilyResourceWorkerID = @@IDENTITY, @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to create new resource worker.', 1
		   END
		END
		ELSE --Should be an update
		BEGIN 

		   UPDATE FRW
				SET FRW.FamilyResourceLastName = @vcFamilyResourceLastName, 
					FRW.FamilyResourceFirstName = @vcFamilyResourceFirstName, 
					FRW.FamilyResourceEmail = @vcFamilyResourceEmail, 
					FRW.IsDeleted = @bIsRemove,
					FRW.UserID = @iUserID
		   FROM dbo.tbFamilyResourceWorker_Versioned FRW
		   WHERE FRW.FamilyResourceWorkerID = @iFamilyResourceWorkerID; 
		   SET @iErrorID = @@ERROR; 

		   IF (@iErrorID <> 0)
		   BEGIN
			;THROW 50001, 'Error: Unable to update existing resource worker.', 1
		   END

		END
	END TRY
	BEGIN CATCH 
		    SELECT @vcErrorMessage = ERROR_MESSAGE(); 
            RETURN 1; 
	END CATCH 

	RETURN 0; 

END
GO
