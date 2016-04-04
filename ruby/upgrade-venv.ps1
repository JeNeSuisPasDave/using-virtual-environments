# This script assumes that Ruby 2.0.0p598 is installed in
# C:\Program Files\Ruby200-p598
#
# If Ruby 2.0.0p598 is installed some other way, then the script will
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
$rubyVsnExpected = "2.0.0p598"
$rubyVsnMax = "2.0.0p599"
$rubyDownloadLoc = "http://rubyinstaller.org/downloads/archives"
$rblclDir = ".rblcl"
$rubyDir = "Ruby200-p598"

# Pick up the verification functions
#
. "$scriptDir\check-functions.src.ps1"

# Check that we are running in a Ruby virtual environment
#
. "$scriptDir\check-active-venv.src.ps1"
If (0 -ne $errcode) {
    Exit
}

# Check that a Gemfile exists
#
If (-not (Test-Path "Gemfile")) {
    Write-Output ""
    Write-Output "ERROR: Missing Gemfile; cannot update with 'bundler'."
    Write-Output ""
    Exit
}
# Install required packages
#
bundle update
gem cleanup

# Check that we have the needed packages
#
. "$scriptDir\check-dependencies.src.ps1"
If (0 -ne $errcode) {
    Exit
}

# Done!
#
Write-Output ""
Write-Output ("OK. May have updated required packages for project in " +
    "Ruby $rubyVsnExpected virtual environment.")
Write-Output ""
