IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[VaccineType]') AND name = N'PK_VaccineType')
BEGIN
	ALTER TABLE [dbo].[VaccineType]
	ADD CONSTRAINT [PK_VaccineType] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_VaccineType]'
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_VaccineType_Name')
BEGIN
	CREATE INDEX [IX_VaccineType_Name] ON [dbo].[VaccineType]
	(
		[Name] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_VaccineType_Name'
END 
GO 


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_VaccineType_IsActive')
BEGIN
	CREATE INDEX [IX_VaccineType_IsActive] ON [dbo].[VaccineType]
	(
		[IsActive] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_VaccineType_IsActive'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_VaccineType_IsDeleted')
BEGIN
	CREATE INDEX [IX_VaccineType_IsDeleted] ON [dbo].[VaccineType]
	(
		[IsDeleted] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_VaccineType_IsDeleted'
END 
GO 


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VaccineType_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[VaccineType] ADD CONSTRAINT [DF_VaccineType_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_VaccineType_Created]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_Vaccine_VaccineType_VaccineTypeId]'))
BEGIN
	ALTER TABLE [dbo].[Vaccine]  WITH CHECK ADD  CONSTRAINT [FK_Vaccine_VaccineType_VaccineTypeId] FOREIGN KEY([VaccineTypeId])
	REFERENCES [dbo].[VaccineType] ([Id])
	PRINT 'Added constraint [FK_Vaccine_VaccineType_VaccineTypeId]'
END
GO