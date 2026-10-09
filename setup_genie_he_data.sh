# setup_genie_he_data.sh
# Source this from bash or zsh:   . /path/to/setup_genie_he_data.sh
# Exports:
#   GENIE_HE_DATA_DIR     directory containing this file
#   HEDIS_SF_DATA_PATH    hedis-sf data
#   PHOTON_SF_DATA_PATH   photon-sf data
#   LHAPDF_DATA_PATH      pdf data (added to any existing setting)
#                         also adds results of:  lhapdf-config --datadir
#
_sl_resolve() {
  realpath "$1" 2>/dev/null ||
  readlink -f "$1" 2>/dev/null ||
  (
    if [ -n "${ZSH_VERSION:-}" ]; then
      CDPATH= builtin cd -q -P -- "$(dirname -- "$1")"
    else
      CDPATH= builtin cd -P -- "$(dirname -- "$1")"
    fi &&
    printf '%s/%s\n' "$(pwd -P)" "$(basename -- "$1")"
  )
}

# The shell-specific expansions are wrapped in eval so that shells which
# don't understand them (e.g. dash) never try to parse them.
if [ -n "${BASH_VERSION:-}" ]; then
  eval '_sl_src=${BASH_SOURCE[0]}'
elif [ -n "${ZSH_VERSION:-}" ]; then
  eval '_sl_src=${(%):-%x}'
else
  _sl_src=$0   # correct only if executed; wrong if sourced from plain sh
  echo "setup_genie_he_data.sh: unsupported shell; SCRIPT_PATH may be wrong" >&2
fi

_sl_path=$(_sl_resolve "$_sl_src")
GENIE_HE_DATA_DIR=$(dirname -- "$_sl_path")
export GENIE_HE_DATA_DIR

HEDIS_SF_DATA_PATH=${GENIE_HE_DATA_DIR}/hedis-sf
PHOTON_SF_DATA_PATH=${GENIE_HE_DATA_DIR}/photon-sf

# ${LHAPDF_DATA_PATH} should be a colon-separated list of directories,
#   searched left-to-right.  The `lhapdf-config --datadir` should
#   contain a "lhapdf.conf" file.  If the built package was relocated
#   but the binary wasn't patched, lhapdf.conf might not be found,
#   so add the location that lhapdf-config gives to be safe.

if [ ! -z "${LHAPDF_DATA_PATH}" ]; then
  LHAPDF_DATA_PATH=${GENIE_HE_DATA_DIR}/pdfs:${LHAPDF_DATA_PATH}
else
  LHAPDF_DATA_PATH=${GENIE_HE_DATA_DIR}/pdfs
fi

# safely add `lhapdf-config --datadir` to $LHAPDF_DATA_PATH
# if lhapdf-config is a command and the result is a directory
if command -v lhapdf-config >/dev/null 2>&1; then
  _lhapdf_dir="$(lhapdf-config --datadir 2>/dev/null)"
  if [ -n "$_lhapdf_dir" ] && [ -d "$_lhapdf_dir" ]; then
    case ":${LHAPDF_DATA_PATH}:" in
      *":${_lhapdf_dir}:"*) ;;  # already present, do nothing
      *) export LHAPDF_DATA_PATH="${LHAPDF_DATA_PATH}:${_lhapdf_dir}" ;;
    esac
  fi
  unset _lhapdf_dir
fi
export HEDIS_SF_DATA_PATH
export PHOTON_SF_DATA_PATH
export LHAPDF_DATA_PATH

# Clean up so nothing leaks into the calling shell.
unset -f _sl_resolve
unset _sl_src
unset _sl_path
