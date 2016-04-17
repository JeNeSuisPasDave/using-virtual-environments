<#
.SYNOPSIS
Activate the local Node.js virtual environment.
.DESCRIPTION
This function adds the Node.js binaries to the $Path and modifies the
command prompt to indicate that a Node.js virtual environment is active.
It also creates a deactivation script that can be used to restore the
original command prompt and remove the local Node.js from the $Path.
.PARAMETER CurrentDirectory
A string containing the absolute path of the project root directory
(specifically, the directory containing the local Node.js deployment).
.PARAMETER LocalNodeJsDirectory
A string containing the relative path of the local Node.js deployment (e.g.,
'.jslcl').
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
DeactivationScript (string).
#>
Function Activate-NodeJs {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$false,
            Position=0)]
        # See http://stackoverflow.com/a/6409122 for AllowEmptyString() tip
        [AllowEmptyString()]
        [string]$CurrentDirectory,

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$false,
            Position=1)]
        [AllowEmptyString()]
        [string]$LocalNodeJsDirectory
    )
    # Initialize the result
    #
    $props = @{
        Success = $false
        DeactivateScript = ""
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Where am i?
    #
    $scriptDir = $PSScriptRoot

    # Check that Node.js exists
    #
    $jslclDir = $LocalNodeJsDirectory
    $nodejsBinPath = "$CurrentDirectory\$LocalNodeJsDirectory"
    If (-not (Test-Path "$nodejsBinPath\node.exe")) {
        Write-Host ""
        Write-Host "ERROR: Node.js is not installed in '.\$jslclDir'."
        Write-Host "Cannot activate Node.js virtual environment."
        Write-Host ""
        return $result
    }

    # Add Node.js and local npm modules to the path
    #
    $pkgjsBinPath = "$CurrentDirectory\node_modules\.bin"
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    $found = $false
    If ($pathParts.Contains("$nodejsBinPath")) {
        $pathParts.Remove($nodejsBinPath)
        $found = $true
    }
    If ($pathParts.Contains("$pkgjsBinPath")) {
        $pathParts.Remove($pkgjsBinPath)
        $found = $true
    }
    if ($found) {
        $Env:Path = $pathParts -Join ';'
    }
    $Env:Path = "$nodejsBinPath" + ";"  + "$pkgjsBinPath" + ";" +  "$Env:Path"

    # Set the JSLCL_ environment variable
    #
    $Env:JSLCL_ = "$nodejsBinPath"
    $Env:JSPKGLCL_ = "$pkgjsBinPath"

    # Adjust the prompt
    #
    # Note: borrowed this idea from the Python 2.7 activate.ps1 script
    #
    If (Test-Path function:_old_virtual_prompt_js) {
        # Restore old prompt if it existed
        #
        $Function:prompt = $Function:_old_virtual_prompt_js
        Remove-Item function:\_old_virtual_prompt_js
    }
    Function global:_old_virtual_prompt_js { "" }
    $Function:_old_virtual_prompt_js = $Function:prompt
    Function global:prompt {
        # Add a prefix to the current prompt, but don't discard it.
        Write-Host "(js) " -nonewline
        & $Function:_old_virtual_prompt_js
    }

    # Set the deactivation script
    #
    $deactivateFile = $scriptDir + "\deactivate-venv.ps1"
    "Set-Strictmode -version Latest" | Out-File $deactivateFile -Width 256
    "`$scriptDir = `$PSScriptRoot" |
        Out-File $deactivateFile -Append -Width 256
    ". `"`$scriptDir\activation-functions.src.ps1`"" |
        Out-File $deactivateFile -Append -Width 256
    "Deactivate-NodeJs `"$deactivateFile`" | Out-Null" |
        Out-File $deactivateFile -Append -Width 256

    # Get out
    #
    $result.Success = $true
    $result.DeactivateScript = $deactivateFile
    return $result
}

<#
.SYNOPSIS
Deactivate the local Node.js virtual environment.
.DESCRIPTION
This function removes the Node.js binaries to the $Path and modifies the
command prompt to remove the indication that a Node.js virtual environment
is active. It also removes the deactivation script, if any.
.PARAMETER DeactivateScript
A string containing the path of the deactivation script. The script will
be removed by this function.
.OUTPUTS
System.Boolean. $true if any action was taken; otherwise, $false.
#>
Function Deactivate-NodeJs{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$false,
            Position=0)]
        # See http://stackoverflow.com/a/6409122 for AllowEmptyString() tip
        [AllowEmptyString()]
        [string]$DeactivateScript
    )
    If (-Not (Test-Path $Env:JSLCL_)) {
        Write-Host "Node.js virtual environment not active."
        Write-Host ""
        return $false
    }

    # Remove Node.js binary directories from the $Path
    #
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    $pathParts.Remove($Env:JSLCL_)
    If (Test-Path $Env:JSPKGLCL_) {
        $pathParts.Remove($Env:JSPKGLCL_)
    }
    $Env:Path = $pathParts -Join ';'
    $Env:JSLCL_ = ""
    $Env:JSPKGLCL_ = ""

    # Remove the virtual enviroment indication from the command prompt
    #
    If (Test-Path function:_old_virtual_prompt_js) {
        $function:prompt = $function:_old_virtual_prompt_js
        Remove-Item function:\_old_virtual_prompt_js
    }

    # Remove the deactivation script
    #
    if (Test-Path "$DeactivateScript") {
        Remove-Item "$DeactivateScript"
    }

    # Get out
    #
    return $true
}