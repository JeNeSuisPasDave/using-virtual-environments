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
$scriptDir = $PSScriptRoot + "\nodejs"
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

# Check for active virtual environment
#

# Check that we are running in a Node.js virtual environment
#
. "$scriptDir\check-active-venv.src.ps1"
If (0 -ne $errcode) {
    Exit
}

# Check for required dependencies
#
. "$scriptDir\check-dependencies.src.ps1"
If (0 -ne $errcode) {
    Exit
}

# Do it!
#
Write-Output ""
Write-Output "OK. Done!"
Write-Output ""
