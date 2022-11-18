/****** Object:  Table [dbo].[ChildUser]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChildUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ChildUser](
	[Id] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](256) NULL,
	[LastName] [nvarchar](256) NULL,
	[Gender] [char](1) NULL,
	[DOB] [datetimeoffset](7) NULL,
	[MiddleNames] [nvarchar](100) NULL,
	[FirstNameAndLastName]  AS ((coalesce([FirstName],'')+' ')+coalesce([LastName],'')) PERSISTED,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_ChildUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
