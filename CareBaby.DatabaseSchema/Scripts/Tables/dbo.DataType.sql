/****** Object:  Table [dbo].[DataType]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DataType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Alias] [nchar](100) NULL,
	[Description] [nvarchar](1000) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_DataType] PRIMARY KEY CLUSTERED 
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
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] DROP COLUMN [CreatedBy];
	PRINT 'Dropped column CreatedBy in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedDate' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] DROP COLUMN [CreatedDate];
	PRINT 'Dropped column CreatedDate in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedBy' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] DROP COLUMN [ModifiedBy];
	PRINT 'Dropped column ModifiedBy in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedDate' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] DROP COLUMN [ModifiedDate];
	PRINT 'Dropped column ModifiedDate in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ModifiedReason' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] DROP COLUMN [ModifiedReason];
	PRINT 'Dropped column ModifiedReason in table DataType';
END
GO


if not exists(select * from sys.columns where Name = N'Created' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [Created] [DateTimeOffset] NULL')
	exec('update DataType set [Created] = SYSDATETIMEOFFSET()')
	exec('alter table [DataType] alter column [Created] [DateTimeOffset] NOT NULL')	
	print 'column [Created] added to table DataType ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedById' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [CreatedById] [nvarchar](128) NULL')
	print 'column [CreatedById] added to table DataType ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedByName' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [CreatedByName] [nvarchar](256) NULL')
    exec('update DataType set [CreatedByName] = ''administrator''')
	print 'column [CreatedByName] added to table DataType ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModified' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [LastModified] [DateTimeOffset] NULL')
	print 'column [LastModified] added to table DataType ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedById' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [LastModifiedById] [nvarchar](128) NULL')
	print 'column [LastModifiedById] added to table DataType ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedByName' and Object_ID = Object_ID(N'DataType'))
begin
	exec('alter table [DataType] add [LastModifiedByName] [nvarchar](256) NULL')
	print 'column [LastModifiedByName] added to table DataType ...'
end
go

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedById' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] ALTER COLUMN [CreatedById] [uniqueidentifier] NULL;
	PRINT 'Alter column CreatedById in table DataType';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LastModifiedById' 
	AND Object_ID = Object_ID(N'DataType'))
BEGIN
	ALTER TABLE [DataType] ALTER COLUMN [LastModifiedById] [uniqueidentifier] NULL;
	PRINT 'Alter column LastModifiedById in table DataType';
END
GO