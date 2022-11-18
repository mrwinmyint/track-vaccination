--
-- SettingGeneral
-- initial data setup for SettingGeneral table
--

declare @CreatedBy as [nvarchar](128)
set @CreatedBy = 'e7134470-9950-4e8f-a13f-789789a16a37'  -- default guid value, needs to use same hardcoded GUID value for all CreatedBy

declare @StringDataTypeId as [nvarchar](128)
set @StringDataTypeId = (select top(1) [Id] from DataType where [Name] = 'string')

-- create temp table and insert lookup values
declare @Values table (
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DataType] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](500) NULL,
	[IsNullable] [bit] NOT NULL,
	[Description] [nvarchar](1000) NULL
)
set nocount on

insert into @Values([Id], [Name], [DataType], [Value], [IsNullable], [Description])
values 
	 (LOWER(NEWID()), 'ConfirmEmailCallbackUrl', @StringDataTypeId, 'https://carebabysystem.com', 'false', 'This is a url sent in an email to redirect back to the system.')	
set nocount off


-- add non-existing values
insert into SettingGeneral ([Id], [Name], [DataType], [Value], [IsNullable], [Description], [IsActive], [IsDeleted], [Created]) -- use the default guid value, which may not be available in AspNetUsers or User tables, but need to use same hardcoded GUID value for all CreatedBy
select distinct [Id], [Name], [DataType], [Value], [IsNullable], [Description], 'true', 'false', SYSDATETIMEOFFSET()
from @Values newValues
where
	not exists (
		select [Name]
		from SettingGeneral existingValues
        where existingValues.[Name] = newValues.[Name] and existingValues.[DataType] = newValues.[DataType])

UPDATE SettingGeneral SET [Id] = LOWER([Id])