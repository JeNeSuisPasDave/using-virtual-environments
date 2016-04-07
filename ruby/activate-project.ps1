# A script to activate the local version of Ruby
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

# Check that Ruby exists
#
$rblclDir = ".rblcl"
$rubyBinPath = "$cwd\$rblclDir\bin"
If (-not (Test-Path "$rubyBinPath\ruby.exe")) {
    Write-Output ""
    Write-Output "ERROR: Ruby is not installed in '.\$rblclDir'."
    Write-Output "Cannot activate Ruby virtual environment."
    Write-Output ""
    Exit
}

# Add Ruby to the path
#
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If ($pathParts.Contains("$rubyBinPath")) {
    $pathParts.Remove($rubyBinPath)
    $Env:Path = $pathParts -Join ';'
}
$Env:Path = "$rubyBinPath" + ";" +  "$Env:Path"

# Set the RBLCL_ environment variable
#
$Env:RBLCL_ = "$rubyBinPath"

# Adjust the prompt
#
# Note: borrowed this idea from the Python 2.7 activate.ps1 script
#
If (Test-Path function:_old_virtual_prompt_rb) {
    # Restore old prompt if it existed
    #
    $function:prompt = $function:_old_virtual_prompt_rb
    Remove-Item function:\_old_virtual_prompt_rb
}
Function global:_old_virtual_prompt_rb { "" }
$function:_old_virtual_prompt_rb = $function:prompt
Function global:prompt {
    # Add a prefix to the current prompt, but don't discard it.
    write-host "(rb) " -nonewline
    & $function:_old_virtual_prompt_rb
}

# Set the deactivation script
#
$deactivateFile = $scriptDir + "\deactivate-project.ps1"
"If (-Not (Test-Path `$Env:RBLCL_)) {" | Out-File $deactivateFile -Width 256
"  Write-Output `"Ruby virtual environment not active.`"" |
    Out-File $deactivateFile -Append -Width 256
"  Write-Output `"`"" | Out-File $deactivateFile -Append -Width 256
"}" | Out-File $deactivateFile -Append -Width 256
"[System.Collections.ArrayList]`$pathParts = `$Env:Path.split(';')" |
    Out-File $deactivateFile -Append -Width 256
"`$pathParts.Remove(`$Env:RBLCL_)" |
    Out-File $deactivateFile -Append -Width 256
"`$Env:Path = `$pathParts -Join ';'" |
    Out-File $deactivateFile -Append -Width 256
"`$Env:RBLCL_ = `"`"" | Out-File $deactivateFile -Append -Width 256
"Remove-Item `"$deactivateFile`"" |
    Out-File $deactivateFile -Append -Width 256
"" | Out-File $deactivateFile -Append -Width 256
"If (Test-Path function:_old_virtual_prompt_rb) {" |
    Out-File $deactivateFile -Append -Width 256
"    `$function:prompt = `$function:_old_virtual_prompt_rb" |
    Out-File $deactivateFile -Append -Width 256
"    Remove-Item function:\_old_virtual_prompt_rb" |
    Out-File $deactivateFile -Append -Width 256
"}" | Out-File $deactivateFile -Append -Width 256

# Get out
#
Write-Output ""
Write-Output "The Ruby virtual environment is activated."
Write-Output "To deactivate it, run '$deactivateFile'."
Write-Output ""
