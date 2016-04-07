# This script assumes that Ruby 2.2.3p173 is installed in
# C:\Program Files\Ruby200-p598
#
# If Ruby 2.2.3p173 is installed some other way, then the script will
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

# Set expected Ruby version and local deployment directory, along
# with some other initialization
#
$rubyVsnExpected = "2.2.3p173"
$rubyVsnMax = "2.2.3p174"
$rubyDownloadLoc = "http://rubyinstaller.org/downloads/archives"
$rblclDir = ".rblcl"
$rubyDir = "Ruby223-p173"

# Pick up the verification functions
#
. "$scriptDir\check-functions.src.ps1"

# Check whether Ruby 2.0.0p598 is installed
#
$rubyInstallBase = "$Env:ProgramFiles\$rubyDir"
If (-not (Test-Path "$rubyInstallBase")) {
    Write-Output ""
    Write-Output "ERROR: Ruby $rubyVsnExpected is not installed."
    Write-Output "       Expected '$rubyInstallBase'"
    Write-Output ("Install Ruby $rubyVsnExpected and then " +
            "try '$scriptName' again.")
    Exit
}
If (-not (Test-Path "$rubyInstallBase\bin\ruby.exe")) {
    Write-Output ""
    Write-Output "ERROR: Ruby $rubyVsnExpected is not installed."
    Write-Output "       Expected '$rubyInstallBase\bin\ruby.exe'"
    Write-Output ("Install Ruby $rubyVsnExpected and then " +
            "try '$scriptName' again.")
    Exit
}

# Check whether the local deployment directory exists. If missing,
# create it
#
$rblclOK = $False
If (-not (Test-Path ".\$rblclDir")) {
    New-Item -Path ".\$rblclDir" -ItemType directory
    If (Test-Path ".\$rblclDir") {
        $cargs = "/S,/E,/Q,`"$rubyInstallBase\*`",`".\$rblclDir\`"" -split ","
        $ccmd = "xcopy"
        Invoke-Expression "$ccmd $cargs"
    }
}

# Check whether ruby.exe exists
#
$rcmd = ".\$rblclDir\bin\ruby.exe"
If (-not (Test-Path "$rcmd")) {
    Write-Output ""
    Write-Output "ERROR: Ruby is not installed in '.\$rblclDir'."
    Write-Output ""
    Write-Output ("Rename or remove '.\$rblclDir' and then " +
        "try '$scriptName' again.")
    Write-Output ""
    Exit
}

# Check the ruby version
#
$rargs = "--version 2>&1" -split " "
$vsn = Invoke-Expression "$rcmd $rargs" | Extract-Version
$vsnString = "$($vsn.Major).$($vsn.Minor).$($vsn.Patch)$($vsn.Qualifier)"
$minVsn = Extract-Version $rubyVsnExpected
$maxVsn = Extract-Version $rubyVsnMax
If ((-not (Test-Version $vsn -IsAtLeast $minVsn)) `
-or (-not (Test-Version $vsn -IsLessThan $maxVsn))) {
    Write-Output ""
    Write-Output ("ERROR: Expecting Ruby $rubyVsnExpected or later, " +
        "up to $rubyVsnMax")
    Write-Output "Found $vsnString at '$rcmd'."
    Write-Output ""
    Exit
}

# Add the local Ruby bin directory to the PATH
#
$rubyBinPath = "$cwd\$rblclDir\bin"
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If ($pathParts.Contains("$rubyBinPath")) {
    $pathParts.Remove($rubyBinPath)
    $Env:Path = $pathParts -Join ';'
}
$Env:Path = "$rubyBinPath" + ";" +  "$Env:Path"

# Check bundler; install if necessary
#
$rcmd = "gem"
$rargs = "list --no-versions" -split " "
[System.Collections.ArrayList]$gems = Invoke-Expression "$rcmd $rargs"
If (-not $gems.Contains("bundler")) {
    $rargs2 = "install bundler" -split " "
    Invoke-Expression "$rcmd $rargs2"
}
[System.Collections.ArrayList]$gems = Invoke-Expression "$rcmd $rargs"

# Remove the local Ruby bin directory from the Path
#
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If ($pathParts.Contains("$rubyBinPath")) {
    $pathParts.Remove($rubyBinPath)
    $Env:Path = $pathParts -Join ';'
}

# Did we really get bundler installed?
#
If (-not $gems.Contains("bundler")) {
    Write-Output ""
    Write-Output ("ERROR: Failed to install the gem 'bundler'.")
    Write-Output ""
    Exit
}

# Done!
#
Write-Output ""
Write-Output "OK. Virtual environment for Ruby $rubyVsnExpected is created."
Write-Output "Use the command '.\activate-project.ps1' to activate;"
Write-Output "Use command '.\deactivate-project.ps1' to deactivate."
Write-Output ""
