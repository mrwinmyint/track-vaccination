# Update a LMS database with change scripts
#
# Example usage:
# 	powershell -File dbupdate.ps1 -installTests -dbserver "WIN-1KRO2PSU3Q3" -database hotfixtest_lms -dbusername username_here -dbpassword password_here 
#   powershell -File dbupdate.ps1 -dumpFile -targetVersion 1001 -dbserver "WIN-1KRO2PSU3Q3" -database hotfixtest_lms -dbusername username_here -dbpassword password_here 
#   powershell -File dbupdate.ps1 -dumpFile -targetVersion 3000 
#   powershell -File dbupdate.ps1 -dbserver "COMPUTER" -database "new_new_new" -createDatabase
#	powershell -File dbupdate.ps1 -dbserver "COMPUTER" -database "new_new_new" -createDatabase -dropAllObjects "drop_all_database_objects" -currentVersion 0 -targetVersion -1

param (
	[string]$dbserver = "" #$(throw "-dbserver is required")
	,[string]$database = "" #$(throw "-database is required")
	,[string]$dbusername = ""
	,[string]$dbpassword = ""
	,[string]$manifestFileName = ".\manifest.csv"  
    ,[string]$scriptsDir = ""         # root directory containing all the update scripts
 	,[int]$targetVersion = -1         # target version number, -1 for "latest"
 	,[int]$currentVersion = -1        # current version number, -1 to get from database
    ,[string]$targetVersionLabel = "" # label (eg. 2.0.12345.16) of the version to update to
	,[switch]$installTests = $false
	,[switch]$dumpFile = $false
	,[switch]$createDatabase = $false # if true will attempt to create $database on $dbserver
	,[int]$dropConstraints = 0		  # if > 1 the file DropAllConstraints.sql will be run. 
									  # Allows script to rebiuld all the PK, FK, indexes and default contraints. 
									  # Should be combined with $currentVersion = 0 to completely refresh all constraints.
	,[string]$dropAllObjects = "no"	  # CAUTION - Drops ALL the database objects leaving a blank database. 
									  #	Use to allow a site refresh by completely rebuilding the database.
									  #	Set to "drop_all_database_objects" to confirm dropping the objects.
)

function GetMaxScriptVersionHistory([string]$versionHistory) {
    if($versionHistory.Contains(",")) {    
        $history = $script.VersionHistory.split(',') | % { [convert]::ToInt32($_) }

        [array]::sort($history)
        $latestVersion = $history[-1]
    } else {
        $latestVersion = [convert]::ToInt32($versionHistory)
    }

    return $latestVersion
}

function GetScriptTypeDirectory($script, $scriptsDir) {
    if($script.Type -eq "T") {
        $scriptFileName = "$scriptsDir\Tables\$($script.Filename)" 
    } elseif($script.Type -eq "P") {
        $scriptFileName = "$scriptsDir\Procedures\$($script.Filename)"
    } elseif($script.Type -eq "V") {
        $scriptFileName = "$scriptsDir\Views\$($script.Filename)"
    } elseif($script.Type -eq "F") {
        $scriptFileName = "$scriptsDir\Functions\$($script.Filename)"
    } elseif($script.Type -eq "C") {
        $scriptFileName = "$scriptsDir\Tables\Constraints\$($script.Filename)"
    } elseif($script.Type -eq "TR") {
        $scriptFileName = "$scriptsDir\Triggers\$($script.Filename)"
    } elseif($script.Type -eq "UDT") {
        $scriptFileName = "$scriptsDir\UserDefinedTypes\$($script.Filename)"
    } elseif($script.Type -eq "ID") {
        $scriptFileName = "$scriptsDir\ReferenceData\InitialData\$($script.Filename)"
    } elseif($script.Type -eq "LD") {
        $scriptFileName = "$scriptsDir\ReferenceData\LookupData\$($script.Filename)"
    } elseif($script.Type -eq "AD") {
        $scriptFileName = "$scriptsDir\Adhoc\$($script.Filename)"
    } elseif($script.Type -eq "RF") {
        $scriptFileName = "$scriptsDir\RunFirst\$($script.Filename)"
    } elseif($script.Type -eq "RL") {
        $scriptFileName = "$scriptsDir\RunLast\$($script.Filename)"
    }
	else {
        $scriptFileName = ""
    }

    return $scriptFileName
}

