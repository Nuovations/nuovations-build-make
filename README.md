[![Build Status][nuovations-build-make-github-action-svg]][nuovations-build-make-github-action]

[nuovations-build-make-github]: https://github.com/nuovations/nuovations-build-make
[nuovations-build-make-github-action]: https://github.com/nuovations/nuovations-build-make/actions?query=branch%3Amain+event%3Apush+workflow%3ABuild
[nuovations-build-make-github-action-svg]: https://github.com/nuovations/nuovations-build-make/actions/workflows/build.yml/badge.svg?branch=main&event=push

Nuovations Build (Make)
=======================

# Introduction

Nuovations Build (Make) provides a GNU make-based command line
interface (CLI) build system for building any number of software
products or projects. While Nuovations Build is primarily targeted at
C-, C++-, Objective C-, or Objective C++-based software products, by
virtue of being make-based, it could be used for any product or
project for which a bespoke or otherwise make-based build system is
used.

The high-level goals of the build system are described below. For
those interested in the detailed requirements, can [read about those
requirements in REQUIREMENTS.md](./doc/REQUIREMENTS.md).

## Philosophy

Some of the high-level goals of Nuovations Build (Make) were to:

  * Allow a particular developer to focus on his/her part of the build tree as necessary to accomplish his/her task.
  * Minimize the amount of typing on the command-line to build a particular target at the top of the tree.
  * Minimize the amount of content that must placed into a make file to generate a target.
  * Not be dependent on a particular vendor, product or version of the tool chain.
  * Support multiple build products, build configurations of that product and build tool chains within a given project tree.

# Getting Started with Nuovations Build (Make)

To learn how to integrate and use Nuovations Build (Make) with your
project, take a look at [GETTING_STARTED.md](./doc/GETTING_STARTED.md).

# Interact

There are numerous avenues for Nuovations Build (Make) support:

  * Bugs and feature requests -- [submit to the Issue Tracker](https://github.com/nuovations/nuovations-build-make/issues)

# Versioning

Nuovations Build (Make) follows the [Semantic Versioning guidelines](http://semver.org/)
for release cycle transparency and to maintain backwards compatibility.

# License

Nuovations Build (Make) is released under the [Apache License, Version 2.0 license](https://opensource.org/licenses/Apache-2.0).
See the [LICENSE](./LICENSE) file for more information.
