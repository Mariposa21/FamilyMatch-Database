USE [FamilyMatch] 

GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.uspViewFamilyResourceWorkers
	Purpose: Returns family resource worker information.

	Version History 
	----------------------------
	#  Name	 VersionDate  Comments
	01 M21    01012022	  Created. 
*/

CREATE OR ALTER PROCEDURE dbo.uspViewFamilyResourceWorkers
	@iFamilyResourceWorkerID int = 0, 
	@bIncludeDeactivated bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtCurrentTimestampUTC datetime2 = CAST(GETUTCDATE() AS datetime2); 

	SELECT FRW.FamilyResourceWorkerID, FRW.AgencyID, FRW.FamilyResourceLastName, FRW.FamilyResourceFirstName, FRW.FamilyResourceEmail, FRW.IsDeleted, FRW.UserID
	FROM dbo.tbFamilyResourceWorker_Versioned
	FOR SYSTEM_TIME AS OF @dtCurrentTimestampUTC FRW
	WHERE CASE WHEN @bIncludeDeactivated = 0 AND FRW.IsDeleted = 0 THEN 1 
				 WHEN @bIncludeDeactivated = 1 THEN 1 
				 ELSE 0 END = 1
		AND CASE WHEN @iFamilyResourceWorkerID <> 0 AND FRW.FamilyResourceWorkerID = @iFamilyResourceWorkerID THEN 1 
			   WHEN @iFamilyResourceWorkerID = 0 THEN 1 ELSE 0 END = 1; 


END
GO
