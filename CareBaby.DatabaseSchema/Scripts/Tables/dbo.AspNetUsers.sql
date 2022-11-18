/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[LockoutEnd] [datetimeoffset] NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

-- drop AspNetUsers_changelog table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers_changelog]') AND type in (N'U'))
BEGIN
	DROP TABLE [AspNetUsers_changelog]
	print 'Dropped [AspNetUsers_changelog] table ...'
END
GO

IF OBJECT_ID ('tr_AspNetUsers_modified', 'TR') IS NOT NULL
begin
   DROP TRIGGER tr_AspNetUsers_modified;
   print 'Dropped trigger tr_AspNetUsers_modified'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'AspNetUsers'))
BEGIN
	ALTER TABLE [AspNetUsers] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table AspNetUsers';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LockoutEndDateUtc' 
	AND Object_ID = Object_ID(N'AspNetUsers'))
BEGIN
	ALTER TABLE [AspNetUsers] DROP COLUMN [LockoutEndDateUtc];
	PRINT 'Dropped column LockoutEndDateUtc in table AspNetUsers';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LockoutEnd' 
	AND Object_ID = Object_ID(N'AspNetUsers'))
BEGIN
	ALTER TABLE [AspNetUsers] ALTER COLUMN [LockoutEnd] [datetimeoffset] NULL;
	PRINT 'Alter column LockoutEnd in table AspNetUsers';
END
GO