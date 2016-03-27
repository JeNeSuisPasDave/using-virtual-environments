# NOTE: expect that this is preceded by:
# source check-functions.src
#

SASS_VSN_EXP_=3.1.3
SASS_VSN_MAX_=3.1.4
CHUNKY_PNG_VSN_EXP_=1.2.0
CHUNKY_PNG_VSN_MAX_=1.2.1
FSSM_VSN_EXP_=0.2.7
FSSM_VSN_MAX_=0.2.8
COMPASS_VSN_EXP_=0.11.3
COMPASS_VSN_MAX_=0.11.4

# Capture pip packages
#
PKGS_=`gem list`

# Check whether Sass installed
#
is_this_gem_installed "sass" "${SASS_VSN_EXP_}" "${SASS_VSN_MAX_}"
if (( 0 == $is_this_gem_installed )); then
  exit 8
fi

# Check whether chunky_png installed
#
is_this_gem_installed "chunky_png" "${CHUNKY_PNG_VSN_EXP_}" "${CHUNKY_PNG_VSN_MAX_}"
if (( 0 == $is_this_gem_installed )); then
  exit 8
fi

# Check whether fssm installed
#
is_this_gem_installed "fssm" "${FSSM_VSN_EXP_}" "${FSSM_VSN_MAX_}"
if (( 0 == $is_this_gem_installed )); then
  exit 8
fi

# Check whether compass installed
#
is_this_gem_installed "compass" "${COMPASS_VSN_EXP_}" "${COMPASS_VSN_MAX_}"
if (( 0 == $is_this_gem_installed )); then
  exit 8
fi
