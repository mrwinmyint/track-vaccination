-- in Visual Studio ensure "SQLCMD mode" button is selected to run this
-- parameter values can be passed in from Powershell. Uncomment to use directly from VS/SSMS

--:setvar dbname "new_database_name_here9993"
--:setvar dbnameUnquote 'new_database_name_here9993' -- find a better way to remove the double quotes from $dbname for printing

declare @continue bit
set @continue = 1

if exists(select * from sys.databases where Name = $(dbnameUnquote))
begin
	print $(dbnameUnquote) + ' already exists!'
	set @continue = 0
end


if @continue = 1
begin
	--!!ECHO Creating database $(dbname)  ...
	PRINT 'Creating ' + $(dbnameUnquote)
	CREATE DATABASE $(dbname)
	--GO

	--!!ECHO  Done.	
	ALTER DATABASE $(dbname) SET COMPATIBILITY_LEVEL = 90
	--GO

	--!!ECHO COMPATIBILITY_LEVEL = 90
	PRINT 'COMPATIBILITY_LEVEL = 90'
	ALTER DATABASE $(dbname) SET RECOVERY SIMPLE 
	--GO

	--!!ECHO Simple recovery
	PRINT 'Simple recovery'
end
go
