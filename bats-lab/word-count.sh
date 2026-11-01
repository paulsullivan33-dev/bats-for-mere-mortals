#!/usr/bin/env bash
# word-count.sh FILE
#
# Prints the file's line count and word count, one per line:
#   lines: 3
#   words: 9
# A missing argument or a file that does not exist is an error:
# a message on stderr and exit code 2.
set -u

file=${1:-}

if [[ -z $file ]]; then
  echo "word-count: a file is required" >&2
  exit 2
fi

if [[ ! -f $file ]]; then
  echo "word-count: no such file: $file" >&2
  exit 2
fi

lines=$(wc -l < "$file")
words=$(wc -w < "$file")
printf 'lines: %s\nwords: %s\n' "$((lines))" "$((words))"
