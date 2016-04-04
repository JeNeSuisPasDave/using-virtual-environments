#! /bin/bash
#
# These scripts assumes that rbenv is installed.
#

SCRIPTNAME_="$0"

# Get the directory holding this script
# (method from: http://stackoverflow.com/a/12694189/1392864)
#
SCRIPTDIR_="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Ruby and rbenv local Ruby versions
#
RUBY_VSN_="2.0.0p598"
RUBY_VSN_EXP_="2.0.0p598"
RUBY_VSN_MAX_="2.0.1"
RBENV_RUBY_VSN_EXP_="2.0.0-p598"
RBENV_RUBY_VSN_MAX_="2.0.1"

# Pick up the verification functions
#
. "${SCRIPTDIR_}/check-functions.src"

# Check that we are running in a Python 3.5 virtual environment
#
. "${SCRIPTDIR_}/check-active-venv.src"

# Check that we have the needed packages
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Upgrade the required packages
#
bundle update
gem cleanup

# Check that we still have the needed packages
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Done!
#
echo ""
echo -n "OK. May have upgraded required packages for project in "
echo "Ruby ${RUBY_VSN_} virtual environment."
echo ""
