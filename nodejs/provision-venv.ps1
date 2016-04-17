# This script assumes that Node.js v4.4.2 is installed in
# C:\Program Files (x86)\nodejs-v4.4.2
#
# If Node.js v4.4.2 is installed some other way, then the script will
# need some adjustment.
#
Set-Strictmode -version Latest

# Capture the file name of this powershell script
#
$scriptName = $MyInvocation.InvocationName
$scriptDir = $PSScriptRoot
$cwd = (Get-Item -Path ".\" -Verbose).FullName

# Set error code
#
$errcode = 0

# Set expected Node.js version and local deployment directory, along
# with some other initialization
#
$nodejsVsnExpected = "v4.4.2"
$nodejsVsnMax = "v4.4.3"
$nodejsDownloadLoc = "https://nodejs.org/en/download/releases/"
$jslclDir = ".jslcl"
$nodejsDir = "nodejs-v4.4.2"

# Pick up the verification functions
#
. "$scriptDir\check-functions.src.ps1"

# Check that we are running in a Node.js virtual environment
#
. "$scriptDir\check-active-venv.src.ps1"
If (0 -ne $errcode) {
    Exit
}

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
$min = $PkgGulpVsnExp
$max = $PkgGulpVsnMax
If (-not ("$PkgGulpName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpName@$min"
}

# Check whether gulp-autoprefixer installed
#
$min = $PkgGulpAutoPrefixerVsnExp
$max = $PkgGulpAutoPrefixerVsnMax
If (-not ("$PkgGulpAutoPrefixerName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpAutoPrefixerName@$min"
}

# Check whether gulp-cached installed
#
$min = $PkgGulpCachedVsnExp
$max = $PkgGulpCachedVsnMax
If (-not ("$PkgGulpCachedName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpCachedName@$min"
}

# Check whether gulp-rsync installed
#
$min = $PkgGulpRsyncVsnExp
$max = $PkgGulpRsyncVsnMax
If (-not ("$PkgGulpRsyncName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpRsyncName@$min"
}

# Check whether gulp-ruby-sass installed
#
$min = $PkgGulpRubySassVsnExp
$max = $PkgGulpRubySassVsnMax
If (-not ("$PkgGulpRubySassName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpRubySassName@$min"
}

# Check whether gulp-scss-lint installed
#
$min = $PkgGulpScssLintVsnExp
$max = $PkgGulpScssLintVsnMax
If (-not ("$PkgGulpScssLintName" |
        Is-NodePkgInstalled -IsAtLeast $min -IsLessThan $max -NpmList $pkgs)) {
    npm install "$PkgGulpScssLintName@$min"
}
