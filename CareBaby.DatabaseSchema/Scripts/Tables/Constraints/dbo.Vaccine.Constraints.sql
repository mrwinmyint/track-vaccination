IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Vaccine]') AND name = N'PK_Vaccine')
BEGIN
	ALTER TABLE [dbo].[Vaccine]
	ADD CONSTRAINT [PK_Vaccine] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_Vaccine]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_Vaccine_Code')
BEGIN
	CREATE INDEX [IX_Vaccine_Code] ON [dbo].[Vaccine]
	(
		[Code] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_Vaccine_Code'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_Vaccine_Name')
BEGIN
	CREATE INDEX [IX_Vaccine_Name] ON [dbo].[Vaccine]
	(
		[Name] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_Vaccine_Name'
END 
GO 


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_Vaccine_IsActive')
BEGIN
	CREATE INDEX [IX_Vaccine_IsActive] ON [dbo].[Vaccine]
	(
		[IsActive] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_Vaccine_IsActive'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_Vaccine_IsDeleted')
BEGIN
	CREATE INDEX [IX_Vaccine_IsDeleted] ON [dbo].[Vaccine]
	(
		[IsDeleted] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_Vaccine_IsDeleted'
END 
GO 


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Vaccine_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[Vaccine] ADD CONSTRAINT [DF_Vaccine_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_Vaccine_Created]'
END
GO
