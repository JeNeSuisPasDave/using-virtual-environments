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

# Determine the version of Node.js we want
#
NODEJS_VSN_="v0.12.13"
parse_version "${NODEJS_VSN_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse NODEJS_VSN_"
  exit 2
fi
NODEJS_VSN_PARTS_=( ${parse_version[@]} )

# Check if the Node.js version we want is available
#
NODEJS_INSTALL_BASE_="${HOME}/Library/Frameworks/node.framework"
is_this_nodejs_available "${NODEJS_VSN_}"
if (( 0 != $? )); then
  echo "ERROR: failed to check version availability"
  exit 2
fi
FOUND_=$is_this_nodejs_available
if (( 0 == $FOUND_ )); then
  echo "ERROR: Could not find Node.js ${NODEJS_VSN_} in the versions"
  echo "       available to be installed from '${NODEJS_INSTALL_BASE_}'."
  echo "       Expected to find the tar.gz file for the "
  echo "       ${NODEJS_VSN_} distribution."
  echo ""
  exit 2
fi
if [[ -z "${NODEJS_INSTALLKIT_}" ]]; then
  echo "ERROR: Could not determine the install kit file."
  echo ""
  exit 2
fi

# Check whether the local deployment directory exists. If missing,
# create it
#
NODEJS_LCL_=".jslcl"
if [[ ! -d "${NODEJS_LCL_}" ]]; then
  mkdir "${NODEJS_LCL_}" > /dev/null
fi
NODEJS_LCL_BASE_=""${NODEJS_LCL_}"/${NODEJS_VSN_PARTS_[0]}"
NODEJS_LCL_BASE_="${NODEJS_LCL_BASE_}.${NODEJS_VSN_PARTS_[1]}"
NODEJS_LCL_BASE_="${NODEJS_LCL_BASE_}.${NODEJS_VSN_PARTS_[2]}"
OK_=1
if [[ ! -d "${NODEJS_LCL_BASE}" ]]; then
  OK_=0
elif [[ ! -f "${NODEJS_LCL_BASE}/bin/node" ]]; then
  rm -r "${NODEJS_LCL_BASE}"
  OK_=0
fi
if (( 0 == $OK_ )); then
  # missing, so create it
  pushd "${NODEJS_LCL_}" > /dev/null
  tar xzf "${NODEJS_INSTALLKIT_}"
  NODEJS_OLDNAME_=`basename -s ".tar.gz" "${NODEJS_INSTALLKIT_}"`
  popd > /dev/null
  mv "${NODEJS_LCL_}/${NODEJS_OLDNAME_}" "${NODEJS_LCL_BASE_}"
fi

# Done!
#
echo ""
echo "OK. Virtual environment for Node.js ${NODEJS_VSN_} is created."
echo "Use the command '. activate_project.src' to activate;"
echo "Use command 'deactivate_project' to deactivate."
echo ""
