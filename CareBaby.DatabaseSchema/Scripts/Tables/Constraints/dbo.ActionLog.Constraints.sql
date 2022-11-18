IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ActionLog]') AND name = N'PK_ActionLog')
BEGIN
	ALTER TABLE [dbo].[ActionLog]
	ADD CONSTRAINT [PK_ActionLog] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_ActionLog]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ActionLog_IsActive]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[ActionLog] ADD CONSTRAINT [DF_ActionLog_IsActive] DEFAULT 'TRUE' FOR [IsActive]
	PRINT 'Added constraint [DF_ActionLog_IsActive]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ActionLog_IsDeleted]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[ActionLog] ADD CONSTRAINT [DF_ActionLog_IsDeleted] DEFAULT 'FALSE' FOR [IsDeleted]
	PRINT 'Added constraint [DF_ActionLog_IsDeleted]'
END
GO

DROP INDEX IF EXISTS [IX_ActionLog_EntityId] ON [dbo].[ActionLog]
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ActionLog_CustomEntityId')
BEGIN
	CREATE INDEX [IX_ActionLog_CustomEntityId] ON [dbo].[ActionLog]
	(
		[CustomEntityId] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ActionLog_CustomEntityId'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ActionLog_ActionTypeId')
BEGIN
	CREATE INDEX [IX_ActionLog_ActionTypeId] ON [dbo].[ActionLog]
	(
		[ActionTypeId] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ActionLog_ActionTypeId'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ActionLog_ActionedBy')
BEGIN
	CREATE INDEX [IX_ActionLog_ActionedBy] ON [dbo].[ActionLog]
	(
		[ActionedBy] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ActionLog_ActionedBy'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ActionLog_ActionDateTime')
BEGIN
	CREATE INDEX [IX_ActionLog_ActionDateTime] ON [dbo].[ActionLog]
	(
		[ActionDateTime] DESC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ActionLog_ActionDateTime'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ActionLog_EntityUniqueId')
BEGIN
	CREATE INDEX [IX_ActionLog_EntityUniqueId] ON [dbo].[ActionLog]
	(
		[EntityUniqueId] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ActionLog_EntityUniqueId'
END 
GO 

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ActionLog_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[ActionLog] ADD CONSTRAINT [DF_ActionLog_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_ActionLog_Created]'
END
GO