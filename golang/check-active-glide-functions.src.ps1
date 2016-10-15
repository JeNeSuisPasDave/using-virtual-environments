<#
.SYNOPSIS
Install glide if not already installed
.DESCRIPTION
Install glide if not already installed.
.PARAMETER Version
A string identifying the Glide version number to download. If missing or
empty, then install the latest glide.
.INPUTS
A string containing the Glide version number.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the virtual environment is active,
otherwise false. If not Success, then Message will contain the error 
message lines.
#>
Function Install-Glide {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0)]
        # See http://stackoverflow.com/a/6409122 for AllowEmptyString() tip
        [AllowEmptyString()]
        [string]$Version
    )

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Go OK?
    #
    if (-not (Is-Null $Version)) {
        $vsn = Extract-Version "$Version"
        $Version = "$($vsn.Major).$($vsn.Minor)." +
            "$($vsn.Patch)$($vsn.Qualifier)"
    } else {
        $Version = ""
    }
    $rc = Verify-GoOkForGlide
    if (-not ($rc.Success)) {
        $result.Message = $r.Message
        return $result
    }

    # Install Glide, if necessary
    #
    If (-not (Is-GlideInstalled)) {
        # What OS and Architecture?
        #
        $Os = Get-Os
        $Arch = Get-Arch

        # Download the release
        #
        $rc = $(Download-GlideRelease $Os $Arch $Version)
        if (-not ($rc.Success)) {
            $result.Message = $r.Message
            return $result
        }
        $release = $rc.FilePath

        # Install the release
        #
        $rc = Install-GlideRelease $release $Os $Arch "$Env:GOBIN"
        if (-not ($rc.Success)) {
            $result.Message = $r.Message
            return $result
        }
    }

    # Get out
    #
    $result.Success = $true
    return $result
}

<#
.SYNOPSIS
Checks whether Glide is installed in the virtual environment, 
but does it silently
.DESCRIPTION
Checks whether Glide is installed in the virtual environment, 
but does it silently.
.INPUTS
None
.OUTPUTS
True if Glide is installed in the virtual envionrment; otherwise, false.
#>
Function Is-GlideInstalled {
    If (Test-Path "$Env:GOBIN\glide.exe") {
        return $true
    }
    return $false
}

<#
.SYNOPSIS
Checks whether Glide is installed in the virtual environment
.DESCRIPTION
Checks whether Glide is installed in the virtual environment.
.INPUTS
None
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if Glide is installed in the virtual
environment, otherwise false. If not Success, then Message will contain 
the error message lines.
#>
Function Is-GlideAvailable {

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Check whether Glide is installed
    #
    $glidePath = ""
    Try {
        $glidePath = (Get-Command glide).Source
    } Catch {
        $glidePath = ""
    }
    If (Is-Null $glidePath) {
        $result.Message = ( "",
            "ERROR: Glide is not installed.",
            "" )
        return $result
    }

    # Is it installed in the virtual environment?
    #
    $expectedPath = "$Env:GOBIN\glide.exe"
    If (-not ($expectedPath -eq $glidePath)) {
        $result.Message = ( "",
            "ERROR: Glide is not installed in the Go virtual environment.",
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
Install glide if not already installed
.DESCRIPTION
Install glide if not already installed.
.PARAMETER Version
A string identifying the Glide version number to download. If missing or
empty, then install the latest glide.
.INPUTS
A string containing the Glide version number.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the Glide version is correct,
otherwise false. If not Success, then Message will contain the error 
message lines.
#>
Function Check-VersionGlide {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0)]
        [string]$Version
    )

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Get the Glide version
    #
    $rcmd = "glide"
    $rargs = "-v 2>&1" -split " "
    $actVsn = Invoke-Expression "& $rcmd $rargs" | Extract-Version
    $actVsnString = "$($actVsn.Major).$($actVsn.Minor)." +
        "$($actVsn.Patch)$($actVsn.Qualifier)"
    $expVsn = "$Version" | Extract-Version
    $expVsnString = "$($expVsn.Major).$($expVsn.Minor)." +
        "$($expVsn.Patch)$($expVsn.Qualifier)"

    # Compare
    #
    If (-not ($expVsnString -eq $actVsnString)) {
        $result.Message = @( "",
            "ERROR: Expected Glide version $expVsnString but found " +
                "version $actVsnString.",
            "" )
        return $result
    }

    # Get out
    #
    $result.Success = $true
    return $result
}
