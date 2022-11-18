--
-- SettingEmail 
-- initial data setup for SettingEmail table
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
	 (LOWER(NEWID()), 'FromName', @StringDataTypeId, 'Care Baby System', 'false', 'This is a user-friendly name that is displayed to your recipient when they receive their email.')	
	,(LOWER(NEWID()), 'FromAddress', @StringDataTypeId, '', 'false', 'This will display to the user as the email address who sent this email. We will send the verification email to the address you enter in this field. If you have not received your verification email after some time, please refer back to the Sender settings and confirm that the "From" email is a valid address.')	
	,(LOWER(NEWID()), 'ApiKey', @StringDataTypeId, '', 'false', 'application, mail client, or website can all use API (Application Programming Interface) keys to authenticate access to SendGrid services. They are the preferred alternative to using a username and password because you can revoke an API key at any time without having to change your username and password. We suggest that you use API keys for connecting to all of SendGrid’s services.')	
set nocount off


-- add non-existing values
insert into SettingEmail ([Id], [Name], [DataType], [Value], [IsNullable], [Description], [IsActive], [IsDeleted], [Created]) -- use the default guid value, which may not be available in AspNetUsers or User tables, but need to use same hardcoded GUID value for all CreatedBy
select distinct [Id], [Name], [DataType], [Value], [IsNullable], [Description], 'true', 'false', SYSDATETIMEOFFSET()
from @Values newValues
where
	not exists (
		select [Name]
		from SettingEmail existingValues
        where existingValues.[Name] = newValues.[Name] and existingValues.[DataType] = newValues.[DataType])

UPDATE SettingEmail SET [Id] = LOWER([Id])