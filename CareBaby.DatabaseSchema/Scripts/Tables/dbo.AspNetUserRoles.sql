/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserRoles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

-- drop AspNetUserRoles_changelog table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserRoles_changelog]') AND type in (N'U'))
BEGIN
	DROP TABLE [AspNetUserRoles_changelog]
	print 'Dropped [AspNetUserRoles_changelog] table ...'
END
GO

IF OBJECT_ID ('tr_AspNetUserRoles_modified', 'TR') IS NOT NULL
begin
   DROP TRIGGER tr_AspNetUserRoles_modified;
   print 'Dropped trigger tr_AspNetUserRoles_modified'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'RoleId' 
	AND Object_ID = Object_ID(N'AspNetUserRoles'))
BEGIN
	ALTER TABLE [AspNetUserRoles] ALTER COLUMN [RoleId] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column RoleId in table AspNetUserRoles';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'UserId' 
	AND Object_ID = Object_ID(N'AspNetUserRoles'))
BEGIN
	ALTER TABLE [AspNetUserRoles] ALTER COLUMN [UserId] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column UserId in table AspNetUserRoles';
END
GO