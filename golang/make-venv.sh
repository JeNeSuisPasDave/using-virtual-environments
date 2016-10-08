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

# Determine the version of Go we want
#
GOLANG_VSN_="v1.6.3"
parse_version "${GOLANG_VSN_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse GOLANG_VSN_"
  exit 2
fi
GOLANG_VSN_PARTS_=( ${parse_version[@]} )

# Check if the Go version we want is available
#
GOLANG_INSTALL_BASE_="${HOME}/Library/Frameworks/go.framework"
is_this_golang_available "${GOLANG_VSN_}"
if (( 0 != $? )); then
  echo "ERROR: failed to check version availability"
  exit 2
fi
FOUND_=$is_this_golang_available
if (( 0 == $FOUND_ )); then
  echo "ERROR: Could not find Go ${GOLANG_VSN_} in the versions"
  echo "       available to be installed from '${GOLANG_INSTALL_BASE_}'."
  echo "       Expected to find the tar.gz file for the "
  echo "       ${GOLANG_VSN_} distribution."
  echo ""
  exit 2
fi
if [[ -z "${GOLANG_INSTALLKIT_}" ]]; then
  echo "ERROR: Could not determine the install kit file."
  echo ""
  exit 2
fi

# Check whether the local deployment directory exists. If missing,
# create it
#
GOLANG_LCL_=".golcl"
GOLANG_LCL_="${GOLANG_LCL_}/${GOLANG_VSN_PARTS_[0]}"
GOLANG_LCL_="${GOLANG_LCL_}.${GOLANG_VSN_PARTS_[1]}"
GOLANG_LCL_="${GOLANG_LCL_}.${GOLANG_VSN_PARTS_[2]}"
GOLANG_LCL_BASE_="${GOLANG_LCL_}/go"
OK_=1
if [[ ! -d "${GOLANG_LCL_}" ]]; then
  mkdir -p "${GOLANG_LCL_}" > /dev/null
  OK_=0
elif [[ ! -f "${GOLANG_LCL_BASE_}/bin/go" ]]; then
  rm -r "${GOLANG_LCL_BASE}"
  OK_=0
fi
if (( 0 == $OK_ )); then
  # missing, so create it
  pushd "${GOLANG_LCL_}" > /dev/null
  tar xzf "${GOLANG_INSTALLKIT_}"
  popd > /dev/null
fi

# Done!
#
echo ""
echo "OK. Virtual environment for Go ${GOLANG_VSN_} is created."
echo "Use the command '. activate-venv.src' to activate;"
echo "Use command 'deactivate-venv' to deactivate."
echo ""
