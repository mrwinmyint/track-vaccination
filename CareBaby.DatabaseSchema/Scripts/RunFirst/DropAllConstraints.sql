-- drop all the constraints
-- https://gist.github.com/smoothdeveloper/ea48e43aead426248c0f

with
	unique_constraint_infos (schemaname, tablename, constraintname, columnname)
	as (
		select
			quotename(tc.table_schema)
			, quotename(tc.table_name)
			, quotename(tc.constraint_name)
			, quotename(cc.column_name)
		from
			information_schema.table_constraints tc
			inner join information_schema.constraint_column_usage cc on tc.constraint_name = cc.constraint_name
		where
			lower(tc.constraint_type) = 'unique'
	)
	, check_constraint_infos (schemaname, tablename, constraintname, definition)
	as (
		select
			quotename(cs.name)
			, quotename(ct.name)
			, quotename(ck.name)
			, ck.definition 
		from
			sys.check_constraints ck
			inner join sys.tables ct on ck.parent_object_id = ct.[object_id]
			inner join sys.schemas cs on ct.[schema_id] = cs.[schema_id]	
	)
	, default_constraint_infos (schemaname, tablename, constraintname, definition)
	as (
		select
			quotename(cs.name)
			, quotename(ct.name)
			, quotename(df.name)
			, df.definition 
		from
			sys.default_constraints df
			inner join sys.tables ct on df.parent_object_id = ct.[object_id]
			inner join sys.schemas cs on ct.[schema_id] = cs.[schema_id]	
	)
	, primary_key_infos(schemaname, tablename, constraintname, definition)
	as (
		select
			quotename(cs.name)
			, quotename(ct.name)
			, quotename(ck.name)
			, '' as definition 
		from
			sys.key_constraints ck
			inner join sys.tables ct on ck.parent_object_id = ct.[object_id]
			inner join sys.schemas cs on ct.[schema_id] = cs.[schema_id]
			and ck.type = 'PK'	
	)
	, foreign_key_infos (constraintschemaname, constrainttablename, referenceschemaname, referencetablename, constraintname, constraintcolumns, referencecolumns)
	as (
		select
			quotename(cs.name)
			, quotename(ct.name)
			, quotename(rs.name)
			, quotename(rt.name)
			, quotename(fk.name)
			, stuff(
				(select 
					',' + quotename(c.name)
					-- get all the columns in the constraint table
				from
					sys.columns as c 
				inner join sys.foreign_key_columns as fkc 
					on fkc.parent_column_id = c.column_id
					and fkc.parent_object_id = c.[object_id]
				where
					fkc.constraint_object_id = fk.[object_id]
				for xml path(''), type
				).value('.[1]', 'nvarchar(max)')
			, 1, 1, ''
			)
			, stuff(
				(select 
					',' + quotename(c.name)
					-- get all the referenced columns
				from 
					sys.columns as c 
					inner join sys.foreign_key_columns as fkc 
						on fkc.referenced_column_id = c.column_id
						and fkc.referenced_object_id = c.[object_id]
					where fkc.constraint_object_id = fk.[object_id]
					for xml path(''), type
					).value('.[1]', N'nvarchar(max)')
			, 1, 1, '')
		from
			sys.foreign_keys as fk
			inner join sys.tables as rt on fk.referenced_object_id = rt.[object_id]
			inner join sys.schemas as rs on rt.[schema_id] = rs.[schema_id]
		inner join sys.tables as ct on fk.parent_object_id = ct.[object_id]
		inner join sys.schemas as cs on ct.[schema_id] = cs.[schema_id]
		where
			rt.is_ms_shipped = 0 and ct.is_ms_shipped = 0
	)
	, index_key_infos(schemaname, tablename, constraintname, definition)
	as (
		select 
		quotename(cs.name)
		, quotename(ct.name)
		, quotename(ck.name)
		, '' as definition 
		from sys.indexes ck
			inner join sys.tables ct on ck.object_id = ct.[object_id]
			inner join sys.schemas cs on ct.[schema_id] = cs.[schema_id]
			and ck.type = 2		
	)

select * 
into 
	#scriptsToDrop
from (
	-- create/drop foreign keys
	select distinct
		'foreign keys' script_type
		, 
			' alter table ' + fki.constraintschemaname + '.' + fki.constrainttablename
			+ ' add constraint ' + fki.constraintname
			+ ' foreign key (' + fki.constraintcolumns + ')'
			+ ' references ' + fki.referenceschemaname + '.' + fki.referencetablename
			+ ' ('  + fki.referencecolumns + ');' create_script
		,
			'alter table ' + fki.constraintschemaname + '.' + fki.constrainttablename 
			+ 'drop constraint ' + fki.constraintname + ';' drop_script
	from
		foreign_key_infos fki	

	union all
	-- create/drop unique constraints
	select distinct
		'unique constraints'
		, 
			' alter table ' + uci.schemaname + '.' + uci.tablename
			+ ' add constraint ' + uci.constraintname
			+ ' unique ('
			+ stuff(
			(
				select ', ' + ci.columnname
				from unique_constraint_infos ci
				where ci.schemaname = uci.schemaname
					and ci.tablename = uci.tablename
					and ci.constraintname = uci.constraintname
				for xml path('')
			), 1, 1, '')
			+ ');'
		, 
			' alter table ' + uci.schemaname + '.' + uci.tablename
			+ ' drop constraint ' + uci.constraintname + ';'
	from
		unique_constraint_infos uci
	union all
	-- create/drop check constraints
	select distinct
		'check constraints'
		,
			'alter table ' + cki.schemaname + '.' + cki.tablename
			+ ' with check add constraint ' + cki.constraintname
			+ ' check ' + cki.definition + ';'
		,
			' alter table ' + cki.schemaname + '.' + cki.tablename
			+ ' drop constraint ' + cki.constraintname + ';'
	from
		check_constraint_infos cki
	union all
	-- primary key constraints
	select distinct
		'primary key constraints'
		,
			''
		,
			' alter table ' + cki.schemaname + '.' + cki.tablename
			+ ' drop constraint ' + cki.constraintname + ';'
	from
		primary_key_infos cki
	union all
	-- default key constraints
	select distinct
		'default constraints'
		,
			''
		,
			' alter table ' + cki.schemaname + '.' + cki.tablename
			+ ' drop constraint ' + cki.constraintname + ';'
	from
		default_constraint_infos cki
	union all
	-- index key constraints
	select distinct
		'index key constraints'
		,
			''
		,
			--' alter table ' + iki.schemaname + '.' + iki.tablename
			' drop index ' + iki.constraintname + 'on ' + iki.tablename +';'
	from
		index_key_infos iki

) a


DECLARE @drop nVARCHAR(max) 
DECLARE @dropCount int 

SELECT @drop = COALESCE(@drop + char(10), '') + ISNULL(drop_script, '') FROM #scriptsToDrop 
SELECT @dropCount = COUNT(*) FROM #scriptsToDrop 

--DECLARE @drop NVARCHAR(MAX) = N''
--set @drop = (
--	SELECT drop_script + CHAR(10) AS 'data()' 
--	FROM #scriptsToDrop 
--	FOR XML PATH(''))

drop table #scriptsToDrop

print 'Running script to drop ' + cast(@dropCount as varchar) + ' constraints'
EXEC sp_executesql @drop

print @drop
