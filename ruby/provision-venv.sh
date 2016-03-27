#! /bin/bash
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

# Check that we are running in a Ruby virtual environment
#
. "${SCRIPTDIR_}/check-active-venv.src"

# Install required packages
#
bundle install --quiet

# Check that we have the needed packages
#
. "${SCRIPTDIR_}/check-dependencies.src"

# Done!
#
echo ""
echo -n "OK. Provisioned required packages for project in "
echo "Ruby ${RUBY_VSN_} virtual environment."
echo ""
