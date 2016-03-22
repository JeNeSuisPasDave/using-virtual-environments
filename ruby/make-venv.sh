#! /bin/bash
#
# This script assumes that Ruby 2.0.0p481 is installed via rbenv.
# If Ruby 2.0.0p481 is installed some other way, then the script will
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

RBLCL_DIRNAME_=.rblcl
SAVE_RBLCL_DIRNAME_=""
RUBY_VERSION_=2.0.0p481
RUBY_RBENV_VERSION_=2.0.0-p481
RBENV_VERSION_=0.4.0

parse_version "${RUBY_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RUBY_VERSION_"
  exit 2
fi
VSN_PARTS_=( ${parse_version[@]} )
echo "MAJOR: ${VSN_PARTS_[0]}"
echo "MINOR: ${VSN_PARTS_[1]}"
echo "PATCH: ${VSN_PARTS_[2]}"
echo "  SUB: ${VSN_PARTS_[3]}"

parse_version "${RUBY_RBENV_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RUBY_RBENV_VERSION_"
  exit 2
fi
VSN_PARTS_=( ${parse_version[@]} )
echo "MAJOR: ${VSN_PARTS_[0]}"
echo "MINOR: ${VSN_PARTS_[1]}"
echo "PATCH: ${VSN_PARTS_[2]}"
echo "  SUB: ${VSN_PARTS_[3]}"

# Check whether rbenv is installed
#
`which -s rbenv`
RBENV_IN_PATH_=$?
if (( 0 != RBENV_IN_PATH_ )); then
  echo "ERROR: rbenv is not installed."
  echo "Install using 'sudo port install rbenv'."
  exit 2
fi

# Check which version of ruby is active, per rbenv
#
# RE_='s/^([^[:space:]]+).*$/\1/'
# RBENV_ACTIVE_VERSION_=`rbenv version | sed -E ${RE_}`
# if [[ "$RUBY_RBENV_VERSION_" != "$RBENV_ACTIVE_VERSION_" ]]; then
#   echo "ERROR: rbenv has not activated Ruby version $RUBY_VERSION_."
#   echo "Install using 'sudo port install rbenv'."
#   exit 4
# fi
