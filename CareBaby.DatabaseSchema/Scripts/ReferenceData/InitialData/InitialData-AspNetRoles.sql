--
-- AspNetRoles 
-- initial data setup for AspNetRoles table
--

-- create temp table and insert lookup values
declare @Values table (
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL
)
set nocount on

insert into @Values([Id], [Name], [NormalizedName], [ConcurrencyStamp])
values 
	(LOWER(NEWID()), 'Administrator', 'ADMINISTRATOR', LOWER(NEWID()))	
	,(LOWER(NEWID()), 'Member', 'MEMBER', LOWER(NEWID()))
	,(LOWER(NEWID()), 'Public', 'PUBLIC', LOWER(NEWID()))	 -- Superuser is for elpis administrators (product vendor account)
set nocount off


-- add non-existing values
insert into AspNetRoles ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) -- use the default guid value, which may not be available in AspNetUsers or User tables, but need to use same hardcoded GUID value for all CreatedBy
select distinct [Id], [Name], [NormalizedName], [ConcurrencyStamp]
from @Values newValues
where
	not exists (
		select [Name]
		from AspNetRoles existingValues
        where existingValues.[Name] = newValues.[Name])


UPDATE AspNetRoles SET [Id] = LOWER([Id])
UPDATE AspNetRoles SET [ConcurrencyStamp] = LOWER([ConcurrencyStamp])