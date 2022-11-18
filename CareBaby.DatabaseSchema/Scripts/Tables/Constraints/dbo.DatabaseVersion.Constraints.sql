IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseVersion]') AND name = N'PK_DatabaseVersion')
BEGIN
	ALTER TABLE [dbo].[DatabaseVersion]
	ADD CONSTRAINT [PK_DatabaseVersion] PRIMARY KEY CLUSTERED(Id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF ) ON [PRIMARY]
	PRINT 'Created index [PK_DatabaseVersion]'
END
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_DatabaseVersion_CreatedDate]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[DatabaseVersion] ADD CONSTRAINT [DF_DatabaseVersion_CreatedDate] DEFAULT (sysdatetimeoffset()) FOR [CreatedDate]
	PRINT 'Created index [DF_DatabaseVersion_CreatedDate]'
END
GO