# A script to provision the Go development project
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

# Check that we are running in a Go virtual environment
#
. "$scriptDir\check-active-venv-functions.src.ps1"
$r = IsActive-VenvGoLang
If (-not ($r.Success)) {
    foreach ($msg in $r.Message) {
        Write-Output $msg
    }
    Exit
}

# Check that the Go version is correct
#
$minVsn = "$golangVsnExpected" | Extract-Version
$maxVsn = "$golangVsnMax" | Extract-Version
$r = Check-VersionGoLang $minVsn $maxVsn
If (-not ($r.Success)) {
    foreach ($msg in $r.Message) {
        Write-Output $msg
    }
    Exit
}

# Make sure the bin, pkg, and src folders exist
#
if (-not (Test-Path "$Env:GOPATH\bin")) {
    New-Item "$Env:GOPATH\bin" -ItemType "directory"
}
if (-not (Test-Path "$Env:GOPATH\pkg")) {
    New-Item "$Env:GOPATH\pkg" -ItemType "directory"
}
if (-not (Test-Path "$Env:GOPATH\src")) {
    New-Item "$Env:GOPATH\src" -ItemType "directory"
}

# Check that the project source has been placed in the workspace
#
if (-not (Test-Path "$Env:GOPATH\src\github.com\hashicorp\raft")) {
    Write-Output "Clone the 'hashicorp/raft' repository to " +
        "'$Env:GOPATH/src/github.com/hashicorp/raft'"
    Exit
}
if (-not (Test-Path "$Env:GOPATH\src\github.com\hashicorp\raft\raft.go")) {
    Write-Output "Checkout a complete branch into " +
        "'$Env:GOPATH/src/github.com/hashicorp/raft'"
    Exit
}

# Check whether Glide is available; 
# will install Glide if not already installed
#
. "$scriptDir\get-glide-functions.src.ps1"
. "$scriptDir\check-active-glide-functions.src.ps1"

# Check whether Glide is available from the Go virtual environment
#
$glideVsn = "0.12.2"
If (-not (Is-GlideInstalled)) {
    $r = Install-Glide "$glideVsn"
    $r = Is-GlideAvailable
    If (-not ($r.Success)) {
        foreach ($msg in $r.Message) {
            Write-Output $msg
        }
        Exit
    }
}

# Check that the Glide version is correct
#
$r = Check-VersionGlide "$glideVsn"
If (-not ($r.Success)) {
    foreach ($msg in $r.Message) {
        Write-Output $msg
    }
    Exit
}

# install the dependencies
#
$rcmd = "glide"
$rargs = "--quiet install 2>&1" -split " "
Invoke-Expression "& $rcmd $rargs" 
