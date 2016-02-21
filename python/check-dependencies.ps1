# NOTE: expect that this is preceded by source command:
# . check-functions.ps1
#

$redisExpectedVsn_ = "2.10" -as [System.Version]
$redisMaxVsn_ = "2.11" -as [System.Version]
$flaskExpectedVsn_ = "0.10" -as [System.Version]
$flaskMaxVsn_ = "0.11" -as [System.Version]
$jinja2ExpectedVsn_ = "2.8" -as [System.Version]
$jinja2MaxVsn_ = "2.9" -as [System.Version]
$werkzeugExpectedVsn_ = "0.11" -as [System.Version]
$werkzeugMaxVsn_ = "0.12" -as [System.Version]
$markupsafeExpectedVsn_ = "0.23" -as [System.Version]
$markupsafeMaxVsn_ = "0.24" -as [System.Version]
$itsdangerousExpectedVsn_ = "0.24" -as [System.Version]
$itsdangerousMaxVsn_ = "0.25" -as [System.Version]

# Capture pip packages
#
$rcmd_ = "pip"
$rargs_ = "list" -split " "
$pkgs_ = Invoke-Expression "$rcmd_ $rargs_"

# Check whether redis installed
#
$redisInstalled_ = $pkgs_ -match "^redis \(" -as [boolean]
If (-not $redisInstalled_) {
  Write-Output ""
  Write-Output "ERROR: redis is not installed"
  Write-Output ""
  Write-Output "Try 'pip install redis' to install redis, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 8
  Exit
}
$redisVsn_= ($pkgs_ -match "^redis \(")[0] | Extract-Version
If ((-not (Test-Version $redisVsn_ -IsAtLeast $redisExpectedVsn_)) `
-or (-not (Test-Version $redisVsn_ -IsLessThan $redisMaxVsn_))) {
  Write-Output ""
  Write-Output "ERROR: Expecting redis $redisExpectedVsn_ or later, "
    "up to $redisMaxVsn_."
  Write-Output "Found $redisVsn_"
  Write-Output ""
  $errcode_ = 10
  Exit
}

# Check whether Flask installed
#
$flaskInstalled_ = $pkgs_ -match "^Flask \(" -as [boolean]
If (-not $flaskInstalled_) {
  Write-Output ""
  Write-Output "ERROR: Flask is not installed"
  Write-Output ""
  Write-Output "Try 'pip install Flask' to install Flask, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 12
  Exit
}
$flaskVsn_= ($pkgs_ -match "^Flask \(")[0] | Extract-Version
If ((-not (Test-Version $flaskVsn_ -IsAtLeast $flaskExpectedVsn_)) `
-or (-not (Test-Version $flaskVsn_ -IsLessThan $flaskMaxVsn_))) {
  Write-Output ""
  Write-Output "ERROR: Expecting Flask $flaskExpectedVsn_ or later, "
    "up to $flaskMaxVsn_."
  Write-Output "Found $flaskVsn_"
  Write-Output ""
  $errcode_ = 14
  Exit
}

# Check whether Jinja2 installed
#
$jinja2Installed_ = $pkgs_ -match "^Jinja2 \(" -as [boolean]
If (-not $jinja2Installed_) {
  Write-Output ""
  Write-Output "ERROR: Jinja2 is not installed"
  Write-Output ""
  Write-Output "Try 'pip install Jinja2' to install Jinja2, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 16
  Exit
}
$jinja2Vsn_= ($pkgs_ -match "^Jinja2 \(")[0] | Extract-Version
If ((-not (Test-Version $jinja2Vsn_ -IsAtLeast $jinja2ExpectedVsn_)) `
-or (-not (Test-Version $jinja2Vsn_ -IsLessThan $jinja2MaxVsn_))) {
  Write-Output ""
  Write-Output "ERROR: Expecting Jinja2 $jinja2ExpectedVsn_ or later, "
    "up to $jinja2MaxVsn_."
  Write-Output "Found $jinja2Vsn_"
  Write-Output ""
  $errcode_ = 18
  Exit
}

# Check whether Werkzeug installed
#
$werkzeugInstalled_ = $pkgs_ -match "^Werkzeug \(" -as [boolean]
If (-not $werkzeugInstalled_) {
  Write-Output ""
  Write-Output "ERROR: Werkzeug is not installed"
  Write-Output ""
  Write-Output "Try 'pip install Werkzeug' to install Werkzeug, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 20
  Exit
}
$werkzeugVsn_= ($pkgs_ -match "^Werkzeug \(")[0] | Extract-Version
If ((-not (Test-Version $werkzeugVsn_ -IsAtLeast $werkzeugExpectedVsn_)) `
-or (-not (Test-Version $werkzeugVsn_ -IsLessThan $werkzeugMaxVsn_))) {
  Write-Output ""
  Write-Output "ERROR: Expecting Werkzeug $werkzeugExpectedVsn_ or later, "
    "up to $werkzeugMaxVsn_."
  Write-Output "Found $werkzeugVsn_"
  Write-Output ""
  $errcode_ = 22
  Exit
}

# Check whether MarkupSafe installed
#
$markupsafeInstalled_ = $pkgs_ -match "^MarkupSafe \(" -as [boolean]
If (-not $markupsafeInstalled_) {
  Write-Output ""
  Write-Output "ERROR: MarkupSafe is not installed"
  Write-Output ""
  Write-Output "Try 'pip install MarkupSafe' to install MarkupSafe, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 24
  Exit
}
$markupsafeVsn_= ($pkgs_ -match "^MarkupSafe \(")[0] | Extract-Version
If ((-not (Test-Version $markupsafeVsn_ -IsAtLeast $markupsafeExpectedVsn_)) `
-or (-not (Test-Version $markupsafeVsn_ -IsLessThan $markupsafeMaxVsn_))) {
  Write-Output ""
  Write-Output ("ERROR: Expecting MarkupSafe $markupsafeExpectedVsn_ or " `
    + "later, up to $markupsafeMaxVsn_.")
  Write-Output "Found $markupsafeVsn_"
  Write-Output ""
  $errcode_ = 26
  Exit
}

# Check whether itsdangerous installed
#
$itsdangerousInstalled_ = $pkgs_ -match "^itsdangerous \(" -as [boolean]
If (-not $itsdangerousInstalled_) {
  Write-Output ""
  Write-Output "ERROR: itsdangerous is not installed"
  Write-Output ""
  Write-Output "Try 'pip install itsdangerous' to install itsdangerous, and"
  Write-Output "then try '$scriptName_' again."
  Write-Output ""
  $errcode_ = 24
  Exit
}
$itsdangerousVsn_= ($pkgs_ -match "^itsdangerous \(")[0] | Extract-Version
If ((-not (Test-Version $itsdangerousVsn_ -IsAtLeast $itsdangerousExpectedVsn_)) `
-or (-not (Test-Version $itsdangerousVsn_ -IsLessThan $itsdangerousMaxVsn_))) {
  Write-Output ""
  Write-Output ("ERROR: Expecting itsdangerous $itsdangerousExpectedVsn_ or " `
    + "later, up to $itsdangerousMaxVsn_.")
  Write-Output "Found $itsdangerousVsn_"
  Write-Output ""
  $errcode_ = 26
  Exit
}
