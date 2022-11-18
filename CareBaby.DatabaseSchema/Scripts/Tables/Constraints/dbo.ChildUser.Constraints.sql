IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ChildUser]') AND name = N'PK_ChildUser')
BEGIN
	ALTER TABLE [dbo].[ChildUser]
	ADD CONSTRAINT [PK_ChildUser] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_ChildUser]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ChildUser_FirstName')
BEGIN
	CREATE INDEX [IX_ChildUser_FirstName] ON [dbo].[ChildUser]
	(
		[FirstName] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ChildUser_FirstName'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ChildUser_LastName')
BEGIN
	CREATE INDEX [IX_ChildUser_LastName] ON [dbo].[ChildUser]
	(
		[LastName] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ChildUser_LastName'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ChildUser_DoB')
BEGIN
	CREATE INDEX [IX_ChildUser_DoB] ON [dbo].[ChildUser]
	(
		[DOB] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ChildUser_DoB'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ChildUser_IsActive')
BEGIN
	CREATE INDEX [IX_ChildUser_IsActive] ON [dbo].[ChildUser]
	(
		[IsActive] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ChildUser_IsActive'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_ChildUser_IsDeleted')
BEGIN
	CREATE INDEX [IX_ChildUser_IsDeleted] ON [dbo].[ChildUser]
	(
		[IsDeleted] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_ChildUser_IsDeleted'
END 
GO 


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ChildUser_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[ChildUser] ADD CONSTRAINT [DF_ChildUser_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_ChildUser_Created]'
END
GO
