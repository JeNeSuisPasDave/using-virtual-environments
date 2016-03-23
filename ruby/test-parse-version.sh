#! /bin/bash
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

# Try parsing some string
#
VERSION_="$1"
parse_version "${VERSION_}"
if (( 0 != $? )); then
  echo "ERROR: failed to parse VERSION_"
  exit 2
fi
VERSION_PARTS_=( ${parse_version[@]} )
echo "VERSION_PARTS_: ${VERSION_PARTS_[@]}"
