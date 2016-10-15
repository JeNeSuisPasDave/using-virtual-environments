# A script to activate the local version of Go
#
Set-Strictmode -version Latest

# Capture the file name of this powershell script
#
$scriptName = $MyInvocation.InvocationName
$scriptDir = $PSScriptRoot
$cwd = (Get-Item -Path ".\" -Verbose).FullName

# Set error code
#
$errorcode = 0

# Pick up the activation functions
#
. "$scriptDir\activation-functions.src.ps1"

# Activate local Go
#
$result = Activate-Golang ".golcl\1.6.3" "$cwd" 

# Announce results
#
If ($result.Success) {
    Write-Output ""
    Write-Output "The Go virtual environment is activated."
    Write-Output "To deactivate it, run '$($result.DeactivateScript)'."
    Write-Output ""
}
