IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers]') AND name = N'PK_AspNetUsers')
BEGIN
	ALTER TABLE [dbo].[AspNetUsers]
	ADD CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_AspNetUsers]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_AspNetUserRoles_AspNetUsers_UserId]'))
BEGIN
	ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId]) 
	REFERENCES [dbo].[AspNetUsers] ([Id]) 
	PRINT 'Added constraint [FK_AspNetUserRoles_AspNetUsers_UserId]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_Users_AspNetUsers_UserId_Id]'))
BEGIN
	ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_Users_AspNetUsers_UserId_Id] FOREIGN KEY([Id])
	REFERENCES [dbo].[AspNetUsers] ([Id])
	PRINT 'Added constraint [FK_Users_AspNetUsers_UserId_Id]'
END
GO

IF EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_Users_AspNetUsers_AspNetUserId_Id]'))
BEGIN
	ALTER TABLE [User] DROP CONSTRAINT [FK_Users_AspNetUsers_AspNetUserId_Id]
	PRINT 'Dropped constraint [FK_Users_AspNetUsers_AspNetUserId_Id]'
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_AspNetUsers_Email')
BEGIN
	CREATE INDEX [IX_AspNetUsers_Email] ON [dbo].[AspNetUsers]
	(
		[Email] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_AspNetUsers_Email'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_AspNetUsers_EmailConfirmed')
BEGIN
	CREATE INDEX [IX_AspNetUsers_EmailConfirmed] ON [dbo].[AspNetUsers]
	(
		[EmailConfirmed] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_AspNetUsers_EmailConfirmed'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_AspNetUsers_UserName')
BEGIN
	CREATE INDEX [IX_AspNetUsers_UserName] ON [dbo].[AspNetUsers]
	(
		[UserName] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_AspNetUsers_UserName'
END 
GO 

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_RefreshToken_AspNetUsers_UserId]'))
BEGIN
	ALTER TABLE [dbo].[RefreshToken] WITH CHECK ADD CONSTRAINT [FK_RefreshToken_AspNetUsers_UserId] FOREIGN KEY([UserId]) 
	REFERENCES [dbo].[AspNetUsers] ([Id]) 
	PRINT 'Added constraint [FK_RefreshToken_AspNetUsers_UserId]'
END
GO