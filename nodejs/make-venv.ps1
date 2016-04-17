# This script assumes that Node.js v4.4.2 is installed in
# C:\Program Files (x86)\nodejs-v4.4.2
#
# If Node.js v4.4.2 is installed some other way, then the script will
# need some adjustment.
#
Set-Strictmode -version Latest

# Capture the file name of this powershell script
#
$scriptName = $MyInvocation.InvocationName
$scriptDir = $PSScriptRoot
$cwd = (Get-Item -Path ".\" -Verbose).FullName

# Set error code
#
$errcode = 0

# Set expected Node.js version and local deployment directory, along
# with some other initialization
#
$nodejsVsnExpected = "v4.4.2"
$nodejsVsnMax = "v4.4.3"
$nodejsDownloadLoc = "https://nodejs.org/en/download/releases/"
$jslclDir = ".jslcl"
$nodejsDir = "nodejs-v4.4.2"

# Pick up the verification functions
#
. "$scriptDir\check-functions.src.ps1"

# Check whether Node.js v4.4.2 is installed
#
$nodejsInstallBase = Get-ChildItem -Path "Env:ProgramFiles"
$nodejsInstallBase = $nodejsInstallBase[0].Value
$nodejsInstallBase = "$nodejsInstallBase\$nodejsDir"
If (-not (Test-Path "$nodejsInstallBase")) {
    Write-Output ""
    Write-Output "ERROR: Node.js $nodejsVsnExpected is not installed."
    Write-Output "       Expected '$nodejsInstallBase'"
    Write-Output ("Install Node.js $nodejsVsnExpected and then " +
            "try '$scriptName' again.")
    Exit
}
If (-not (Test-Path "$nodejsInstallBase\node.exe")) {
    Write-Output ""
    Write-Output "ERROR: Node.js $nodejsVsnExpected is not installed."
    Write-Output "       Expected '$nodejsInstallBase\bin\nodejs.exe'"
    Write-Output ("Install Node.js $nodejsVsnExpected and then " +
            "try '$scriptName' again.")
    Exit
}

# Check whether the local deployment directory exists. If missing,
# create it
#
$jslclOK = $False
If (-not (Test-Path ".\$jslclDir")) {
    New-Item -Path ".\$jslclDir" -ItemType directory | Out-Null
    If (Test-Path ".\$jslclDir") {
        $cargs = "/S,/E,/Q,`"$nodejsInstallBase\*`",`".\$jslclDir\`"" -split ","
        $ccmd = "xcopy"
        Invoke-Expression "$ccmd $cargs"
    }
}

# Check whether nodejs.exe exists
#
$rcmd = ".\$jslclDir\node.exe"
If (-not (Test-Path "$rcmd")) {
    Write-Output ""
    Write-Output "ERROR: Node.js is not installed in '.\$jslclDir'."
    Write-Output ""
    Write-Output ("Rename or remove '.\$jslclDir' and then " +
        "try '$scriptName' again.")
    Write-Output ""
    Exit
}

# Check the nodejs version
#
$rargs = "--version 2>&1" -split " "
$vsn = Invoke-Expression "$rcmd $rargs" | Extract-Version
$vsnString = "$($vsn.Major).$($vsn.Minor).$($vsn.Patch)$($vsn.Qualifier)"
$minVsn = Extract-Version $nodejsVsnExpected
$maxVsn = Extract-Version $nodejsVsnMax
If ((-not (Test-Version $vsn -IsAtLeast $minVsn)) `
-or (-not (Test-Version $vsn -IsLessThan $maxVsn))) {
    Write-Output ""
    Write-Output ("ERROR: Expecting Node.js $nodejsVsnExpected or later, " +
        "up to $nodejsVsnMax")
    Write-Output "Found $vsnString at '$rcmd'."
    Write-Output ""
    Exit
}

# Add the local Node.js bin directory to the PATH
#
$nodejsBinPath = "$cwd\$jslclDir"
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If ($pathParts.Contains("$nodejsBinPath")) {
    $pathParts.Remove($nodejsBinPath)
    $Env:Path = $pathParts -Join ';'
}
$Env:Path = "$nodejsBinPath" + ";" +  "$Env:Path"

# Remove the local Node.js bin directory from the Path
#
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If ($pathParts.Contains("$nodejsBinPath")) {
    $pathParts.Remove($nodejsBinPath)
    $Env:Path = $pathParts -Join ';'
}

# Done!
#
Write-Output ""
Write-Output "OK. Virtual environment for Node.js $nodejsVsnExpected is created."
Write-Output "Use the command '.\activate-project.ps1' to activate;"
Write-Output "Use command '.\deactivate-project.ps1' to deactivate."
Write-Output ""
