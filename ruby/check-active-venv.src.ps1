# NOTE: expect that this is preceded by this source command:
# . check-functions.src.ps1
#
# NOTE: Expect that these variables are already populated:
#
# $scriptName = $MyInvocation.InvocationName
# $scriptDir = $PSScriptRoot
# $cwd = (Get-Item -Path ".\" -Verbose).FullName
# $rubyVsnExpected = "2.0.0p598"
# $rubyVsnMax = "2.0.0p599"
# $rubyDownloadLoc = "http://rubyinstaller.org/downloads/archives"
# $rblclDir = ".rblcl"
# $rubyDir = "Ruby200-p598"

# Does the local Ruby directory exist?
#
If (-not (Test-Path ".\$rblclDir")) {
    Write-Output ""
    Write-Output "ERROR: A local Ruby is not installed."
    Write-Output "Run 'make-venv.ps1' to install the Ruby virtual environment."
    Write-Output ""
    $errcode = 2
    Exit
}

# Is Ruby installed?
#
$rubyBinPath = "$cwd\$rblclDir\bin"
If (-not (Test-Path "$rubyBinPath\ruby.exe")) {
    Write-Output ""
    Write-Output "ERROR: Ruby is not installed in '.\$rblclDir'."
    Write-Output "Run 'make-venv.ps1' to install the Ruby virtual environment."
    Write-Output ""
    $errcode = 2
    Exit
}

# Is the Ruby virtual environment activated?
#
[System.Collections.ArrayList]$pathParts = $Env:Path.split(';')
If (-not $pathParts.Contains("$rubyBinPath")) {
    Write-Output ""
    Write-Output "ERROR: Ruby virtual environment not active."
    Write-Output ("Run 'activate-project.ps1' to activate " +
        "the Ruby virtual environment.")
    Write-Output ""
    $errcode = 2
    Exit
}
If (-not (Test-Path Env:RBLCL_)) {
    Write-Output ""
    Write-Output "ERROR: Ruby virtual environment not active."
    Write-Output ("Run 'activate-project.ps1' to activate " +
        "the Ruby virtual environment.")
    Write-Output ""
    $errcode = 2
    Exit
}
