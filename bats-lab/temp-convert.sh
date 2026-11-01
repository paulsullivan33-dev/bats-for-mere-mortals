#!/usr/bin/env bash
# temp-convert.sh VALUE SCALE
#
# Converts a temperature to the other scale and prints the result.
#   temp-convert.sh 100 C   ->  212.0 F
#   temp-convert.sh 32 F    ->  0.0 C
# A value that is not a number, or a scale other than C or F,
# is an error: a message on stderr and exit code 2.
set -u

value=${1:-}
scale=${2:-}

if [[ ! $value =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
  echo "temp-convert: '$value' is not a number" >&2
  exit 2
fi

case $scale in
  C) awk -v c="$value" 'BEGIN { printf "%.1f F\n", c * 9 / 5 + 32 }' ;;
  F) awk -v f="$value" 'BEGIN { printf "%.1f C\n", (f - 32) * 5 / 9 }' ;;
  *)
    echo "temp-convert: scale must be C or F" >&2
    exit 2
    ;;
esac
