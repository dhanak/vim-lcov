SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := default
.DELETE_ON_ERROR:
.SUFFIXES:

.PHONY: default
default: test lint

.PHONY: test
test:
	if [ -n "$$(find test -type f -name '*.vader')" ]; then
		VIM_BIN=vim ./test/run_vader.sh
	fi
	if [ -n "$$(find test -type f -name '*.vim')" ]; then
		THEMIS_VIM=vim themis --recursive --reporter tap
	fi


.PHONY: test-nvim
test-nvim:
	if [ -n "$$(find test -type f -name '*.vader')" ]; then
		VIM_BIN=nvim ./test/run_vader.sh
	fi
	if [ -n "$$(find test -type f -name '*.vim')" ]; then
		THEMIS_VIM=nvim themis --recursive --reporter tap
	fi

.PHONY: lint
lint:
	vint .


.PHONY: lint_github_actions
lint_github_actions:
	actionlint -verbose -color .github/workflows/ci.yml

.PHONY: all
all: test test-nvim lint lint_github_actions


.PHONY: coverage-gen
coverage-gen:
	covimerage run vim -Nu test/vader.vimrc -c 'Vader! test/*.vader'
	coverage report -m > .coverage
