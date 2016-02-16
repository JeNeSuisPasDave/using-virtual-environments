# This script assumes that Python 2.7 is installed in
# C:\Program Files\Python 2.7
#
# If Python 2.7 is installed some other way, then the script will
# need some adjustment.
#

# Capture the file name of this powershell script
#
$SCRIPTNAME_ = $MyInvocation.InvocationName

$VENV_DIRNAME_ = "venv27"
$SAVE_VENV_DIRNAME_=""
$PYTHON_VERSION_ = "2.7"
$PYTHON_INSTALLBASE_ = "C:\Program Files\Python $PYTHON_VERSION_"

# Check whether Python 2.7 is installed
#
$PYTHON_INSTALLED_ = Get-ChildItem "$PYTHON_INSTALLBASE_" |
  Where-Object {($_.Name -eq "python.exe")}
If ($PYTHON_INSTALLED_ -eq $null)
{
  echo ""
  echo "ERROR: Python 2.7 is not installed."
  echo "       Expected '$PYTHON_INSTALLBASE_\python.exe'"
  echo "Install Python 2.7 and then try '.\$SCRIPTNAME_' again."
  return $false
}

# Check whether we are running in a python virtual environment
#
$VENV_RUNNING_ = Get-ChildItem env: | Where-Object {($_.Name -eq "VIRTUAL_ENV")}
If ($VENV_RUNNING_ -ne $null)
{
  echo ""
  echo "ERROR: Python virtual environment already running"
  echo ""
  echo "Try 'deactivate' to stop the virtual environment, and"
  echo "then try '.\$SCRIPTNAME_' again."
  echo ""
  return $false
}

# Check whether the virtual environment directory already exists
#
If (Test-Path ".\$VENV_DIRNAME_")
{
  echo ""
  echo "WARNING: virtual environment directory '.\$VENV_DIRNAME_' already exists."
  $yesno_ = Read-Host "Do you want to delete and replace it? [y/N]"
  if ($yesno_ -ne 'y')
  {
    echo "No action taken".
    return $true
  }
  # Rename the existing directory
  #
  $SAVE_VENV_DIRNAME_ = "$VENV_DIRNAME_" + "_bkup"
  Move-Item ".\$VENV_DIRNAME_" ".\$SAVE_VENV_DIRNAME_"
}

# Check that virtualenv is installed
#
$rcmd = "$PYTHON_INSTALLBASE_\Scripts\pip.exe"
$rargs = "list 2>&1" -split " "
$piplist = & $rcmd $rargs
$VIRTUALENV_INSTALLED_ = $piplist | Where-Object {($_ -Like "virtualenv (*")}
If ($VIRTUALENV_INSTALLED_ -eq $null)
{
  echo ""
  echo "ERROR: virtualenv is not installed"
  echo ""
  echo "Try '$PYTHON_INSTALLBASE_\Scripts\pip.exe install virtualenv' to "
  echo "install virtualenv, and then try '.\$SCRIPTNAME_' again."
  echo ""
  return $false
}

# Create the virtual environment directory (the deployment folder)
#
& "$PYTHON_INSTALLBASE_\python.exe" -m virtualenv "$VENV_DIRNAME_"
If (Test-Path ".\$VENV_DIRNAME_")
{
  If (Test-Path ".\$SAVE_VENV_DIRNAME_")
  {
    Remove-Item -Recurse ".\$SAVE_VENV_DIRNAME_"
  }
}
else
{
  echo "ERROR: virtual environment not created."
  If (Test-Path ".\$SAVE_VENV_DIRNAME_")
  {
    Move-Item ".\$SAVE_VENV_DIRNAME_" ".\$VENV_DIRNAME_"
  }
  return $false
}

# Activate the virtual environment
#
& .\venv27\Scripts\Activate.ps1

# Check whether we are running in a python virtual environment
#
$VENV_RUNNING_ = Get-ChildItem env: | Where-Object {($_.Name -eq "VIRTUAL_ENV")}
If ($VENV_RUNNING_ -eq $null)
{
  echo "ERROR: Python virtual environment was not activated; not running"
  return $false
}

# Check whether we are running Python 2.7
#
$rcmd = "python"
$rargs = "--version 2>&1" -split " "
$vsn = & $rcmd $rargs
if ($vsn -NotLike "Python 2.*")
{
  echo "ERROR: Python 2.7 or later is required. Found '$vsn'."
  echo ""
  echo "Deactivate the current virtual environment."
  echo "Try '.\venv27\Scripts\Activate.ps1' to start the virtual environment, and"
  echo "then try '.\$SCRIPTNAME_' again."
  echo ""
  return $false
}

# Update setuptools and pip
#
pip install --upgrade -q setuptools
pip install --upgrade -q pip

# deactivate the virtual environment
#
deactivate

# Done!
#
echo ""
echo "OK. Virtual environment for Python 2.7 is created."
echo "Use command '.\venv27\Scripts\Activate.ps1' to start;"
echo "Use command 'deactivate' to stop."
echo ""
