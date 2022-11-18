/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserClaims]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

-- drop AspNetUserClaims_changelog table
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserClaims_changelog]') AND type in (N'U'))
BEGIN
	DROP TABLE [AspNetUserClaims_changelog]
	print 'Dropped [AspNetUserClaims_changelog] table ...'
END
GO

IF OBJECT_ID ('tr_AspNetUserClaims_modified', 'TR') IS NOT NULL
begin
   DROP TRIGGER tr_AspNetUserClaims_modified;
   print 'Dropped trigger tr_AspNetUserClaims_modified'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'UserId' 
	AND Object_ID = Object_ID(N'AspNetUserClaims'))
BEGIN
	ALTER TABLE [AspNetUserClaims] ALTER COLUMN [UserId] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column UserId in table AspNetUserClaims';
END
GO