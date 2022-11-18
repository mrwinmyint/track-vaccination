IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = N'PK_User')
BEGIN
	ALTER TABLE [dbo].[User]
	ADD CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_User]'
END
GO
 
IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_ActionLog_User]'))
BEGIN
	ALTER TABLE [dbo].[ActionLog]  WITH CHECK ADD  CONSTRAINT [FK_ActionLog_User] FOREIGN KEY([ActionedBy])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_ActionLog_User]'
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_AspNetUsers_Id')
BEGIN
	CREATE INDEX [IX_User_AspNetUsers_Id] ON [dbo].[User]
	(
		[Id] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_AspNetUsers_Id'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_FirstName')
BEGIN
	CREATE INDEX [IX_User_FirstName] ON [dbo].[User]
	(
		[FirstName] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_FirstName'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_LastName')
BEGIN
	CREATE INDEX [IX_User_LastName] ON [dbo].[User]
	(
		[LastName] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_LastName'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_DoB')
BEGIN
	CREATE INDEX [IX_User_DoB] ON [dbo].[User]
	(
		[DOB] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_DoB'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_IsActive')
BEGIN
	CREATE INDEX [IX_User_IsActive] ON [dbo].[User]
	(
		[IsActive] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_IsActive'
END 
GO 

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_IsDeleted')
BEGIN
	CREATE INDEX [IX_User_IsDeleted] ON [dbo].[User]
	(
		[IsDeleted] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_IsDeleted'
END 
GO 


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_User_Created]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[User] ADD CONSTRAINT [DF_User_Created] DEFAULT (SYSDATETIMEOFFSET()) FOR [Created]
	PRINT 'Added constraint [DF_User_Created]'
END
GO


IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_Created')
BEGIN
	CREATE INDEX [IX_User_Created] ON [dbo].[User]
	(
		[Created] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_Created'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_CreatedById')
BEGIN
	CREATE INDEX [IX_User_CreatedById] ON [dbo].[User]
	(
		[CreatedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_CreatedById'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_LastModified')
BEGIN
	CREATE INDEX [IX_User_LastModified] ON [dbo].[User]
	(
		[LastModified] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_LastModified'
END 
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_User_LastModifiedById')
BEGIN
	CREATE INDEX [IX_User_LastModifiedById] ON [dbo].[User]
	(
		[LastModifiedById] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_User_LastModifiedById'
END 
GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_CustomEntity_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[CustomEntity]  WITH CHECK ADD  CONSTRAINT [FK_CustomEntity_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_CustomEntity_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_CustomEntity_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[CustomEntity]  WITH CHECK ADD  CONSTRAINT [FK_CustomEntity_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_CustomEntity_User_LastModifiedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_DataType_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[DataType]  WITH CHECK ADD  CONSTRAINT [FK_DataType_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_DataType_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_DataType_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[DataType]  WITH CHECK ADD  CONSTRAINT [FK_DataType_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_DataType_User_LastModifiedById]'
END
GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingEmail_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingEmail]  WITH CHECK ADD  CONSTRAINT [FK_SettingEmail_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingEmail_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingEmail_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingEmail]  WITH CHECK ADD  CONSTRAINT [FK_SettingEmail_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingEmail_User_LastModifiedById]'
END
GO



IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingSecurityToken_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingSecurityToken]  WITH CHECK ADD  CONSTRAINT [FK_SettingSecurityToken_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingSecurityToken_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingSecurityToken_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingSecurityToken]  WITH CHECK ADD  CONSTRAINT [FK_SettingSecurityToken_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingSecurityToken_User_LastModifiedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_ChildUser_User]'))
BEGIN
	ALTER TABLE [dbo].[ChildUser]  WITH CHECK ADD  CONSTRAINT [FK_ChildUser_User] FOREIGN KEY([ParentId])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_ChildUser_User]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingGeneral_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingGeneral]  WITH CHECK ADD  CONSTRAINT [FK_SettingGeneral_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingGeneral_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_SettingGeneral_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[SettingGeneral]  WITH CHECK ADD  CONSTRAINT [FK_SettingGeneral_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_SettingGeneral_User_LastModifiedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_UserAddress_User_UserId]'))
BEGIN
	ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_UserAddress_User_UserId] FOREIGN KEY([UserId])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_UserAddress_User_UserId]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_UserAddress_User_CreatedById]'))
BEGIN
	ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_UserAddress_User_CreatedById] FOREIGN KEY([CreatedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_UserAddress_User_CreatedById]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_UserAddress_User_LastModifiedById]'))
BEGIN
	ALTER TABLE [dbo].[UserAddress]  WITH CHECK ADD  CONSTRAINT [FK_UserAddress_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
	REFERENCES [dbo].[User] ([Id])
	PRINT 'Added constraint [FK_UserAddress_User_LastModifiedById]'
END
GO