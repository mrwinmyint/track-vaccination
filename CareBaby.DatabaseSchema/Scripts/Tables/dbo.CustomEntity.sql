/****** Object:  Table [dbo].[CustomEntity]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomEntity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomEntity](
	[Id] [uniqueidentifier] NOT NULL,
	[DefaultEntityName] [nvarchar](256) NOT NULL,
	[DisplayEntityName] [nvarchar](256) NULL,
	[Description] [nvarchar](256) NULL,
    [IsSystemEntity] [bit] NOT NULL,
    [IsStrictEntity] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
    [Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_CustomEntity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'IsSystemEntity' 
	AND Object_ID = Object_ID(N'CustomEntity'))
BEGIN
	exec('alter table [CustomEntity] add [IsSystemEntity] [bit] NULL')
	exec('update CustomEntity set [IsSystemEntity] = 1')	
    exec('alter table [CustomEntity] alter column [IsSystemEntity] [bit] NOT NULL')	
	print 'column [IsSystemEntity] added to table CustomEntity ...'
END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'CustomEntity'
                      AND COLUMN_NAME = 'CreatedBy'
                      AND TABLE_SCHEMA='DBO')
  BEGIN
      ALTER TABLE CustomEntity
        DROP COLUMN CreatedBy
  END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'CustomEntity'
                      AND COLUMN_NAME = 'CreatedDate'
                      AND TABLE_SCHEMA='DBO')
  BEGIN
      ALTER TABLE CustomEntity
        DROP COLUMN CreatedDate
  END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'CustomEntity'
                      AND COLUMN_NAME = 'ModifiedBy'
                      AND TABLE_SCHEMA='DBO')
  BEGIN
      ALTER TABLE CustomEntity
        DROP COLUMN ModifiedBy
  END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'CustomEntity'
                      AND COLUMN_NAME = 'ModifiedDate'
                      AND TABLE_SCHEMA='DBO')
  BEGIN
      ALTER TABLE CustomEntity
        DROP COLUMN ModifiedDate
  END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'CustomEntity'
                      AND COLUMN_NAME = 'ModifiedReason'
                      AND TABLE_SCHEMA='DBO')
  BEGIN
      ALTER TABLE CustomEntity
        DROP COLUMN ModifiedReason
  END
GO

if not exists(select * from sys.columns where Name = N'Created' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [Created] [DateTimeOffset] NULL')
	exec('update CustomEntity set [Created] = SYSDATETIMEOFFSET()')
	exec('alter table [CustomEntity] alter column [Created] [DateTimeOffset] NOT NULL')	
	print 'column [Created] added to table CustomEntity ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedById' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [CreatedById] [nvarchar](128) NULL')
	print 'column [CreatedById] added to table CustomEntity ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedByName' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [CreatedByName] [nvarchar](256) NULL')
    exec('update CustomEntity set [CreatedByName] = ''administrator''')
	print 'column [CreatedByName] added to table CustomEntity ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModified' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [LastModified] [DateTimeOffset] NULL')
	print 'column [LastModified] added to table CustomEntity ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedById' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [LastModifiedById] [nvarchar](128) NULL')
	print 'column [LastModifiedById] added to table CustomEntity ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedByName' and Object_ID = Object_ID(N'CustomEntity'))
begin
	exec('alter table [CustomEntity] add [LastModifiedByName] [nvarchar](256) NULL')
	print 'column [LastModifiedByName] added to table CustomEntity ...'
end
go

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'IsStrictEntity' 
	AND Object_ID = Object_ID(N'CustomEntity'))
BEGIN
	exec('alter table [CustomEntity] add [IsStrictEntity] [bit] NULL')
	exec('update CustomEntity set [IsStrictEntity] = 0')	
    exec('alter table [CustomEntity] alter column [IsStrictEntity] [bit] NOT NULL')	
	print 'column [IsStrictEntity] added to table CustomEntity ...'
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'CustomEntity'))
BEGIN
	ALTER TABLE [CustomEntity] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table CustomEntity';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedById' 
	AND Object_ID = Object_ID(N'CustomEntity'))
BEGIN
	ALTER TABLE [CustomEntity] ALTER COLUMN [CreatedById] [uniqueidentifier] NULL;
	PRINT 'Alter column CreatedById in table CustomEntity';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LastModifiedById' 
	AND Object_ID = Object_ID(N'CustomEntity'))
BEGIN
	ALTER TABLE [CustomEntity] ALTER COLUMN [LastModifiedById] [uniqueidentifier] NULL;
	PRINT 'Alter column LastModifiedById in table CustomEntity';
END
GO