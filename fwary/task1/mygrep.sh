#!/bin/bash

# mygrep.sh - A mini version of the grep command.

# Show help message
if [[ "$1" == "--help" ]]; then
  echo "Usage: $0 [options] search_string filename"
  echo "Options:"
  echo "  -n    Show line numbers for each match"
  echo "  -v    Invert match (show lines that do NOT match)"
  echo "You can combine options like -vn or -nv"
  echo "Examples:"
  echo "  $0 hello testfile.txt"
  echo "  $0 -n hello testfile.txt"
  echo "  $0 -vn hello testfile.txt"
  exit 0
fi

# Default values
show_line_numbers=false
invert_match=false

# Parse options
while getopts "nv" opt; do
  case $opt in
    n) show_line_numbers=true ;;
    v) invert_match=true ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

shift $((OPTIND-1)) # Shift parsed options

# Check for required arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 [options] search_string filename"
  exit 1
fi

search="$1"
file="$2"

# Check if file exists
if [[ ! -f "$file" ]]; then
  echo "Error: File '$file' does not exist."
  exit 1
fi

# Read file line by line
line_number=0
while IFS= read -r line; do
  ((line_number++))
  
  # Check for match
  if echo "$line" | grep -iq "$search"; then
    match=true
  else
    match=false
  fi
  
  # Handle invert match
  if [[ "$invert_match" == true ]]; then
    match=$([[ "$match" == false ]] && echo true || echo false)
  fi

  # Print if matches the condition
  if [[ "$match" == true ]]; then
    if [[ "$show_line_numbers" == true ]]; then
      echo "${line_number}:$line"
    else
      echo "$line"
    fi
  fi

done < "$file"
