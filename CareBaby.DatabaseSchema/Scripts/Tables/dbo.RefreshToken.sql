/****** Object:  Table [dbo].[RefreshToken]    Script Date: 13/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshToken]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RefreshToken](
	[Id] [uniqueidentifier] NOT NULL,
	[JwtId] [nvarchar](128) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IsUsed] [bit] NOT NULL,
	[IsRevoked] [bit] NOT NULL,
	[AddedDate] [DateTimeOffset] NOT NULL,
	[ExpiryDate] [DateTimeOffset] NULL,
	[Token] [nvarchar](256) NULL,
	[RoleName] [nvarchar](256) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_RefreshToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

if not exists(select * from sys.columns where Name = N'RoleName' and Object_ID = Object_ID(N'RefreshToken'))
begin
	exec('alter table [RefreshToken] add [RoleName] [nvarchar](256) NULL')
	print 'column [RoleName] added to table RefreshToken ...'
end
go