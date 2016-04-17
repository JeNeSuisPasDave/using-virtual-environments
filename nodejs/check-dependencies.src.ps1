
# Check whether dependency is installed; if not, install it
#
$PkgGulpName = "gulp"
$PkgGulpVsnExp = "3.9.0"
$PkgGulpVsnMax = "3.9.1"
$PkgGulpAutoPrefixerName = "gulp-autoprefixer"
$PkgGulpAutoPrefixerVsnExp = "3.1.0"
$PkgGulpAutoPrefixerVsnMax = "3.1.1"
$PkgGulpCachedName = "gulp-cached"
$PkgGulpCachedVsnExp = "1.1.0"
$PkgGulpCachedVsnMax = "1.1.1"
$PkgGulpRsyncName = "gulp-rsync"
$PkgGulpRsyncVsnExp = "0.0.5"
$PkgGulpRsyncVsnMax = "0.0.6"
$PkgGulpRubySassName = "gulp-ruby-sass"
$PkgGulpRubySassVsnExp = "2.0.6"
$PkgGulpRubySassVsnMax = "2.0.7"
$PkgGulpScssLintName = "gulp-scss-lint"
$PkgGulpScssLintVsnExp = "0.3.9"
$PkgGulpScssLintVsnMax = "0.3.10"

# Capture npm packages
#
$rcmd = "npm"
$rargs = "list" -split " "
[System.Collections.ArrayList]$pkgs = Invoke-Expression "$rcmd $rargs"

# Check whether gulp installed
#
$params = @{
    "Name" = $PkgGulpName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpVsnExp;
    "IsLessThan" = $PkgGulpVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}

# Check whether gulp-autoprefixer installed
#
$params = @{
    "Name" = $PkgGulpAutoPrefixerName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpAutoPrefixerVsnExp;
    "IsLessThan" = $PkgGulpAutoPrefixerVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}

# Check whether gulp-cached installed
#
$params = @{
    "Name" = $PkgGulpCachedName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpCachedVsnExp;
    "IsLessThan" = $PkgGulpCachedVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}

# Check whether gulp-rsync installed
#
$params = @{
    "Name" = $PkgGulpRsyncName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpRsyncVsnExp;
    "IsLessThan" = $PkgGulpRsyncVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}

# Check whether gulp-ruby-sass installed
#
$params = @{
    "Name" = $PkgGulpRubySassName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpRubySassVsnExp;
    "IsLessThan" = $PkgGulpRubySassVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}

# Check whether gulp-scss-lint installed
#
$params = @{
    "Name" = $PkgGulpScssLintName;
    "Verbose" = $true;
    "IsAtLeast" = $PkgGulpScssLintVsnExp;
    "IsLessThan" = $PkgGulpScssLintVsnMax;
    "NpmList" = $pkgs
}
If (-not (Is-NodePkgInstalled @params)) {
    Write-Output ""
    Write-Output "Run 'provision-venv.ps1' to install dependencies."
    Write-Output ""
    $errorcode = 4
    Exit
}