function RunScriptFile(
	[string]$scriptFileName,
    [string]$database,
    [string]$dbserver,
    [string]$dbusername,
    [string]$dbpassword,
	[int]$timeoutSeconds = 600)
{
    # Look at refactor this code into a function
    try {
		if($dbusername -eq "") {		
			Invoke-Sqlcmd -EA Stop -QueryTimeout $timeoutSeconds -InputFile $scriptFileName -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose    
		} else {
			Invoke-Sqlcmd -EA Stop -QueryTimeout $timeoutSeconds -InputFile $scriptFileName -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
		}
	} catch {            
		Write-Error $($_.Exception.Message)
        exit 1
	}
}

function ProcessManifestSection (
    [string]$scriptType,
    $scripts,
    [int]$currentVersion,
    [int]$targetVersion,
    [string]$scriptsDir,
    [bool]$dumpFile,
    [string]$dumpFilePath) 
{
	$timeoutSeconds = 600
    $scriptsToProcess = $scripts | Where-Object {$_.Type -eq $scriptType}

    $matchCounter = 0
    foreach($script in $scriptsToProcess) {

        $latestVersion = GetMaxScriptVersionHistory $script.VersionHistory

        $isMatch = ($currentVersion -lt $latestVersion -or $currentVersion -eq -1) -and ($latestVersion -le $targetVersion -or $targetVersion -eq -1)
        if($isMatch) {
            $matchCounter++;
        }
     
        $updateFileMessage = ""
        if($isMatch) {

            #Write-Output "Script type $($script.Type)"

            $scriptFileName = GetScriptTypeDirectory $script $scriptsDir

            if($scriptFileName -eq "") {
               throw "Unable to determine location of script $($script)"
            } else {

                # make sure this is a full file path else get content does not accept relative paths
                if(-not [io.path]::IsPathRooted($scriptFileName)) {
                    $scriptFileName = "$PSScriptRoot\$scriptFileName"
                }

                if($dumpFile) {
                    $updateFileMessage = "Writing script $scriptFileName to $dumpFileName"
                    Write-Host $updateFileMessage

                    $fileHeader = "$($newline)--$scriptFileName $newline--Version updated $latestVersion $newline--$($script.Comment)($newline)($newline)"
                    #$sql = (Get-Content "$PSScriptRoot\$scriptFileName")
                    $sql = (Get-Content "$scriptFileName")
                    $fileHeader + $sql | Out-File $dumpFilePath -Append
                } else {
		            Write-Host "MATCH $latestversion`tRunning script $($script.Type) $($script.Filename) $($script.Comment)"    
    
		            # if there's no username then passing a blank username results in an error
		            # however omitting this parameter uses windows authentication
		            try {
			            if($dbusername -eq "") {		
				            Invoke-Sqlcmd -EA Stop -InputFile $scriptFileName -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose -QueryTimeout $timeoutSeconds    
			            } else {
				            Invoke-Sqlcmd -EA Stop -InputFile $scriptFileName -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose -QueryTimeout $timeoutSeconds
			            }
		            } catch {
			            Write-Host "##teamcity[buildStatus status='FAILURE' text='Error in script $($script.Filename) $($_.Exception.Message)']"
			            exit 1
		            }
                }
            }
        } else {
            $matchString = "SKIP"
            Write-Host "$matchString $latestVersion `t $($script.FileName) $updateFileMessage"
        }
        #$scriptCounter++;
    }

    return New-Object -TypeName PSObject -Property @{'scriptsProcessed'=([array]$scriptsToProcess).Count;'scriptsExecuted'=$matchCounter}
}

# get max version number
function getLatestVersionFromManifest($script) {
    $allVersions = @()
    foreach($script in $scripts) {
        if($script.VersionHistory.Contains(",")) {
            $versionHistory = $script.VersionHistory.split(',') | % { [convert]::ToInt32($_) }
            foreach($version in $versionHistory) {
                $allVersions += $version
            }
        } else {
            $allVersions += @([convert]::ToInt32($script.VersionHistory))
        }
    }

    [array]::sort($allVersions)
    $maxVersion = $allVersions[-1]

    return $maxVersion
}

# get a full file path relative to the location of all the scripts
function GetRootedPath([string]$baseDir, [string]$path) {
	$rootedPath = ""
	if(-not [io.path]::IsPathRooted($baseDir)) {
        $rootedPath = [System.IO.Path]::Combine($PSScriptRoot, $path)
    } else {
        $rootedPath = [System.IO.Path]::Combine($baseDir, $path)
    }

	return $rootedPath
}

Set-StrictMode -Version 2.0

$startTime = Get-Date
$newline = "`r`n"

