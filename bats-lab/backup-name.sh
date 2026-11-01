#!/usr/bin/env bash
# backup-name.sh PREFIX [STAMP]
#
# Prints the file name for a backup archive:
#   backup-name.sh photos 20261031-093000  ->  photos-20261031-093000.tar.gz
# STAMP defaults to the current date and time. Tests pass a fixed
# STAMP so the expected name is known exactly.
# An empty PREFIX is an error: a message on stderr and exit code 2.
set -u

prefix=${1:-}
stamp=${2:-$(date +%Y%m%d-%H%M%S)}

if [[ -z $prefix ]]; then
  echo "backup-name: a prefix is required" >&2
  exit 2
fi

printf '%s-%s.tar.gz\n' "$prefix" "$stamp"
