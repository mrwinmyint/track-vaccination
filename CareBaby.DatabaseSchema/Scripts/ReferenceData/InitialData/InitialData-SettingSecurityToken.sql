--
-- SettingSecurityToken 
-- initial data setup for SettingSecurityToken table
--

declare @CreatedBy as [nvarchar](128)
set @CreatedBy = 'e7134470-9950-4e8f-a13f-789789a16a37'  -- default guid value, needs to use same hardcoded GUID value for all CreatedBy

declare @StringDataTypeId as [nvarchar](128)
set @StringDataTypeId = (select top(1) [Id] from DataType where [Name] = 'string')

declare @IntegerDataTypeId as [nvarchar](128)
set @IntegerDataTypeId = (select top(1) [Id] from DataType where [Name] = 'integer')

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
	 (LOWER(NEWID()), 'Secret', @StringDataTypeId, '2E4B8F7452FBF1D1A689354E5F58C99F7EF57E1B98AD8EB78E68B1DEEA2D26FB', 'false', 'Secret key is used as IssuerSigningKey by encoding in SymmetricSecurityKey object in TokenValidationParameters in resource server (API) end. Generate secret key via this link https://www.grc.com/passwords.htm use 64 hex characters = 256 binary bits.')
	,(LOWER(NEWID()), 'Audience', @StringDataTypeId, 'https://localhost:44328', 'false', 'Resource domain.')
	,(LOWER(NEWID()), 'Issuer', @StringDataTypeId, 'https://localhost:44385', 'false', 'Authorization server domain.')
	,(LOWER(NEWID()), 'AccessTokenExpiryMinutes', @IntegerDataTypeId, '60', 'false', 'Token expiry time in minutes.')
	,(LOWER(NEWID()), 'RefreshTokenExpiryHours', @IntegerDataTypeId, '720', 'false', 'Refresh token expiry time in hours.')
set nocount off


-- add non-existing values
insert into SettingSecurityToken ([Id], [Name], [DataType], [Value], [IsNullable], [Description], [IsActive], [IsDeleted], [Created]) -- use the default guid value, which may not be available in AspNetUsers or User tables, but need to use same hardcoded GUID value for all CreatedBy
select distinct [Id], [Name], [DataType], [Value], [IsNullable], [Description], 'true', 'false', SYSDATETIMEOFFSET()
from @Values newValues
where
	not exists (
		select [Name]
		from SettingSecurityToken existingValues
        where existingValues.[Name] = newValues.[Name] and existingValues.[DataType] = newValues.[DataType])

UPDATE SettingSecurityToken SET [Id] = LOWER([Id])