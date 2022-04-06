#!/usr/bin/env bash

TESTS_DIR=$(dirname "$(realpath "$0")")

# takes one optional argument if just want to run one vader test
# if no argument, run all vader tests
if [[ $# -gt 0 ]]; then
  TESTS="$(realpath "$1")"
else
  TESTS="$TESTS_DIR/**/*.vader"
fi

# export VADER_OUTPUT_FILE="$TESTS_DIR/vader.log"
# echo "check $VADER_OUTPUT_FILE for test ouputs"
# rm -f "$VADER_OUTPUT_FILE"

RCFILE="$TESTS_DIR/vader.vimrc"

# shellcheck disable=SC2153,SC2154
if [[ -n $VIM_BIN ]]; then
  vim_bin=$VIM_BIN
else
  vim_bin=vim
fi

$vim_bin -Es -N -U NONE -u "$RCFILE" -c "Vader! $TESTS"

# NOTE: because neovim does not support --not-a-term flag, so if the tests
#       require this flag turned on, neovim has to be invoked differently
#       with the --headless flag:
# nvim --headless -N -U NONE -u "$RCFILE" -c "Vader! $TESTS"
