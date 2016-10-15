# Functions to download and install Glide into a Go workspace
#


<#
.SYNOPSIS
Determine whether a Go virtual environment is active.
.DESCRIPTION
Determine whether a Go virtual environment is active.
.PARAMETER Os
A string identifying the operating system.
.PARAMETER Arch
A string identifying the processor architecture.
.PARAMETER Version
A string identifying the Glide version number to download.
.INPUTS
A string identifying the operatoring system, a string identifying the 
processor architecture, and a string containing the Glide version number.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array), FilePath (string). Success is true if the virtual 
environment is active, otherwise false. If not Success, then Message will 
contain the error message lines. If successful, the FilePath is the full
path of the downloaded release zip file.
#>
Function Download-GlideRelease {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0)]
        [string]$Os,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=1)]
        [string]$Arch,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=2)]
        # See http://stackoverflow.com/a/6409122 for AllowEmptyString() tip
        [AllowEmptyString()]
        [string]$Version
    )
    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
        FilePath = ""
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Determine the version of Glide to use
    #
    if (Is-Null $Version) {
        $Version = $(Invoke-WebRequest -Uri https://glide.sh/version 
            -Method Get).Content
    }
    $vsn = "$Version" | Extract-Version
    $vsnString = "$($vsn.Major).$($vsn.Minor)." +
            "$($vsn.Patch)$($vsn.Qualifier)"
    $tag = "v$vsnString"
    $ghProject = "glide"
    $ghRepo = "https://github.com/Masterminds/$ghProject"
    # https://github.com/Masterminds/glide/releases/download/v0.12.2/glide-v0.12.2-windows-amd64.zip
    # https://github.com/Masterminds/glide/releases/v0.12.2/glide-v0.12.2-windows-amd64.zip
    # https://api.github.com/repos/Masterminds/glide/releases/tags/v0.12.2/
    $release = "$ghRepo/releases/download/$tag"
    $glideDist = "glide-$tag-$Os-$Arch.zip"
    $u = "$release/$glideDist"

    # Does that version exist?
    #
    # Write-Host "Invoke-WebRequest -Uri $u -Method Head -MaximumRedirection 10"
    # $sc = $(Invoke-WebRequest -Uri $u -Method Head).StatusCode
    # if (200 -ne $sc) {
    #     $result.Messages = @( "",
    #         "Sorry, we dont have a dist version $vsnString " +
    #             "for your system: $Os $Arch",
    #         "You can ask one here: $ghRepo/issues",
    #         "")
    #     return $result
    # }

    # Download it
    #
    $tmp = New-TemporaryFile
    $tmpDirPath = $tmp.FullName
    Remove-Item "$tmpDirPath" > $null
    New-Item "$tmpDirPath" -ItemType "directory" > $null
    $tmpGlideDist = "$tmpDirPath/$glideDist"
    try {
      Invoke-WebRequest -Uri $u -Method Get -MaximumRedirection 10 `
        -OutFile "$tmpGlideDist" `
        -ErrorAction SilentlyContinue -ErrorVariable iwrError
    } catch {}
    if (0 -ne $iwrError.Count) {
        $result.Messages = @( "",
            "ERROR: Failed to download Glide release from:",
            "$u",
            "")
        return $result
    }

    # Get out
    #
    $result.Success = $true
    $result.FilePath = "$tmpGlideDist"
    return $result
}

<#
.SYNOPSIS
Determine the processor architecture of the system
.DESCRIPTION
Determine the processor architecture of the system.
.INPUTS
None
.OUTPUTS
A string identifying the kind of processor architecture.
#>
Function Get-Arch {
    [CmdletBinding()]
    $arch = "$Env:PROCESSOR_ARCHITECTURE"
    If ("AMD64" -eq "$arch") {
        return "amd64"
    }
    return "386"
}

<#
.SYNOPSIS
Determine the kind of OS running on the system
.DESCRIPTION
Decide what kind of OS is running.
.INPUTS
None
.OUTPUTS
A string identifying the OS kind.
#>
Function Get-Os() {
    return "windows"
}

<#
.SYNOPSIS
Unpack a Glide release archive and the glide binary to the GOBIN directory.
.DESCRIPTION
Unpack a Glide release archive and the glide binary to the GOBIN directory.
.PARAMETER GlideReleasePath
Path of the downloaded zip archive containing the Glide binary.
.PARAMETER Os
A string identifying the operating system.
.PARAMETER Arch
A string identifying the processor architecture.
.PARAMETER GoBinPath
A string containing the directory path into which to copy the glide
executable.
.INPUTS
The path to the Glide release archive, a string identifying the OS kind, a
string identifying the processor archicture, and the GOBIN path.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the virtual environment is active,
otherwise false. If not Success, then Message will contain the error
message lines.
#>
Function Install-GlideRelease {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=0)]
        [string]$GlideReleasePath,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=1)]
        [string]$Os,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=2)]
        [string]$Arch,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            Position=3)]
        [string]$GoBinPath
    )
    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    # Check whether 7-Zip is installed
    #
    $zcmd = "$Env:ProgramFiles\7-Zip\7z.exe"
    If (-not (Test-Path "$zcmd")) {
        $result.Message = @( "",
            "ERROR: 7-Zip is not installed.",
            "",
            ("Download and install the 64-bit version of 7-zip from " +
            "http://www.7-zip.org/."),
            "" )
        return $result
    }

    # Unzip the archive
    #
    $outDir = $(Get-Item "$GlideReleasePath").Directory.FullName
    $cargs = "x,`"-o$outDir`",`"$GlideReleasePath`"" -split ","
    $ccmd = "`"$zcmd`""
    Invoke-Expression "& $ccmd $cargs" > $null

    # Copy glide exe to GOBIN
    #
    $bin = "$outDir\$Os-$Arch\glide.exe"
    Copy-Item "$bin" "$GoBinPath" > $null

    # Delete the temp directory
    #
    Remove-Item "$outDir" -Recurse > $null

    # Get out
    #
    $result.Success = $true
    return $result
}

<#
.SYNOPSIS
Check that Go is installed, and GOPATH and GOBIN exist and point to extant
directories.
.DESCRIPTION
Check that Go is installed, and GOPATH and GOBIN exist and point to extant
directories.
.INPUTS
None.
.OUTPUTS
System.Management.Automation.PSCustomObject. Properties are Success (bool),
Message (string array). Success is true if the virtual environment is active,
otherwise false. If not Success, then Message will contain the error
message lines.
#>
Function Verify-GoOkForGlide {
    [CmdletBinding()]

    # Initialize the result
    #
    $props = @{
        Success = $false
        Message = @()
    }
    $result = New-Object -TypeName PSObject -Property $props

    If (-not (Test-Path Env:\GOROOT)) {
        $result.Message = @( "",
            "glide needs Go. GOROOT missing. Please install Go first.",
            "")
        return $result
    }
    If (-not (Test-Path "$Env:GOROOT\bin\go.exe")) {
        $result.Message = @( "",
            "glide needs Go. Please install Go first.",
            "")
        return $result
    }
    if (-not (Test-Path Env:\GOPATH)) {
        $result.Mesage = @( "",
            ("glide needs environment variable GOPATH. " +
                "Set it before continuing."), 
            "" )
        return $result
    }
    if (-not (Test-Path Env:\GOBIN)) {
        $result.Mesage = @( "",
            ("glide needs environment variable GOBIN. " +
                "Set it before continuing."), 
            "" )
        return $result
    }
    if (-not (Test-Path "$Env:GOBIN")) {
        $result.Mesage = @( "",
            ("The GOBIN folder, '$Env:GOBIN', does not exist. " +
                "Create it before continuing."), 
            "" )
        return $result
    }

    # Get out
    #
    $result.Success = $true
    return $result
}
