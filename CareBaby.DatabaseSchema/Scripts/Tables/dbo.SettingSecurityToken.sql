/****** Object:  Table [dbo].[SettingSecurityToken]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SettingSecurityToken]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SettingSecurityToken](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DataType] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](500) NULL,
	[IsNullable] [bit] NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_SettingSecurityToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedBy' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] DROP COLUMN [CreatedBy];
	PRINT 'Dropped column CreatedBy in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedDate' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] DROP COLUMN [CreatedDate];
	PRINT 'Dropped column CreatedDate in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedBy' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] DROP COLUMN [ModifiedBy];
	PRINT 'Dropped column ModifiedBy in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedDate' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] DROP COLUMN [ModifiedDate];
	PRINT 'Dropped column ModifiedDate in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedReason' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] DROP COLUMN [ModifiedReason];
	PRINT 'Dropped column ModifiedReason in table SettingSecurityToken';
END
GO


if not exists(select * from sys.columns where Name = N'Created' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [Created] [DateTimeOffset] NULL')
	exec('update SettingSecurityToken set [Created] = SYSDATETIMEOFFSET()')
	exec('alter table [SettingSecurityToken] alter column [Created] [DateTimeOffset] NOT NULL')	
	print 'column [Created] added to table SettingSecurityToken ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedById' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [CreatedById] [nvarchar](128) NULL')
	print 'column [CreatedById] added to table SettingSecurityToken ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedByName' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [CreatedByName] [nvarchar](256) NULL')
    exec('update SettingSecurityToken set [CreatedByName] = ''administrator''')
	print 'column [CreatedByName] added to table SettingSecurityToken ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModified' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [LastModified] [DateTimeOffset] NULL')
	print 'column [LastModified] added to table SettingSecurityToken ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedById' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [LastModifiedById] [nvarchar](128) NULL')
	print 'column [LastModifiedById] added to table SettingSecurityToken ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedByName' and Object_ID = Object_ID(N'SettingSecurityToken'))
begin
	exec('alter table [SettingSecurityToken] add [LastModifiedByName] [nvarchar](256) NULL')
	print 'column [LastModifiedByName] added to table SettingSecurityToken ...'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'DataType' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] ALTER COLUMN [DataType] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column DataType in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedById' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] ALTER COLUMN [CreatedById] [uniqueidentifier] NULL;
	PRINT 'Alter column CreatedById in table SettingSecurityToken';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LastModifiedById' 
	AND Object_ID = Object_ID(N'SettingSecurityToken'))
BEGIN
	ALTER TABLE [SettingSecurityToken] ALTER COLUMN [LastModifiedById] [uniqueidentifier] NULL;
	PRINT 'Alter column LastModifiedById in table SettingSecurityToken';
END
GO