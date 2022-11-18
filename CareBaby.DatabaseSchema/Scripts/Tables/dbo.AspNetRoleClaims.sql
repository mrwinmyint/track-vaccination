/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoleClaims]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

-- drop AspNetRoleClaims_changelog table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoleClaims_changelog]') AND type in (N'U'))
BEGIN
	DROP TABLE [AspNetRoleClaims_changelog]
	print 'Dropped [AspNetRoleClaims_changelog] table ...'
END
GO

IF OBJECT_ID ('tr_AspNetRoleClaims_modified', 'TR') IS NOT NULL
begin
   DROP TRIGGER tr_AspNetRoleClaims_modified;
   print 'Dropped trigger tr_AspNetRoleClaims_modified'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'RoleId' 
	AND Object_ID = Object_ID(N'AspNetRoleClaims'))
BEGIN
	ALTER TABLE [AspNetRoleClaims] ALTER COLUMN [RoleId] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column RoleId in table AspNetRoleClaims';
END
GO