IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SettingGeneral]') AND name = N'PK_SettingGeneral')
BEGIN
	ALTER TABLE [dbo].[SettingGeneral]
	ADD CONSTRAINT [PK_SettingGeneral] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_SettingGeneral]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SettingGeneral_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[SettingGeneral] ADD CONSTRAINT [DF_SettingGeneral_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_SettingGeneral_Created]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingGeneral_Created')
BEGIN
	CREATE INDEX [IX_SettingGeneral_Created] ON [dbo].[SettingGeneral]
	(
		[Created] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingGeneral_Created'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingGeneral_CreatedById')
BEGIN
	CREATE INDEX [IX_SettingGeneral_CreatedById] ON [dbo].[SettingGeneral]
	(
		[CreatedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingGeneral_CreatedById'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingGeneral_LastModified')
BEGIN
	CREATE INDEX [IX_SettingGeneral_LastModified] ON [dbo].[SettingGeneral]
	(
		[LastModified] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingGeneral_LastModified'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingGeneral_LastModifiedById')
BEGIN
	CREATE INDEX [IX_SettingGeneral_LastModifiedById] ON [dbo].[SettingGeneral]
	(
		[LastModifiedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingGeneral_LastModifiedById'
END 
GO