Write-Host "dbserver`t`t$dbserver"
Write-Host "database`t`t$database"
Write-Host "dbusername`t`t$dbusername"
Write-Host "dumpFile`t`t$dumpFile"
Write-Host "scriptsDir`t`t$scriptsDir"
Write-Host "manifestFileName`t$manifestFileName"
Write-Host "targetVersion`t`t$targetVersion"
Write-Host "currentVersion`t`t$currentVersion"
Write-Host "dropConstraints`t`t$dropConstraints"
Write-Host "dropAllObjects`t`t$dropAllObjects"

Write-Output "$($newline)Started at $startTime"

if(-not $dumpFile -and ($dbserver -eq "" -or $database -eq "")) {
    throw "-dbserver and -database are required if -dumpFile is false"
}

# ensure SQL Server cmdlets are available
# this will change the current provider to SQLSERVER
Write-Output "Checking SQL Server cmdlets are available"
if (!(Get-Command Invoke-Sqlcmd -CommandType Cmdlet -errorAction SilentlyContinue)) {
	Write-Error "Invoke-Sqlcmd cmdlet not available on this server. Unable to run .sql update scripts."
	exit 1
}

if($dbusername -eq "") {
	Write-Output "-dbusername is empty. Windows Authentication will be used."
}

if(-not [io.path]::IsPathRooted($scriptsDir)) {
	$versionScriptFileName = [System.IO.Path]::Combine($PSScriptRoot,"Tables\dbo.DatabaseVersion.sql")
} else {
	$versionScriptFileName = [System.IO.Path]::Combine($scriptsDir,"Tables\dbo.DatabaseVersion.sql")
}

