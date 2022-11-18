IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DataType]') AND name = N'PK_DataType')
BEGIN
	ALTER TABLE [dbo].[DataType]
	ADD CONSTRAINT [PK_DataType] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_DataType]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingEmail_DataType]'))
BEGIN
	ALTER TABLE [dbo].[SettingEmail]  WITH CHECK ADD  CONSTRAINT [FK_SettingEmail_DataType] FOREIGN KEY([DataType])
	REFERENCES [dbo].[DataType] ([Id])
	PRINT 'Added constraint [FK_SettingEmail_DataType]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingGeneral_DataType]'))
BEGIN
	ALTER TABLE [dbo].[SettingGeneral]  WITH CHECK ADD  CONSTRAINT [FK_SettingGeneral_DataType] FOREIGN KEY([DataType])
	REFERENCES [dbo].[DataType] ([Id])
	PRINT 'Added constraint [FK_SettingGeneral_DataType]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingSecurityToken_DataType]'))
BEGIN
	ALTER TABLE [dbo].[SettingSecurityToken]  WITH CHECK ADD  CONSTRAINT [FK_SettingSecurityToken_DataType] FOREIGN KEY([DataType])
	REFERENCES [dbo].[DataType] ([Id])
	PRINT 'Added constraint [FK_SettingSecurityToken_DataType]'
END
GO


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_DataType_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[DataType] ADD CONSTRAINT [DF_DataType_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_DataType_Created]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_DataType_Created')
BEGIN
	CREATE INDEX [IX_DataType_Created] ON [dbo].[DataType]
	(
		[Created] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_DataType_Created'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_DataType_CreatedById')
BEGIN
	CREATE INDEX [IX_DataType_CreatedById] ON [dbo].[DataType]
	(
		[CreatedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_DataType_CreatedById'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_DataType_LastModified')
BEGIN
	CREATE INDEX [IX_DataType_LastModified] ON [dbo].[DataType]
	(
		[LastModified] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_DataType_LastModified'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_DataType_LastModifiedById')
BEGIN
	CREATE INDEX [IX_DataType_LastModifiedById] ON [dbo].[DataType]
	(
		[LastModifiedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_DataType_LastModifiedById'
END 
GO