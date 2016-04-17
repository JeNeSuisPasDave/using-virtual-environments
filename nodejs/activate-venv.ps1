# A script to activate the local version of Node.js
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

# Activate local Node.js
#
$result = Activate-NodeJs "$cwd" ".jslcl"

# Announce results
#
If ($result.Success) {
    Write-Output ""
    Write-Output "The Node.js virtual environment is activated."
    Write-Output "To deactivate it, run '$($result.DeactivateScript)'."
    Write-Output ""
}

# # Check that Node.js exists
# #
# $jslclDir = ".jslcl"
# $nodejsBinPath = "$cwd\$jslclDir"
# If (-not (Test-Path "$nodejsBinPath\node.exe")) {
#     Write-Output ""
#     Write-Output "ERROR: Node.js is not installed in '.\$jslclDir'."
#     Write-Output "Cannot activate Node.js virtual environment."
#     Write-Output ""
#     Exit
# }

# # Add Node.js and local npm modules to the path
# #
# $pkgjsBinPath = "$cwd\node_modules\.bin"
# [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
# $found = $false
# If ($pathParts.Contains("$nodejsBinPath")) {
#     $pathParts.Remove($nodejsBinPath)
#     $found = $true
# }
# If ($pathParts.Contains("$pkgjsBinPath")) {
#     $pathParts.Remove($pkgjsBinPath)
#     $found = $true
# }
# if ($found) {
#     $Env:Path = $pathParts -Join ';'
# }
# $Env:Path = "$nodejsBinPath" + ";"  + "$pkgjsBinPath" + ";" +  "$Env:Path"

# # Set the JSLCL_ environment variable
# #
# $Env:JSLCL_ = "$nodejsBinPath"
# $Env:JSPKGLCL_ = "$pkgjsBinPath"

# # Adjust the prompt
# #
# # Note: borrowed this idea from the Python 2.7 activate.ps1 script
# #
# If (Test-Path function:_old_virtual_prompt_js) {
#     # Restore old prompt if it existed
#     #
#     $function:prompt = $function:_old_virtual_prompt_js
#     Remove-Item function:\_old_virtual_prompt_js
# }
# Function global:_old_virtual_prompt_js { "" }
# $function:_old_virtual_prompt_js = $function:prompt
# Function global:prompt {
#     # Add a prefix to the current prompt, but don't discard it.
#     write-host "(js) " -nonewline
#     & $function:_old_virtual_prompt_js
# }

# # Set the deactivation script
# #
# $deactivateFile = $scriptDir + "\deactivate-venv.ps1"
# "If (-Not (Test-Path `$Env:JSLCL_)) {" | Out-File $deactivateFile -Width 256
# "    Write-Output `"Node.js virtual environment not active.`"" |
#     Out-File $deactivateFile -Append -Width 256
# "    Write-Output `"`"" | Out-File $deactivateFile -Append -Width 256
# "}" | Out-File $deactivateFile -Append -Width 256
# "[System.Collections.ArrayList]`$pathParts = `$Env:Path.split(';')" |
#     Out-File $deactivateFile -Append -Width 256
# "`$pathParts.Remove(`$Env:JSLCL_)" |
#     Out-File $deactivateFile -Append -Width 256
# "If (Test-Path `$Env:JSPKGLCL_) {" |
#     Out-File $deactivateFile -Append -Width 256
# "    `$pathParts.Remove(`$Env:JSPKGLCL_)" |
#     Out-File $deactivateFile -Append -Width 256
# "}" | Out-File $deactivateFile -Append -Width 256
# "`$Env:Path = `$pathParts -Join ';'" |
#     Out-File $deactivateFile -Append -Width 256
# "`$Env:JSLCL_ = `"`"" | Out-File $deactivateFile -Append -Width 256
# "`$Env:JSPKGLCL_ = `"`"" | Out-File $deactivateFile -Append -Width 256
# "Remove-Item `"$deactivateFile`"" |
#     Out-File $deactivateFile -Append -Width 256
# "" | Out-File $deactivateFile -Append -Width 256
# "If (Test-Path function:_old_virtual_prompt_js) {" |
#     Out-File $deactivateFile -Append -Width 256
# "    `$function:prompt = `$function:_old_virtual_prompt_js" |
#     Out-File $deactivateFile -Append -Width 256
# "    Remove-Item function:\_old_virtual_prompt_js" |
#     Out-File $deactivateFile -Append -Width 256
# "}" | Out-File $deactivateFile -Append -Width 256

# # Get out
# #
# Write-Output ""
# Write-Output "The Node.js virtual environment is activated."
# Write-Output "To deactivate it, run '$deactivateFile'."
# Write-Output ""
