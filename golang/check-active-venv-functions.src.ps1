# NOTE: expect that this is preceded by this source command:
# . check-functions.src.ps1
#
# NOTE: Expect that these variables are already populated:
#
# $scriptName = $MyInvocation.InvocationName
# $scriptDir = $PSScriptRoot
# $cwd = (Get-Item -Path ".\" -Verbose).FullName
# $golangDownloadLoc = "https://golang.org/dl/"
# $golangDist = "go1.6.3.windows-amd64.zip"
# $golangVsnExpected = "v1.6.3"
# $golangVsnMax = "v1.6.4"
# $vsn = $golangVsnExpected | Extract-Version
# $vsnString = "$($vsn.Major).$($vsn.Minor).$($vsn.Patch)$($vsn.Qualifier)"
# $golclDir = ".golcl"
# $golclDir = "$golclDir\$vsnString"

<#
.SYNOPSIS
Determine whether a Go virtual environment is active.
.DESCRIPTION
Determine whether a Go virtual environment is active.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the virtual environment is active,
otherwise false. If not Success, then Message will contain the error
message lines.
#>
Function IsActive-VenvGoLang {
    [CmdletBinding()]

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Does the local Go directory exist?
    #
    If (-not (Test-Path ".\$golclDir")) {
        $result.Message = @( "",
            "ERROR: A local Go is not installed.",
            "Run 'make-venv.ps1' to install the Go virtual environment.",
            "")
        return $result
    }

    # Is Go installed?
    #
    $golangBinPath = "$cwd\$golclDir\go\bin"
    If (-not (Test-Path "$golangBinPath\go.exe")) {
        $result.Message = @( "",
            "ERROR: Go is not installed in '.\$golclDir'.",
            "Run 'make-venv.ps1' to install the Go virtual environment.",
            "" )
        return $result
    }

    # Is the Go virtual environment activated?
    #
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    If (-not $pathParts.Contains("$golangBinPath")) {
        $result.Message = @( "",
            "ERROR: Go virtual environment not active.",
            ("Run 'activate-project.ps1' to activate " +
            "the Go virtual environment."),
            "" )
        return $result
    }
    if (-not (Test-Path "$Env:GOPATH")) {
        $result.Message = @( "",
            "ERROR: Go virtual environment not active.",
            ("Run 'activate-project.ps1' to activate " +
            "the Go virtual environment."),
            "" )
        return $result
    }
    $gowsBinPath = "$Env:GOPATH\bin"
    [System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
    If (-not $pathParts.Contains("$gowsBinPath")) {
        $result.Message = @( "",
            "ERROR: Go virtual environment not active.",
            ("Run 'activate-project.ps1' to activate " +
            "the Go virtual environment."),
            "" )
        return $result
    }

    # Get out
    #
    $result.Success = $true
    return $result
}

<#
.SYNOPSIS
Check whether the Go version is correct
.DESCRIPTION
Compares the active Go version with the provided range.
.PARAMETER IsAtLeast
System.String or an object containing Major, Minor, Patch, and Qualifier
members (as produced by the Extract-Version function). Used to test whether
Version parameter is equal to or greater than the IsAtLeast parameter.
.PARAMETER IsLessThan
System.String or an object containing Major, Minor, Patch, and Qualifier
members (as produced by the Extract-Version function). Used to test whether
Version parameter is less than the IsLessThan parameter.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the Go version is correct,
otherwise false. If not Success, then Message will contain the error
message lines.
#>
Function Check-VersionGoLang {
    [CmdletBinding()]
    param(
        [PSObject]$IsAtLeast,
        [PSObject]$IsLessThan
    )

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Get Go version
    #
    $rcmd = "$Env:GOROOT\bin\go.exe"
    $rargs = "version 2>&1" -split " "
    $actVsn = Invoke-Expression "& $rcmd $rargs" | Extract-Version

    # Test Go version
    #
    If ((-not (Test-Version $actVsn -IsAtLeast $IsAtLeast)) `
    -or (-not (Test-Version $actVsn -IsLessThan $IsLessThan))) {
        $actVsnString = "$($actVsn.Major).$($actVsn.Minor)." +
            "$($actVsn.Patch)$($actVsn.Qualifier)"
        $minVsnString = "$($IsAtLeast.Major).$($IsAtLeast.Minor)." +
            "$($IsAtLeast.Patch)$($IsAtLeast.Qualifier)"
        $maxVsnString = "$($IsLessThan.Major).$($IsLessThan.Minor)." +
            "$($IsLessThan.Patch)$($IsLessThan.Qualifier)"
        $result.Message = @( "",
            ("ERROR: Expecting Go $minVsnString or later, " +
                "up to $maxVsnString"),
            "Found $actVsnString at '$Env:GOROOT\bin\go.exe'."
            "" )
        return $result
    }

    # Get out
    #
    $result.Success = $true
    return $result
}
