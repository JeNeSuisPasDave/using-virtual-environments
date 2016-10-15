# This script assumes that the 64-bit version of Go 1.6.3 is available in 
# ~\Frameworks\go.framework as a zip archive
#
# If Go 1.6.3 is available in some other way, then the script will
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

# Pick up the verification functions
#
. "$scriptDir\check-functions.src.ps1"

# Set expected Go version and local deployment directory, along
# with some other initialization
#
$golangDownloadLoc = "https://golang.org/dl/"
$golangDist = "go1.6.3.windows-amd64.zip"
$golangVsnExpected = "v1.6.3"
$golangVsnMax = "v1.6.4"
$vsn = $golangVsnExpected | Extract-Version
$vsnString = "$($vsn.Major).$($vsn.Minor).$($vsn.Patch)$($vsn.Qualifier)"
$golclDir = ".golcl"
$golclDir = "$golclDir\$vsnString"

# Pick up the go version check functions
#
. "$scriptDir\check-active-venv-functions.src.ps1"

# Check whether 7-Zip is installed
#
$zcmd = "$Env:ProgramFiles\7-Zip\7z.exe"
If (-not (Test-Path "$zcmd")) {
    Write-Output ""
    Write-Output "ERROR: 7-Zip is not installed."
    Write-Output ""
    Write-Output ("Download and install the 64-bit version of 7-zip from " +
        "http://www.7-zip.org/.")
    Write-Output ""
    Exit
}

# Parse the expected Go version
#

# Check whether Go v1.6.3 installation is available
#
$golangInstallBase = "$Env:USERPROFILE\Frameworks\go.framework"
$golangInstallBase = "$golangInstallBase\$golangDist"
If (-not (Test-Path "$golangInstallBase")) {
    Write-Output ""
    Write-Output "ERROR: Go $golangVsnExpected distribution is not found."
    Write-Output "       Expected '$golangInstallBase'"
    Write-Output ("Download and save Go $golangVsnExpected distribution " +
      "and then try '$scriptName' again.")
    Exit
}

# Check whether the local deployment directory exists. If missing,
# create it
#
$golclOK = $False
If (-not (Test-Path ".\$golclDir")) {
    New-Item -Path ".\$golclDir" -ItemType directory | Out-Null
    If (Test-Path ".\$golclDir") {
        $cargs = "x,`"-o$golclDir`",`"$golangInstallBase`"" -split ","
        $ccmd = "`"$zcmd`""
        Invoke-Expression "& $ccmd $cargs"
    }
}

# Check whether golang.exe exists
#
$rcmd = ".\$golclDir\go\bin\go.exe"
If (-not (Test-Path "$rcmd")) {
    Write-Output ""
    Write-Output "ERROR: Go is not installed in '.\$golclDir'."
    Write-Output ""
    Write-Output ("Rename or remove '.\$golclDir' and then " +
        "try '$scriptName' again.")
    Write-Output ""
    Exit
}

# Check the golang version
#
$minVsn = Extract-Version $golangVsnExpected
$maxVsn = Extract-Version $golangVsnMax
$oldGoroot = "$Env:GOROOT"
$Env:GOROOT = "$cwd\$golclDir\go"
$r = Check-VersionGoLang $minVsn $maxVsn
$Env:GOROOT = "$oldGoroot"
If (-not ($r.Success)) {
    foreach ($msg in $r.Message) {
        Write-Output $msg
    }
    Exit
}

# Done!
#
Write-Output ""
Write-Output "OK. Virtual environment for Go $golangVsnExpected is created."
Write-Output "Use the command '.\activate-project.ps1' to activate;"
Write-Output "Use command '.\deactivate-project.ps1' to deactivate."
Write-Output ""
