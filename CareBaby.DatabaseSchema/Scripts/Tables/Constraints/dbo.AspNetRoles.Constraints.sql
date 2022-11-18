IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoles]') AND name = N'PK_AspNetRoles')
BEGIN
	ALTER TABLE [dbo].[AspNetRoles]
	ADD CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_AspNetRoles]'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_AspNetUserRoles_AspNetRoles_RoleId]'))
BEGIN
	ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId]) 
	REFERENCES [dbo].[AspNetRoles] ([Id]) 
	PRINT 'Added constraint [FK_AspNetUserRoles_AspNetRoles_RoleId]'
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.INDEXES WHERE name = 'IX_AspNetRoles_Name')
BEGIN
	CREATE INDEX [IX_AspNetRoles_Name] ON [dbo].[AspNetRoles]
	(
		[Name] ASC 
	) 
	WITH (FILLFACTOR = 90,  PAD_INDEX = OFF,  ALLOW_PAGE_LOCKS = OFF,  ALLOW_ROW_LOCKS = OFF,  STATISTICS_NORECOMPUTE = OFF,  DROP_EXISTING = OFF )  ON [PRIMARY]
	PRINT 'Created index IX_AspNetRoles_Name'
END 
GO 