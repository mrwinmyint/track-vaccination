/****** Object:  Table [dbo].[User]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](10) NULL,
	[FirstName] [nvarchar](256) NULL,
	[LastName] [nvarchar](256) NULL,
	[Gender] [char](1) NULL,
	[DOB] [datetimeoffset](7) NULL,
	[MiddleNames] [nvarchar](100) NULL,
	[FirstNameAndLastName]  AS ((coalesce([FirstName],'')+' ')+coalesce([LastName],'')) PERSISTED,
	[Type] [smallint] NOT NULL,	
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS (
SELECT  * 
    FROM    sys.extended_properties p
            JOIN sys.columns c ON p.major_id = c.object_id and p.minor_id = c.column_id 
    WHERE   p.major_id = OBJECT_ID('User','table')
            AND p.name = 'MS_Description'  
			AND c.name = 'Type'
)
BEGIN
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The user type to differentiate entitlements, user type can be Domestic or International. (maybe more in the future?)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Type'
END
GO


IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedBy' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [CreatedBy];
	PRINT 'Dropped column CreatedBy in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedDate' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [CreatedDate];
	PRINT 'Dropped column CreatedDate in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedBy' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [ModifiedBy];
	PRINT 'Dropped column ModifiedBy in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedDate' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [ModifiedDate];
	PRINT 'Dropped column ModifiedDate in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedReason' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [ModifiedReason];
	PRINT 'Dropped column ModifiedReason in table User';
END
GO


if not exists(select * from sys.columns where Name = N'Created' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [Created] [DateTimeOffset] NULL')
	exec('update [User] set [Created] = SYSDATETIMEOFFSET()')
	exec('alter table [User] alter column [Created] [DateTimeOffset] NOT NULL')	
	print 'column [Created] added to table User ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedById' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [CreatedById] [nvarchar](128) NULL')
	print 'column [CreatedById] added to table User ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedByName' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [CreatedByName] [nvarchar](256) NULL')
	print 'column [CreatedByName] added to table User ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModified' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [LastModified] [DateTimeOffset] NULL')
	print 'column [LastModified] added to table User ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedById' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [LastModifiedById] [nvarchar](128) NULL')
	print 'column [LastModifiedById] added to table User ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedByName' and Object_ID = Object_ID(N'User'))
begin
	exec('alter table [User] add [LastModifiedByName] [nvarchar](256) NULL')
	print 'column [LastModifiedByName] added to table User ...'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'FirstNameAndLastName' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [FirstNameAndLastName];
	PRINT 'Dropped column ModifiedReason in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedById' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] ALTER COLUMN [CreatedById] [uniqueidentifier] NULL;
	PRINT 'Alter column CreatedById in table User';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LastModifiedById' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] ALTER COLUMN [LastModifiedById] [uniqueidentifier] NULL;
	PRINT 'Alter column LastModifiedById in table User';
END
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS(
		SELECT * 
		FROM sys.columns 
		WHERE Name = N'FirstNameAndLastName' 
		AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE dbo.[User] ADD [FirstNameAndLastName] AS ((coalesce([FirstName],'')+' ')+coalesce([LastName],'')) PERSISTED;
	PRINT 'Added a computed column FirstNameAndLastName in table User';
END
GO
SET ANSI_PADDING OFF
GO

IF EXISTS (SELECT * FROM sys.foreign_keys fk WHERE fk.object_id = object_id(N'[FK_Users_AspNetUsers_AspNetUserId_Id]'))
BEGIN
	ALTER TABLE [User] DROP CONSTRAINT [FK_Users_AspNetUsers_AspNetUserId_Id]
	PRINT 'Dropped constraint [FK_Users_AspNetUsers_AspNetUserId_Id]'
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'AspNetUserId' 
	AND Object_ID = Object_ID(N'User'))
BEGIN
	ALTER TABLE [User] DROP COLUMN [AspNetUserId];
	PRINT 'Dropped column AspNetUserId in table User';
END
GO