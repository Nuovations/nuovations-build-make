#
#    Copyright (c) 2026 nuovations-build-make Authors. All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

##
#    @file
#      This file establishes the minimum environment, under the Fish shell, for
#      running a build of the tree containing this script. This script MUST BE
#      sourced from a current working directory within the tree.
#

##
#  @brief
#    Attempt to echo to standard output the directory of the path by
#    which this script was sourced.
#
#  This Fish shell-compatible function attempts to determine the
#  path by which this script was sourced. 
#

# Check if this file is being executed or sourced.

set sourced 0

if string match --quiet '*from sourcing file*' (status)
    set sourced 1
end

# Assuming that the user has complied with the requirement to source
# this script from a working directory within the tree, attempt to
# find a directory of the form '.../build/scripts/environment/'.

set -g first (cd $PWD && pwd)
set -g current "$first"
set -g last ""

# Try to find a valid root match until we are no longer making forward
# progress and have reached the top of the directory tree.

while test $current != $last
    if test -d "$current/build/scripts/environment" && test -f $current/Makefile
        set -gx BuildRoot "$current"
        break
    end

    # If there was no match, save the current directory, and prune off
    # a piece of the path to try again.

    set last "$current"
    set current (dirname "$last")
end

if test -z $BuildRoot
    echo "Could not establish a root directory for this project above '$first'! This script must be sourced from WITHIN the project tree."

    # If we're sourced, simply return so we don't close the user's session.

    if test $sourced -eq 1
        return 1
    else
        exit 1
    end
end

set -e  first
set -e  current
set -e  last

# Set-up the make flags. We use the following:
#
# --no-print-directory  Do not print 'make[n]: ...' as make traverses
#                       directories.
#
# -r                    No built-in rules. We have our own, thank you, and do
#                       not want any side effects for what just so happens to
#                       work for Solaris, Linux, Mac OS X, System V, BSD, etc.
#
# -R                    No built-in variables. We have our own, thank you, and
#                       do not want any side effects for what just so happens
#                       to work for Solaris, Linux, Mac OS X, System V, BSD,
#                       etc.
#
# -I <path>             Location where make can find make include files. We
#                       adopt this approach since one of the goals of this
#                       build environment is making make files sparse. Doing
#                       otherwise would require '${BuildRoot}/build/make/
#                       <foo>.mak' instead of 'include <foo>.mak', a lot of
#                       extra typing for a project tree's worth of make files.
#
#                       Two such default paths are established: First,
#                       the path to the Nuovations Build (Make)
#                       makefile header directory; second, the path to
#                       the makefile header directory for the project
#                       using Nuovations Build (Make).

set -gx MAKEFLAGS "--no-print-directory -r -R -I $BuildRoot/third_party/nuovations-build-make/repo/make -I $BuildRoot/build/make"

# Users can create both build-global and -local
# additional/overriding environment information.
# NOTE: These files must be in fish script:
# https://superuser.com/questions/826333/is-there-a-way-to-source-a-sh-script-from-the-fish-shell

set BuildGlobalEnvironment "$HOME/.buildrc"
set BuildLocalEnvironment "$BuildRoot/build/$USER/buildrc"

# Try the build-global file

if test -r $BuildGlobalEnvironment
    source $BuildGlobalEnvironment
end

# Try the build-local file

if test -r $BuildLocalEnvironment
    source $BuildLocalEnvironment
end

# Clean-up any variables we have set

set -e BuildGlobalEnvironment
set -e BuildLocalEnvironment

# Display to the user how we configured the build environment.

$BuildRoot/third_party/nuovations-build-make/repo/scripts/printenv
