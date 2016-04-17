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

# Pick up the verification functions
#
. "${SCRIPTDIR_}/check-functions.src"

# Set version expectations
#
NODEJS_VSN_="0.12.13"
NODEJS_LCL_=".jslcl"
NODE_VSN_EXP_="0.12.13"
NODE_VSN_MAX_="0.12.14"
NPM_VSN_EXP_="2.15.0"
NPM_VSN_MAX_="2.15.2"

# Check whether virtual environment is active
#
. "${SCRIPTDIR_}/check-active-venv.src"

# Check whether dependency is installed; if not, install it
#
PKG_GULP_NAME_="gulp"
PKG_GULP_VSN_EXP_="3.9.0"
PKG_GULP_VSN_MAX_="3.9.1"
PKG_GULP_AUTOPREFIXER_NAME_="gulp-autoprefixer"
PKG_GULP_AUTOPREFIXER_VSN_EXP_="3.1.0"
PKG_GULP_AUTOPREFIXER_VSN_MAX_="3.1.1"
PKG_GULP_CACHED_NAME_="gulp-cached"
PKG_GULP_CACHED_VSN_EXP_="1.1.0"
PKG_GULP_CACHED_VSN_MAX_="1.1.1"
PKG_GULP_RSYNC_NAME_="gulp-rsync"
PKG_GULP_RSYNC_VSN_EXP_="0.0.5"
PKG_GULP_RSYNC_VSN_MAX_="0.0.6"
PKG_GULP_RUBYSASS_NAME_="gulp-ruby-sass"
PKG_GULP_RUBYSASS_VSN_EXP_="2.0.6"
PKG_GULP_RUBYSASS_VSN_MAX_="2.0.7"
PKG_GULP_SCSSLINT_NAME_="gulp-scss-lint"
PKG_GULP_SCSSLINT_VSN_EXP_="0.3.9"
PKG_GULP_SCSSLINT_VSN_MAX_="0.3.10"

# Capture npm packages
#
NPM_PKGS_=`npm list`

# Check whether gulp installed
#
is_this_node_pkg_installed "${PKG_GULP_NAME_}" \
  "${PKG_GULP_VSN_EXP_}" "${PKG_GULP_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_NAME_}@${PKG_GULP_VSN_EXP_}"
fi

# Check whether gulp-autoprefixer installed
#
is_this_node_pkg_installed "${PKG_GULP_AUTOPREFIXER_NAME_}" \
  "${PKG_GULP_AUTOPREFIXER_VSN_EXP_}" "${PKG_GULP_AUTOPREFIXER_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_AUTOPREFIXER_NAME_}@${PKG_GULP_AUTOPREFIXER_VSN_EXP_}"
fi

# Check whether gulp-cached installed
#
is_this_node_pkg_installed "${PKG_GULP_CACHED_NAME_}" \
  "${PKG_GULP_CACHED_VSN_EXP_}" "${PKG_GULP_CACHED_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_CACHED_NAME_}@${PKG_GULP_CACHED_VSN_EXP_}"
fi

# Check whether gulp-rsync installed
#
is_this_node_pkg_installed "${PKG_GULP_RSYNC_NAME_}" \
  "${PKG_GULP_RSYNC_VSN_EXP_}" "${PKG_GULP_RSYNC_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_RSYNC_NAME_}@${PKG_GULP_RSYNC_VSN_EXP_}"
fi

# Check whether gulp-ruby-sass installed
#
is_this_node_pkg_installed "${PKG_GULP_RUBYSASS_NAME_}" \
  "${PKG_GULP_RUBYSASS_VSN_EXP_}" "${PKG_GULP_RUBYSASS_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_RUBYSASS_NAME_}@${PKG_GULP_RUBYSASS_VSN_EXP_}"
fi

# Check whether gulp-scss-lint installed
#
is_this_node_pkg_installed "${PKG_GULP_SCSSLINT_NAME_}" \
  "${PKG_GULP_SCSSLINT_VSN_EXP_}" "${PKG_GULP_SCSSLINT_VSN_MAX_}"
if (( 0 != $? )); then
  exit 8
fi
if (( 0 == $is_this_node_pkg_installed )); then
  npm install "${PKG_GULP_SCSSLINT_NAME_}@${PKG_GULP_SCSSLINT_VSN_EXP_}"
fi
