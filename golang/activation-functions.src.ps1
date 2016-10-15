<#
.SYNOPSIS
Activate the local Go virtual environment.
.DESCRIPTION
This function adds the Go binaries to the $Path and modifies the
command prompt to indicate that a Go virtual environment is active.
It also creates a deactivation script that can be used to restore the
original command prompt and remove the local Go from the $Path.
.PARAMETER LocalGolangDirectory
A string containing the relative path of the local Go deployment (e.g.,
'.golcl\1.6.3').
.PARAMETER WorkspaceDirectory
A string containing the relative path of the project workspace directory.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
DeactivationScript (string).
#>
Function Activate-Golang {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$false,
            Position=0)]
        [AllowEmptyString()]
        [string]$LocalGolangDirectory,

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$false,
            Position=1)]
        # See http://stackoverflow.com/a/6409122 for AllowEmptyString() tip
        [AllowEmptyString()]
        [string]$WorkspaceDirectory
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

    # Convert input paths to absolute paths
    #
    $LocalGolangDirectory = (
        Get-Item -Path "$LocalGolangDirectory" -Verbose).FullName
    $WorkspaceDirectory = (
        Get-Item -Path "$WorkspaceDirectory" -Verbose).FullName

    # Check that Go exists
    #
    $golangBinPath = "$LocalGolangDirectory\go\bin"
    If (-not (Test-Path "$golangBinPath\go.exe")) {
        Write-Host ""
        Write-Host "ERROR: Go is not installed in '.\$LocalGolangDirectory'."
        Write-Host "Cannot activate Go virtual environment."
        Write-Host ""
        Write-Host "Consider installing Go with '.\make-venv.ps1'."
        Write-Host ""
        return $result
    }

    # Set GOROOT, GOPATH, and golangBinPath
    #
    $Env:GOROOT = "$LocalGolangDirectory\go"
    $Env:GOPATH = "$WorkspaceDirectory"
    $Env:GOBIN = "$WorkspaceDirectory\bin"
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    $found = $false
    If ($pathParts.Contains("$Env:GOROOT\bin")) {
        $pathParts.Remove("$Env:GOROOT\bin")
        $found = $true
    }
    If ($pathParts.Contains("$Env:GOBIN")) {
        $pathParts.Remove("$Env:GOBIN")
        $found = $true
    }
    if ($found) {
        $Env:Path = $pathParts -Join ';'
    }
    $Env:Path = "$Env:GOBIN" + ";"  + "$Env:GOROOT\bin" + ";" +  "$Env:Path"

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
        Write-Host "(go) " -nonewline
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
    "Deactivate-Golang `"$deactivateFile`" | Out-Null" |
        Out-File $deactivateFile -Append -Width 256

    # Get out
    #
    $result.Success = $true
    $result.DeactivateScript = $deactivateFile
    return $result
}

<#
.SYNOPSIS
Deactivate the local Go virtual environment.
.DESCRIPTION
This function removes the Go binaries to the $Path and modifies the
command prompt to remove the indication that a Go virtual environment
is active. It also removes the deactivation script, if any.
.PARAMETER DeactivateScript
A string containing the path of the deactivation script. The script will
be removed by this function.
.OUTPUTS
System.Boolean. $true if any action was taken; otherwise, $false.
#>
Function Deactivate-Golang{
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
    If (-Not (Test-Path $Env:GOPATH)) {
        Write-Host "Go virtual environment not active."
        Write-Host ""
        return $false
    }

    # Remove Go binary directories from the $Path
    #
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    $pathParts.Remove("$Env:GOBIN")
    $pathParts.Remove("$Env:GOROOT\bin")
    $Env:Path = $pathParts -Join ';'
    $Env:GOROOT = ""
    $Env:GOPATH = ""
    $Env:GOBIN = ""

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
