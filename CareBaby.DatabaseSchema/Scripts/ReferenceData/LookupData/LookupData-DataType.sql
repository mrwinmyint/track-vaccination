--
-- DataType 
-- DataType lookup available in the system for some settings tables
--

declare @CreatedBy as [nvarchar](128)
set @CreatedBy = 'e7134470-9950-4e8f-a13f-789789a16a37'  -- default guid value, needs to use same hardcoded GUID value for all CreatedBy

-- create temp table and insert lookup values
declare @Values table (
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Alias] [nvarchar](100) NULL,
	[Description] [nvarchar](1000) NULL
)
set nocount on

insert into @Values([Id], [Name], [Alias], [Description])
values 
	 (LOWER(NEWID()), 'datetime', 'datetime', 'DateTime helps developer to find out more information about Date and Time like Get month, day, year, week day. It also helps to find date difference, add number of days to a date, etc.')	
	,(LOWER(NEWID()), 'string', 'string', 'A string is an object of type String whose value is text.')	
	,(LOWER(NEWID()), 'boolean', 'boolean', 'The boolean data type is a primitive data type having one of two values: true or false.')	
	,(LOWER(NEWID()), 'integer', 'integer', 'The integer data type is a value type contains an instance of the type.')	
set nocount off


-- add non-existing values
insert into DataType ([Id], [Name], [Alias], [Description], [IsActive], [IsDeleted], [Created])  -- use the default guid value, which may not be available in AspNetUsers or User tables, but need to use same hardcoded GUID value for all CreatedBy
select distinct [Id], [Name], [Alias], [Description], 'true', 'false', SYSDATETIMEOFFSET()
from @Values newValues
where
	not exists (
		select [Name]
		from DataType existingValues
        where existingValues.[Name] = newValues.[Name])

UPDATE DataType SET [Id] = LOWER([Id])