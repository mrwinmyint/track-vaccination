/****** Object:  Table [dbo].[DatabaseVersion]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseVersion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DatabaseVersion](
	[Id] [uniqueidentifier] NOT NULL,
	[Version] [int] NOT NULL,
	[VersionLabel] [nvarchar](256) NULL,
	[CreatedDate] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_DatabaseVersion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_DatabaseVersion_Id]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[DatabaseVersion] ADD CONSTRAINT [DF_DatabaseVersion_Id] DEFAULT (NEWID()) FOR [Id]
	PRINT 'Added constraint [DF_DatabaseVersion_Id]'
END
GO
