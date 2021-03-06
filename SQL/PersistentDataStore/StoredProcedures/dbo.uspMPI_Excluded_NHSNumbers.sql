SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Excluded_NHSNumbers]
AS


BEGIN TRY

	BEGIN TRANSACTION;


		IF OBJECT_ID('dbo.tblMPI_Excluded_NHSNumbers','U') IS NULL
		BEGIN
			CREATE TABLE dbo.tblMPI_Excluded_NHSNumbers(
			NHSNumber VARCHAR(10) NOT NULL,
			ExclusionReason VARCHAR(1000)
			)

			CREATE NONCLUSTERED INDEX idx_tblMPI_Excluded_NHSNumbers ON dbo.tblMPI_Excluded_NHSNumbers(NHSNumber)
		END
		ELSE
		BEGIN
			TRUNCATE TABLE dbo.tblMPI_Excluded_NHSNumbers
		END


		--==============================
		-- Duplicated patients 
		--==============================
		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P1_NHS_Number] AS NHSNumber , 'Duplicated Patient (ADA)' ExclusionReason
		FROM [dbo].[tblADA_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P1_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.P1_NHS_Number = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P2_NHS_Number] AS NHSNumber , 'Duplicated Patient (ADA)' ExclusionReason
		FROM [dbo].[tblADA_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P2_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[P2_NHS_Number] = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P1_NHS_Number] AS NHSNumber , 'Duplicated Patient (CNC)' ExclusionReason
		FROM [dbo].[tblCNC_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P1_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.P1_NHS_Number = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P2_NHS_Number] AS NHSNumber , 'Duplicated Patient (CNC)' ExclusionReason
		FROM [dbo].[tblCNC_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P2_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.P2_NHS_Number = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P1_NHS_Number] AS NHSNumber , 'Duplicated Patient (CNS)' ExclusionReason
		FROM [dbo].[tblCNS_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P1_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.P1_NHS_Number = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [P2_NHS_Number] AS NHSNumber , 'Duplicated Patient (CNS)' ExclusionReason
		FROM [dbo].[tblCNS_DQ_Issues_DuplicatedPatients] a
		WHERE ISNULL([P2_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[P2_NHS_Number] = b.NHSNumber)

		--==============================
		-- Mismatch NHSNumber 
		--==============================
		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [CH_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (ADA, CNC)' ExclusionReason
		FROM [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber] a
		WHERE ISNULL([CH_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[CH_NHS_Number] = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [ada_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (ADA, CNC)' ExclusionReason
		FROM [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber] a
		WHERE ISNULL([ada_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[ada_NHS_Number] = b.NHSNumber COLLATE SQL_Latin1_General_CP1_CI_AS)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [MH_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (ADA, CNS)' ExclusionReason
		FROM [dbo].[tblADA_CNS_DQ_Issues_MismatMH_NHSNumber] a
		WHERE ISNULL([MH_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[MH_NHS_Number] = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [ada_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (ADA, CNS)' ExclusionReason
		FROM [dbo].[tblADA_CNS_DQ_Issues_MismatMH_NHSNumber] a
		WHERE ISNULL([ada_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[ada_NHS_Number] = b.NHSNumber COLLATE SQL_Latin1_General_CP1_CI_AS)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [CH_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (CNS, CNC)' ExclusionReason
		FROM [dbo].[tblCNS_CNC_DQ_Issues_Mismatch_NHSNumber] a
		WHERE ISNULL([CH_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[CH_NHS_Number] = b.NHSNumber)

		INSERT INTO dbo.tblMPI_Excluded_NHSNumbers
		SELECT DISTINCT [MH_NHS_Number] AS NHSNumber , 'Mismatch NHSNumber (CNS, CNC)' ExclusionReason
		FROM [dbo].[tblCNS_CNC_DQ_Issues_Mismatch_NHSNumber] a
		WHERE ISNULL([MH_NHS_Number],'') <> ''
		--AND NOT EXISTS (SELECT 1 FROM dbo.tblMPI_Excluded_NHSNumbers b WHERE a.[MH_NHS_Number] = b.NHSNumber)


	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO
