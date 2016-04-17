# NOTE: expect that this is preceded by this source command:
# . check-functions.src.ps1
#
# NOTE: Expect that these variables are already populated:
#
# $scriptName = $MyInvocation.InvocationName
# $scriptDir = $PSScriptRoot
# $cwd = (Get-Item -Path ".\" -Verbose).FullName
# $nodejsVsnExpected = "v0.12.13"
# $nodejsVsnMax = "v0.12.14"
# $nodejsDownloadLoc = "http://nodejsinstaller.org/downloads/archives"
# $jslclDir = ".jslcl"
# $nodejsDir = "nodejs-v0.12.13"

# Does the local Node.js directory exist?
#
If (-not (Test-Path ".\$jslclDir")) {
    Write-Output ""
    Write-Output "ERROR: A local Node.js is not installed."
    Write-Output "Run 'make-venv.ps1' to install the Node.js virtual environment."
    Write-Output ""
    $errcode = 2
    Exit
}

# Is Node.js installed?
#
$nodejsBinPath = "$cwd\$jslclDir"
If (-not (Test-Path "$nodejsBinPath\node.exe")) {
    Write-Output ""
    Write-Output "ERROR: Node.js is not installed in '.\$jslclDir'."
    Write-Output "Run 'make-venv.ps1' to install the Node.js virtual environment."
    Write-Output ""
    $errcode = 2
    Exit
}

# Is the Node.js virtual environment activated?
#
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If (-not $pathParts.Contains("$nodejsBinPath")) {
    Write-Output ""
    Write-Output "ERROR: Node.js virtual environment not active."
    Write-Output ("Run 'activate-project.ps1' to activate " +
        "the Node.js virtual environment.")
    Write-Output ""
    $errcode = 2
    Exit
}
If (-not (Test-Path Env:JSLCL_)) {
    Write-Output ""
    Write-Output "ERROR: Node.js virtual environment not active."
    Write-Output ("Run 'activate-project.ps1' to activate " +
        "the Node.js virtual environment.")
    Write-Output ""
    $errcode = 2
    Exit
}
