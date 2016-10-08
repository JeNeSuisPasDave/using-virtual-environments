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

echo "SCRIPTDIR_: ${SCRIPTDIR_}"

# Pick up the verification functions
#
. "${SCRIPTDIR_}/check-functions.src"

# Make sure the bin, pkg, and src folders exist
#
if [[ ! -d "$GOPATH/bin" ]]; then
  mkdir "$GOPATH/bin"
fi
if [[ ! -d "$GOPATH/pkg" ]]; then
  mkdir "$GOPATH/pkg"
fi
if [[ ! -d "$GOPATH/src" ]]; then
  mkdir "$GOPATH/src"
fi

# Check that the project source has been placed in the workspace
#
if [[ ! -d "$GOPATH" ]]; then
  echo -n "Clone the 'hashicorp/raft' repository to "
  echo "'$GOPATH/src/github.com/hashicorp/raft'"
  exit 100
fi
if [[ ! -f "$GOPATH/src/github.com/hashicorp/raft/raft.go" ]]; then
  echo "Check a complete branch into '$GOPATH'"
  exit 102
fi

# Set version expectations
#
GOLANG_VSN_="1.6.3"
GOLANG_LCL_=".golcl"
GO_VSN_EXP_="1.6.3"
GO_VSN_MAX_="1.6.4"
GLIDE_VSN_EXP_="0.12.2"
GLIDE_VSN_MAX_="0.12.3"

# Loads function to check Go virtual environment status
#
. "${SCRIPTDIR_}/check-active-venv-functions.src"

# Check whether the Go virtual enviornment is active
#
is_venv_golang_active
if (( 0 != $? )); then
  exit 2
fi

# Check that the Go version is correct
#
is_golang_version_correct
if (( 0 != $? )); then
  exit 4
fi

# Check whether Glide is available; will install Glide if not already installed
#
. "${SCRIPTDIR_}/check-active-glide-functions.src"
. "${SCRIPTDIR_}/get-glide-functions.src"

# Check whether Glide is available from the Go virtual environment
#
is_glide_installed
if (( 0 != $? )); then
  install_glide "${GLIDE_VSN_EXP_}"
  is_glide_available
  if (( 0 != $? )); then
    exit 6
  fi
fi

# Check that the Glide version is correct
#
is_glide_version_correct
if (( 0 != $? )); then
  exit 8
fi

# install the depdencies
#
glide install
