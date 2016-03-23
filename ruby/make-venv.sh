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

# Check the rbenv version
#
# TODO

# Check the plugins
#
# TODO

# Determine the version of Ruby we want
#
RUBY_VERSION_="2.0.0p598"
parse_version "${RUBY_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RUBY_VERSION_"
  exit 2
fi
RUBY_VERSION_PARTS_=( ${parse_version[@]} )
RBENV_RUBY_VERSION_="${RUBY_VERSION_PARTS_[0]}"
RBENV_RUBY_VERSION_="${RBENV_RUBY_VERSION_}.${RUBY_VERSION_PARTS_[1]}"
RBENV_RUBY_VERSION_="${RBENV_RUBY_VERSION_}.${RUBY_VERSION_PARTS_[2]}"
if [[ ! -z "${RUBY_VERSION_PARTS_[3]}" ]]; then
  RBENV_RUBY_VERSION_="${RBENV_RUBY_VERSION_}-${RUBY_VERSION_PARTS_[3]}"
fi

# Check if the Ruby version we want is available
#
is_this_ruby_available "${RBENV_RUBY_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RBENV_RUBY_VERSION_"
  exit 2
fi
FOUND_=$is_this_ruby_available

# If not found, can it be installed? should it be installed?
#
if (( 0 == $FOUND_ )); then
  FOUND_=0
  AVAILABLE_VERSIONS_=( `rbenv install --list` )
  for (( i - 0 ; i < ${#AVAILABLE_VERSIONS_[@]} ; i++ ))
  do
    VSN_="${AVAILABLE_VERSIONS_[$i]}"
    parse_version "${VSN_}"
    if (( 0 != $? )); then
      continue;
    fi
    VSN_PARTS_=( ${parse_version[@]} )
    if [[ "${RUBY_VERSION_PARTS_[@]}" == "${VSN_PARTS_[@]}" ]]; then
      FOUND_=1
      break
    fi
  done
  if (( 0 == $FOUND_ )); then
    echo "ERROR: Could not find Ruby ${RUBY_VERSION_} in the versions"
    echo "       available to be installed from 'rbenv'."
    exit 2
  fi
  echo "WARNING: Ruby ${RUBY_VERSION_} is not available to be set from rbenv."
  read -p "Do you want to make it available to 'rbenv'? [y/N]" -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "No action taken."
    exit 6
  fi
  rbenv install ${RBENV_RUBY_VERSION_}
  is_this_ruby_available "${RBENV_RUBY_VERSION_}"
  if (( 0 != $? )); then
    echo "ERROR: failed to parse RBENV_RUBY_VERSION_"
    exit 2
  fi
  FOUND_=$is_this_ruby_available
  if (( 0 == $FOUND_ )); then
    echo "ERROR: failed to install Ruby ${RBENV_RUBY_VERSION_}"
    exit 10
  fi
fi

# Set the local Ruby version
#
rbenv local ${RBENV_RUBY_VERSION_}

# Check the local Ruby version
#
is_this_ruby_active "${RBENV_RUBY_VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to determine active Ruby version"
  exit 2
fi
if (( 0 == $is_this_ruby_available )); then
  echo "ERROR: failed to activate Ruby ${RBENV_RUBY_VERSION_}"
  exit 4
fi

# Set the gemset directory
#
# TODO

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
