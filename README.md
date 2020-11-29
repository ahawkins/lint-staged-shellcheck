# lint-staged-shellcheck

Integrate [shellcheck][] with [lint-staged].

## Why?

`lint-staged` requires a file global rule (i.e. `*.sh`). This does not
support matching files based on shebang, which is typical for
executable shell programs. This shim works around that by detecting
shell programs based on filename or shebang in the staged file list.
This also ensures that current and future files pass `shellcheck`.

## Getting Started

Install `shellcheck`:

```
$ brew install shellcheck
```

First, install `lint-staged-shellcheck`:

```
$ yarn add -D lint-staged-shellcheck
```

Second, add a global rule to your `lint-staged` config. Here's an
example for `package.json`:

```
{
  "lint-staged": {
    "*": [
      "lint-staged-shellcheck"
    ]
  }
}
```

**NOTE!** You should add `lint-staged-shellcheck` under a "match all
rule". `lint-staged-shellcheck` is smart enough to detect
applicable files. Adding it under the match all rule ensures
any applicable file in source control will pass `shellceck`.

## Ignoring Files

Create a `.shellcheckignore` file at the root for the repo. This file
using the [git
ignore](https://git-scm.com/docs/gitignore#_pattern_format). Here's an
example:

```
vendor/
script/dev
script/util.sh
```

**NOTE!** You only need to exclude files that may be run through
`shellcheck`. So, you do not need to ignore images or non-shell files.

## Developing

```
$ git clone git@github.com:ahawkins/lint-staged-shellcheck
$ git submodule update --init
$ brew install bats
$ bats test/acceptance_test.bats
```

[shellcheck]: https://www.shellcheck.net/
[lint-staged]: https://www.npmjs.com/package/lint-staged
