#! /bin/bash
#
# This script assumes that rbenv 0.4.0 is installed.
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
RBENV_VSN_EXP_="0.4.0"
RBENV_VSN_MAX_="0.5.0"
RBENV_VSN_=`rbenv -v`
parse_version "${RBENV_VSN_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse RBENV_VSN_"
  exit 2
fi
RBENV_VSN_PARTS_=( ${parse_version[@]} )
RBENV_VSN_="${RBENV_VSN_PARTS_[0]}"
RBENV_VSN_="${RBENV_VSN_}.${RBENV_VSN_PARTS_[1]}"
RBENV_VSN_="${RBENV_VSN_}.${RBENV_VSN_PARTS_[2]}"
version_is_at_least "${RBENV_VSN_EXP_}" "${RBENV_VSN_}"
RBENV_VSN_MIN_OK_=${version_is_at_least}
version_is_less_than "${RBENV_VSN_MAX_}" "${RBENV_VSN_}"
RBENV_VSN_MAX_OK_=${version_is_less_than}
if (( 0 == ${RBENV_VSN_MIN_OK_} )) \
  || (( 0 == ${RBENV_VSN_MAX_OK_} )); then
  echo
  echo -n "ERROR: Expecting rbenv ${RBENV_VSN_EXP_} or later, "
  echo "up to ${RBENV_VSN_MAX_}."
  echo "Found ${RBENV_VSN_}"
  echo
  exit 10
fi

# Check the plugins
#
RBENV_REQUIRED_PLUGINS_=( "rbenv-gem-rehash" "rbenv-gemset" "ruby-build" )
RBENV_PLUGINS_=( $HOME/.rbenv/plugins/* )
for (( i = 0; i < ${#RBENV_REQUIRED_PLUGINS_[@]}; i++ ))
do
  FOUND_=0
  for (( k = 0; k < ${#RBENV_PLUGINS_[@]}; k++ ))
  do
    PLUGIN_=`basename ${RBENV_PLUGINS_[k]}`
    if [[ "${RBENV_REQUIRED_PLUGINS_[i]}" == "${PLUGIN_}" ]]; then
      FOUND_=1
      break
    fi
  done
  if (( 0 == ${FOUND_} )); then
    echo
    echo "ERROR: Missing rbenv plugin ${RBENV_REQUIRED_PLUGINS_[i]}."
    exit 8
  fi
done

# Unset the local rbenv ruby
#
if [[ -f "${SCRIPTDIR_}/.rbenv" ]]; then
  rbenv local --unset
fi

# Determine the version of Ruby we want
#
RUBY_VERSION_="2.2.3"
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
rbenv local --unset
if [[ ! -f ".rbenv-gemsets" ]]; then
  echo ".gems" > .rbenv-gemsets
  echo "" >> .rbenv-gemsets
fi

# Install bundler
#
rbenv local ${RBENV_RUBY_VERSION_}
BUNDLER_P_=`gem list --no-versions | grep -E ^bundler$`
if [[ -z "${BUNDLER_P_}" ]]; then
  gem install bundler
fi
BUNDLER_P_=`gem list --no-versions | grep -E ^bundler$`
rbenv local --unset
if [[ -z "${BUNDLER_P_}" ]]; then
  echo "ERROR: failed to install the gem 'bundler'."
  exit 6
fi

# Done!
#
echo ""
echo "OK. Virtual environment for Ruby ${RUBY_VERSION_} is created."
echo "Use the command 'rbenv local ${RBENV_RUBY_VERSION_}' to activate;"
echo "Use command 'rbenv local --unset' to deactivate."
echo ""
