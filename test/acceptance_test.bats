#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	run shellcheck --version
	assert_success

	export "PATH=${PWD}/test/stubs:${PWD}/bin:${PATH}"
}

shellcheck_fixture() {
	assert [ -d "${1}" ]
	local -a files=()

	pushd "${1}" > /dev/null

	# XXX: simulate a glob in the current directory becauase
	# bats does not treat * as a shell glob when used in the 
	# run command.
	while read file; do
		if [ "${file}" != "." ]; then
			files+=("${file}")
		fi
	done < <(find . -print | sed -E 's/^\.\///')

	assert [ "${#files}" -gt 0 ]

	run lint-staged-shellcheck "${files[@]}"
	popd > /dev/null
}

@test "passes on vaild files" {
	shellcheck_fixture test/fixtures/pass
	assert_success
}

@test "skips when no matched files" {
	shellcheck_fixture test/fixtures/empty
	assert_success
}

@test "supports .shellcheckignore file" {
	run shellcheck test/fixtures/shellcheckignore/*.sh
	assert_failure

	shellcheck_fixture test/fixtures/shellcheckignore
	assert_success
}

# XXX: This test uses a mock shellcheck that echos all arguments
# to stdout. This enables assertions against recieved files.
@test "detects testable files" {
	run env "PATH=${PWD}/test/mocks:${PATH}" lint-staged-shellcheck test/fixtures/detection/*
	assert_success
	assert_output --partial usr_bin_env_bash
	assert_output --partial bin_bash
	assert_output --partial dot.sh
	assert_output --partial dot.bash
}
