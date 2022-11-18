IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomEntity]') AND name = N'PK_CustomEntity')
BEGIN
	ALTER TABLE [dbo].[CustomEntity]
	ADD CONSTRAINT [PK_CustomEntity] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_CustomEntity]'
END
GO

ALTER TABLE [dbo].[ActionLog] DROP CONSTRAINT IF EXISTS FK_ActionLog_CustomEntity;
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_ActionLog_CustomEntity_CustomEntityId]'))
BEGIN
	ALTER TABLE [dbo].[ActionLog] WITH CHECK ADD CONSTRAINT [FK_ActionLog_CustomEntity_CustomEntityId] FOREIGN KEY([CustomEntityId]) 
	REFERENCES [dbo].[CustomEntity] ([Id]) 
	PRINT 'Added constraint [FK_ActionLog_CustomEntity_CustomEntityId]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CustomEntity_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[CustomEntity] ADD CONSTRAINT [DF_CustomEntity_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_CustomEntity_Created]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_Created')
BEGIN
	CREATE INDEX [IX_CustomEntity_Created] ON [dbo].[CustomEntity]
	(
		[Created] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_Created'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_CreatedById')
BEGIN
	CREATE INDEX [IX_CustomEntity_CreatedById] ON [dbo].[CustomEntity]
	(
		[CreatedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_CreatedById'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_LastModified')
BEGIN
	CREATE INDEX [IX_CustomEntity_LastModified] ON [dbo].[CustomEntity]
	(
		[LastModified] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_LastModified'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_LastModifiedById')
BEGIN
	CREATE INDEX [IX_CustomEntity_LastModifiedById] ON [dbo].[CustomEntity]
	(
		[LastModifiedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_LastModifiedById'
END 
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CustomEntity_IsSystemEntity]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[CustomEntity] ADD CONSTRAINT [DF_CustomEntity_IsSystemEntity] DEFAULT (1) FOR [IsSystemEntity]
	PRINT 'Added constraint [DF_CustomEntity_IsSystemEntity]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CustomEntity_IsStrictEntity]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[CustomEntity] ADD CONSTRAINT [DF_CustomEntity_IsStrictEntity] DEFAULT (0) FOR [IsStrictEntity]
	PRINT 'Added constraint [DF_CustomEntity_IsStrictEntity]'
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_IsSystemEntity')
BEGIN
	CREATE INDEX [IX_CustomEntity_IsSystemEntity] ON [dbo].[CustomEntity]
	(
		[IsSystemEntity] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_IsSystemEntity'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_CustomEntity_IsStrictEntity')
BEGIN
	CREATE INDEX [IX_CustomEntity_IsStrictEntity] ON [dbo].[CustomEntity]
	(
		[IsStrictEntity] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_CustomEntity_IsStrictEntity'
END 
GO