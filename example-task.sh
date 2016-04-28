#! /bin/bash
#

SCRIPTNAME_="$0"

# Get the directory holding this script
# (method from: http://stackoverflow.com/a/12694189/1392864)
#
SCRIPTDIR_="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPTDIR_" ]]; then
  SCRIPTDIR_="$PWD"
fi
SCRIPTDIR_="${SCRIPTDIR_}/nodejs"

# Pick up the verification functions
#
. "${SCRIPTDIR_}/check-functions.src"

# Set version expectations
#
NODEJS_VSN_="4.4.2"
NODEJS_LCL_=".jslcl"
NODE_VSN_EXP_="4.4.2"
NODE_VSN_MAX_="4.4.3"
NPM_VSN_EXP_="2.15.0"
NPM_VSN_MAX_="2.15.2"

# Check whether virtual environment is active
#
. "${SCRIPTDIR_}/check-active-venv.src"

# Check whether required npm modules are installed
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Do something useful here
#
echo ""
echo "OK. Done!"
echo ""
