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

# Check whether rbenv is installed
#
`which -s rbenv`
RBENV_IN_PATH_=$?
if (( 0 != RBENV_IN_PATH_ )); then
  echo "ERROR: rbenv is not installed."
  echo "Install using 'sudo port install rbenv'."
  exit 2
fi

# Determine the version of Ruby we want
#
RUBY_VERSION_="2.0.0p481"
parse_version "${RUBY_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RUBY_VERSION_"
  exit 2
fi
RUBY_VERSION_PARTS_=( ${parse_version[@]} )

# Check if the Ruby version we want is available
#
FOUND_=0
RBENV_VERSIONS_=( `rbenv versions --bare` )
for (( i = 0 ; i < ${#RBENV_VERSIONS_[@]} ; i++ ))
do
  VSN_="${RBENV_VERSIONS_[$i]}"
  parse_version "${VSN_}"
  if (( 0 != $? )); then
    echo "ERROR: failed to parse VSN_"
    exit 2
  fi
  VSN_PARTS_=( ${parse_version[@]} )
  if [[ "${RUBY_VERSION_PARTS_[@]}" == "${VSN_PARTS_[@]}" ]]; then
    FOUND_=1
    break
  fi
done

# If not found, install it
#
if (( 0 == $FOUND_ )); then
  echo "ERROR: need to install with command 'rbenv install $RBENV_RUBY_VERSION_'"
  exit 2
fi

# Set the local Ruby version
#
`rbenv local $RBENV_RUBY_VERSION_`

# Check the local Ruby version
#
`rbenv version`

# RBLCL_DIRNAME_=.rblcl
# SAVE_RBLCL_DIRNAME_=""
# RUBY_VERSION_=2.0.0p481
# RUBY_RBENV_VERSION_=2.0.0-p481
# RBENV_VERSION_=0.4.0


# Check which version of ruby is active, per rbenv
#
# RE_='s/^([^[:space:]]+).*$/\1/'
# RBENV_ACTIVE_VERSION_=`rbenv version | sed -E ${RE_}`
# if [[ "$RUBY_RBENV_VERSION_" != "$RBENV_ACTIVE_VERSION_" ]]; then
#   echo "ERROR: rbenv has not activated Ruby version $RUBY_VERSION_."
#   echo "Install using 'sudo port install rbenv'."
#   exit 4
# fi
