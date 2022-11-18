# 1) Creating a new database
# First create a new database on SQL Server
# Then open a command prompt an CD into the scripts folder, eg:
#c:\MYSTUFF\Database Update Scripts\scripts

# run this command line to autmatically create required schema and default data

# This example use Windows Auth
powershell -File dbupdate.ps1 -dbserver SERVERNAME -database EMPTY_DB_NAME -scriptsDir .\

# This example use SQL auth
powershell -File dbupdate.ps1 -dbserver SERVERNAME -database EMPTY_DB_NAME -dbusername USERNAME -dbpassword PASSWORD -scriptsDir .\


# 2) Now login to the database administrator / password is the default login

# 3) Edit manifest.csv and add a version number to a file, eg. version 20000

	"T","dbo.User.sql","20000, 15609",""

# 4) Upgrade the database with the first command, or this will check which scripts are required:
# Use -currentVersion to specify the current DB version (later this will auto detect)
# Use -dropConstraints 1 to drop all constraints such as FK, PK, INDX, etc.
# This example use drop constraints
powershell -File dbupdate.ps1 -dbserver SERVERNAME -database EMPTY_DB_NAME -scriptsDir .\ -currentVersion 0 -dropConstraints 1

# This example use Windows Auth
powershell -File dbupdate.ps1 -dbserver SERVERNAME -database EMPTY_DB_NAME -scriptsDir .\ -currentVersion 15609

# you should see final output like:
# 1 of 1292 scripts required to upgrade version 15609 to latest(20000)

# your database is now upgraded.