# try create database if requested
if($database -ne "" -and $createDatabase) {
	if(-not [io.path]::IsPathRooted($scriptsDir)) {
		$scriptFileName = [System.IO.Path]::Combine($PSScriptRoot,"Setup\CreateDatabase.sql")
	} else {
		$scriptFileName = [System.IO.Path]::Combine($scriptsDir,"Setup\CreateDatabase.sql")
	}

	# Look at refactor this code into a function
    try {
		Write-Host "Attempting to create new database $database on $dbserver"
		$variables = "dbname=`"$database`"", "dbnameUnquote='$database'"
		if($dbusername -eq "") {		
			Invoke-Sqlcmd -Variable $variables -EA Stop -InputFile $scriptFileName -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose
			Invoke-Sqlcmd -EA Stop -InputFile $versionScriptFileName -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose
		} else {
			Invoke-Sqlcmd -Variable $variables -EA Stop -InputFile $scriptFileName -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
			Invoke-Sqlcmd -EA Stop -InputFile $versionScriptFileName -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
		}
		Write-Host "Created database $database"
	} catch {            
		Write-Error $($_.Exception.Message)
        exit 1
	}
}

Write-Output "Connecting to $database on $dbserver"

# get current database version
if($database -ne "" -and $currentVersion -eq -1) {
    Write-Output "Checking current version on $database"
    # this will throw error if table does not exist
    # need to find the correct way to check for nulls here
    try {
		$qry = "select coalesce(max(version), 0) as version from DatabaseVersion"
		if($dbusername -eq "") {		
			$currentVersionQuery = Invoke-Sqlcmd -Query $qry -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose
		} else {
			$currentVersionQuery = Invoke-Sqlcmd -Query $qry -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
		}        
        $currentVersion = $currentVersionQuery['version']
    } catch {
        Write-Output "WARNING DatabaseVersion table does not exist. Creating schema."

        # Look at refactor this code into a function
        try {
			if($dbusername -eq "") {		
				Invoke-Sqlcmd -EA Stop -InputFile $versionScriptFileName -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose    
			} else {
				Invoke-Sqlcmd -EA Stop -InputFile $versionScriptFileName -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
			}
		} catch {            
			Write-Error $($_.Exception.Message)
            exit 1
		}
    }
}

Write-Output "Current version $currentVersion"
Write-Output "Target version $targetVersion"
Write-Output "Scripts directory $scriptsDir"

# get all the script to run
# "Type", "Filename", "VersionHistory", "Comments"
# "T", "filename.sql", "2065,2012,2005,2003", "latest comment goes here?"
$scripts = Import-Csv -Path FileSystem::$manifestFileName
$maxVersion = getLatestVersionFromManifest $scripts


# display dump file metadata
if($dumpFile) {
    $header = 
"-- Autogenerated script file $(Get-Date)
-- Base version $currentVersion
-- Target version $targetVersion
"
    $date = Get-Date -Format "yyyy-MM-dd"

    if($targetVersion -eq -1 -and $currentVersion -eq -1) {
        $dumpFileName = "all_to_$($maxVersion)_$($date).all.sql"        
    } else {
        $fromVersionString = if($currentVersion -lt 1) { "all" } else { $currentVersion }
        $dumpFileName = "$($fromVersionString)_$($targetVersion)_$($date).all.sql"        
    }
    $header | Out-File "$PSScriptRoot\$dumpFileName"

    Write-Output "Dump file $dumpFileName"
}

# ensure the dump file is a full file path
if($dumpFile) {
	# refactor this code into a reusable method
    if(-not [io.path]::IsPathRooted($scriptsDir)) {
        $dumpFilePath = "$PSScriptRoot\$dumpFileName"
    } else {
        $dumpFilePath = "$scriptsDir\$dumpFileName"
    }
} else {
    $dumpFilePath = ""
}

Write-Output "$($newline)Checking which scripts to run..."

if($dropAllObjects -eq "drop_all_database_objects") {

    $dropAllPath = GetRootedPath $scriptsDir "Setup\DropAllObjects.sql"

	if($currentVersion -gt 0) {
		Write-Host "dropAllObjects is true but currentVersion is $currentVersion. Skipping this step. Ensure currentVersion is -1 to drop all objects."		
	} else {
		Write-Host "dropAllObjects is true. Attempting to run Setup\DropAllObjects.sql"
		RunScriptFile $dropAllPath $database $dbserver $dbusername $dbpassword
	}
}

# drop all the constraints (if enabled)
if($dropConstraints -gt 0) {

    $dropPath = GetRootedPath $scriptsDir "RunFirst\DropAllConstraints.sql"

	if($currentVersion -gt 0) {
		Write-Host "dropConstraints is true but currentVersion is $currentVersion. Skipping this step. Ensure currentVersion is -1 to drop all constraints."		
	} else {
		Write-Host "dropConstraints is true. Attempting to run RunFirst\DropAllConstraints.sql"
		RunScriptFile $dropPath $database $dbserver $dbusername $dbpassword
	}
}

# Run all the scripts in sections and in order the order listed in manifest file
##$rf = ProcessManifestSection "RF" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
#$udt = ProcessManifestSection "UDT" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
$t = ProcessManifestSection "T" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
#$f = ProcessManifestSection "F" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
$v = ProcessManifestSection "V" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
#$p = ProcessManifestSection "P" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
#$tr = ProcessManifestSection "TR" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
$ld = ProcessManifestSection "LD" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
$id = ProcessManifestSection "ID" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
$c = ProcessManifestSection "C" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
#$ad = ProcessManifestSection "AD" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath
##$rl = ProcessManifestSection "RL" $scripts $currentVersion $targetVersion $scriptsDir $dumpFile $dumpFilePath

#$allresults = @($udt, $t, $v, $f, $p, $tr, $id, $ld, $c, $ad)
$allresults = @($t, $v, $id, $ld, $c)

# Workaround to server issue returning $_.scriptsExecuted undefined

$targetVersionDescription = if ( $targetVersion -eq -1 ) { "latest ($maxVersion)" } else { $targetVersion }
$upgradedToVersion = if ( $targetVersion -eq -1 ) { $maxVersion } else { $targetVersion }

#	$matchCounter = ($allresults | % {$_.scriptsExecuted} | Measure-Object -Sum).Sum
#	$scriptCounter = ($allresults | % {$_.scriptsProcessed} | Measure-Object -Sum).Sum

#	Write-Output "$($newline)$matchCounter of $scriptCounter scripts required to upgrade version $currentVersion to $targetVersionDescription"
#	#Write-Output "$($scripts.Count) scripts to run"

# Ensure the version number is updated if working around the .scriptsExecuted issue
if(-not $dumpFile) {
    Write-Output "`r`nUpdating database version from $currentVersion to $upgradedToVersion..."
    $updateVersionQuery = "insert into DatabaseVersion(Version,VersionLabel) values($upgradedToVersion,'$targetVersionLabel')"

    # Look at refactor this code into a function
    try {
		if($dbusername -eq "") {		
			Invoke-Sqlcmd -EA Stop -Query $updateVersionQuery -Database $database -ServerInstance $dbserver -SuppressProviderContextWarning -Verbose    
		} else {
			Invoke-Sqlcmd -EA Stop -Query $updateVersionQuery -Database $database -ServerInstance $dbserver -Username $dbusername -Password $dbpassword -SuppressProviderContextWarning -Verbose
		}

        Write-Output "Version updated"
	} catch {            
		Write-Error $($_.Exception.Message)
	}
}

$endTime = Get-Date
$totalTime = ($endTime.Subtract($startTime)).Seconds
Write-Output "$($newline)Finished at $endTime total $totalTime seconds"
