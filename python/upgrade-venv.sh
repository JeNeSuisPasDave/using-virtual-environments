#! /bin/bash
#
# These scripts assumes that Python 2.7 is installed via Mac Ports.
# If Python 2.7 is installed some other way, then the scripts will
# need some adjustment.
#

SCRIPTNAME_="$0"

# Get the directory holding this script
# (method from: http://stackoverflow.com/a/12694189/1392864)
#
SCRIPTDIR_="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Pick up the verification functions
#
. "${SCRIPTDIR_}/check-functions.src"

# Check that we are running in a Python 2.7 virtual environment
#
. "${SCRIPTDIR_}/check-active-venv.src"

# Check that we have the needed packages
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Upgrade the required packages
#
pip install --upgrade -q -r requirements-venv.txt

# Check that we still have the needed packages
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Done!
#
echo ""
echo -n "OK. May have upgraded required packages for project in "
echo "Python 2.7 virtual environment."
echo ""
