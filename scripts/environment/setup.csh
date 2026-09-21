#
#    Copyright (c) 2008-2023 Nuovation System Design, LLC. All Rights Reserved.
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
#      This file establishes the minimum environment, under the C
#      (csh) or Tenon C (tcsh) shells, for running a build of the tree
#      containing this script.
#
#      This script MUST BE sourced from a current working directory
#      within the tree.
#

# Assuming that the user has complied with the requirement to source
# this script from a working directory within the tree, attempt to
# find a directory containing both a 'build/scripts/environment/'
# directory and a 'Makefile'.
#
# Discard any root inherited from the caller's environment first. It
# describes whichever tree was last configured, not necessarily this
# one, and left in place it satisfies the existence test below when
# the search fails, silently configuring the wrong tree.

unsetenv BuildRoot

set first="${PWD}"
set current="${first}"
set last=""

# Try to find a valid root match until we are no longer making forward
# progress and have reached the top of the directory tree.

while ( "${current}" != "${last}" )

    # Check to see if the directory is a root match and if so, leave
    # with successful status.

    if (( -d "${current}"/build/scripts/environment ) && ( -f "${current}/Makefile" )) then
        setenv BuildRoot "${current}"
        break
    endif

    # If there was no match, save the current directory, and prune off
    # a piece of the path to try again.

    set last = "${current}"
    set current = `dirname "${last}"`
end

unset current
unset last

if ( ! $?BuildRoot ) then
    echo "Could not establish a root directory for this project above '${first}'! This script must be sourced from WITHIN the project tree."
    unset first

    exit 1
endif

unset first

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

setenv MAKEFLAGS "--no-print-directory -r -R -I ${BuildRoot}/third_party/nuovations-build-make/repo/make -I ${BuildRoot}/build/make"

# Users can create both build-global and -local
# additional/overriding environment information.

set BuildGlobalEnvironment = "${HOME}/.buildrc"
set BuildLocalEnvironment = "${BuildRoot}/build/${USER}/buildrc"

# Try the build-global file

if ( -r "${BuildGlobalEnvironment}" ) then
    source "${BuildGlobalEnvironment}"
endif

# Try the build-local file

if ( -r "${BuildLocalEnvironment}" ) then
    source "${BuildLocalEnvironment}"
endif

# Clean-up any variables we have set

unset BuildGlobalEnvironment
unset BuildLocalEnvironment
unset last
unset current

# Display to the user how we configured the build environment.

${BuildRoot}/third_party/nuovations-build-make/repo/scripts/printenv
