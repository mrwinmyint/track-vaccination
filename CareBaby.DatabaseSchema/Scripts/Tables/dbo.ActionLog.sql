/****** Object:  Table [dbo].[ActionLog]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionLog](
	[Id] [uniqueidentifier] NOT NULL,
	[EntityId] [uniqueidentifier] NOT NULL,
	[EntityUniqueId] [uniqueidentifier] NULL,
	[EntityJson] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[SignedInRole] [nvarchar](256) NULL,
	[ActionTypeId] [smallint] NOT NULL,
	[ActionDateTime] [datetimeoffset](7) NOT NULL,
	[ActionedBy] [uniqueidentifier] NULL,        -- ActionedBy could be null for some actions like SignUp which doesn't know the person who takes action.
	[ActionReason] [nvarchar] (1000) NULL,
	[Notes] [nvarchar](1000) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_ActionLog] PRIMARY KEY CLUSTERED 
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
    WHERE Name = N'EntityUniqueId' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ADD [EntityUniqueId] [nvarchar](128) NULL;
	PRINT 'Created column EntityUniqueId in table ActionLog';
END
GO

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Email' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ADD [Email] [nvarchar](256) NULL;
	PRINT 'Created column Email in table ActionLog';
END
GO

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'SignedInRole' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ADD [SignedInRole] [nvarchar](256) NULL;
	PRINT 'Created column SignedInRole in table ActionLog';
END
GO

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'IsActive' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	exec('alter table [ActionLog] add [IsActive] [bit] NULL')
	exec('update ActionLog set [IsActive] = 1')	
    exec('alter table [ActionLog] alter column [IsActive] [bit] NOT NULL')	
	print 'column [IsActive] added to table ActionLog ...'
END
GO

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'IsDeleted' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN	
	exec('alter table [ActionLog] add [IsDeleted] [bit] NULL')
	exec('update ActionLog set [IsDeleted] = 0')	
    exec('alter table [ActionLog] alter column [IsDeleted] [bit] NOT NULL')	
	print 'column [IsDeleted] added to table ActionLog ...'
END
GO

-- reset ActionedBy with NULL when ActionedBy is empty guid
-- because ActionedBy will be referenced to [User] table
IF EXISTS(
	SELECT * 
	FROM ActionLog 
    WHERE ActionedBy = '00000000-0000-0000-0000-000000000000')
BEGIN
	UPDATE [ActionLog] SET [ActionedBy] = NULL WHERE [ActionedBy] = '00000000-0000-0000-0000-000000000000';
	PRINT 'Update ActionedBy with NULL when ActionedBy is empty guid.';
END
GO

if not exists(select * from sys.columns where Name = N'Created' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [Created] [DateTimeOffset] NULL')
	exec('update ActionLog set [Created] = SYSDATETIMEOFFSET()')
	exec('alter table [ActionLog] alter column [Created] [DateTimeOffset] NOT NULL')	
	print 'column [Created] added to table ActionLog ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedById' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [CreatedById] [nvarchar](128) NULL')
	print 'column [CreatedById] added to table ActionLog ...'
end
go

if not exists(select * from sys.columns where Name = N'CreatedByName' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [CreatedByName] [nvarchar](256) NULL')
	print 'column [CreatedByName] added to table ActionLog ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModified' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [LastModified] [DateTimeOffset] NULL')
	print 'column [LastModified] added to table ActionLog ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedById' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [LastModifiedById] [nvarchar](128) NULL')
	print 'column [LastModifiedById] added to table ActionLog ...'
end
go

if not exists(select * from sys.columns where Name = N'LastModifiedByName' and Object_ID = Object_ID(N'ActionLog'))
begin
	exec('alter table [ActionLog] add [LastModifiedByName] [nvarchar](256) NULL')
	print 'column [LastModifiedByName] added to table ActionLog ...'
end
go

IF NOT EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'EntityJson' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ADD [EntityJson] [nvarchar](max) NULL;
	PRINT 'Created column EntityJson in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'Id' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [Id] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column Id in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'EntityId' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [EntityId] [uniqueidentifier] NOT NULL;
	PRINT 'Alter column EntityId in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'EntityUniqueId' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [EntityUniqueId] [uniqueidentifier] NULL;
	PRINT 'Alter column EntityUniqueId in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'ActionedBy' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [ActionedBy] [uniqueidentifier] NULL;
	PRINT 'Alter column ActionedBy in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'CreatedById' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [CreatedById] [uniqueidentifier] NULL;
	PRINT 'Alter column CreatedById in table ActionLog';
END
GO

IF EXISTS(
	SELECT * 
	FROM sys.columns 
    WHERE Name = N'LastModifiedById' 
	AND Object_ID = Object_ID(N'ActionLog'))
BEGIN
	ALTER TABLE [ActionLog] ALTER COLUMN [LastModifiedById] [uniqueidentifier] NULL;
	PRINT 'Alter column LastModifiedById in table ActionLog';
END
GO

IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'ActionLog'
                      AND COLUMN_NAME = 'EntityId'
                      AND TABLE_SCHEMA='DBO')
BEGIN    
    EXEC sys.sp_rename 
    @objname = N'dbo.ActionLog.EntityId', 
    @newname = 'CustomEntityId', 
    @objtype = 'COLUMN'
END
GO