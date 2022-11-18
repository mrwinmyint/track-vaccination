IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SettingSecurityToken]') AND name = N'PK_SettingSecurityToken')
BEGIN
	ALTER TABLE [dbo].[SettingSecurityToken]
	ADD CONSTRAINT [PK_SettingSecurityToken] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_SettingSecurityToken]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SettingSecurityToken_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[SettingSecurityToken] ADD CONSTRAINT [DF_SettingSecurityToken_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_SettingSecurityToken_Created]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingSecurityToken_Created')
BEGIN
	CREATE INDEX [IX_SettingSecurityToken_Created] ON [dbo].[SettingSecurityToken]
	(
		[Created] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingSecurityToken_Created'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingSecurityToken_CreatedById')
BEGIN
	CREATE INDEX [IX_SettingSecurityToken_CreatedById] ON [dbo].[SettingSecurityToken]
	(
		[CreatedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingSecurityToken_CreatedById'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingSecurityToken_LastModified')
BEGIN
	CREATE INDEX [IX_SettingSecurityToken_LastModified] ON [dbo].[SettingSecurityToken]
	(
		[LastModified] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingSecurityToken_LastModified'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_SettingSecurityToken_LastModifiedById')
BEGIN
	CREATE INDEX [IX_SettingSecurityToken_LastModifiedById] ON [dbo].[SettingSecurityToken]
	(
		[LastModifiedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_SettingSecurityToken_LastModifiedById'
END 
GO