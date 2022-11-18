Set-StrictMode -version 2
$ErrorActionPreference = "Stop"

$targetVersionLabel =  # this will come from the build server

$currentDirectory = Split-Path $MyInvocation.MyCommand.Path
$dbupdatePath = [System.IO.Path]::Combine($currentDirectory, "Scripts\dbupdate.ps1")
$manifestPath = [System.IO.Path]::Combine($currentDirectory, "Scripts\manifest.csv")
$scriptsPath = [System.IO.Path]::Combine($currentDirectory, "Scripts")

if($createDatabase -gt 0) {

	$dropOption = "no"
	if($resetDatabase -eq "true") {
		$dropOption = "drop_all_database_objects"
	}

	. $dbupdatePath -dbserver $databaseServer -database $databaseName -manifestFileName $manifestPath -dbusername $databaseUserName -dbpassword $databasePassword -scriptsDir $scriptsPath -targetVersionLabel $targetVersionLabel -dropConstraints 1 -currentVersion 0 -createDatabase -dropAllObjects $dropOption
} else {
	. $dbupdatePath -dbserver $databaseServer -database $databaseName -manifestFileName $manifestPath -dbusername $databaseUserName -dbpassword $databasePassword -scriptsDir $scriptsPath -targetVersionLabel $targetVersionLabel -dropConstraints 1 -currentVersion 0
}