/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Discriminator] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

-- drop AspNetRoles_changelog table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoles_changelog]') AND type in (N'U'))
BEGIN
	DROP TABLE [AspNetRoles_changelog]
	print 'Dropped [AspNetRoles_changelog] table ...'
END
GO

IF OBJECT_ID ('tr_AspNetRoles_modified', 'TR') IS NOT NULL
begin
   DROP TRIGGER tr_AspNetRoles_modified;
   print 'Dropped trigger tr_AspNetRoles_modified'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'AspNetRoles'))
BEGIN
	ALTER TABLE [AspNetRoles] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table AspNetRoles';
END
GO

if not exists(select * from sys.columns where Name = N'Discriminator' and Object_ID = Object_ID(N'AspNetRoles'))
begin
	exec('alter table [AspNetRoles] add [Discriminator] [nvarchar](max) NULL')
	print 'column [Discriminator] added to table AspNetRoles ...'
end
go