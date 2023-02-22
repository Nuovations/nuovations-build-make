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
#      This file establishes the minimum environment, under the Bourne
#      (sh), Bourne Again (bash) or Korn (ksh) shells, for running a
#      build of the tree containing this script. This script MUST BE
#      sourced from a current working directory within the tree.
#

##
#  @brief
#    Attempt to echo to standard output the directory of the path by
#    which this script was sourced.
#
#  This Bourne shell-compatible function attempts to determine the
#  path by which this script was sourced. Since there is no POSIX
#  standard for sourcing shell scripts and no Bourne shell-compatible
#  and -standard way to accomplish this, we try a series of fallbacks,
#  landing at ${PWD} as a last resort.
#
#  @note
#    At minimum, this should work with bash, dash, ksh, sh, and zsh.
#
our_path_dir()
{
    if [ -n "${BASH_SOURCE}" ]; then
        echo "$(dirname ${BASH_SOURCE})"
    elif [ "z${SHELL}" != "z" ] && [ "$(basename ${SHELL})" = "ksh" ] && [ -n "${.sh.file}" ]; then
        echo "$(dirname ${.sh.file})"
    else
        echo "${PWD}"
    fi
}

# Figure out if we're sourced or executed by executing 'return' in a
# subshell.
#
# The return statement is invalid if we are not sourced, leading to an
# exit code of 1. If it succeeds and the return code is 0 we know
# that the script was sourced. The redirection sends stdout and
# stderr to /dev/null.

$(return >/dev/null 2>&1)

if [ "${?}" -eq 0 ]; then
    sourced=1
else
    sourced=0
fi

# Assuming that the user has complied with the requirement to source
# this script from a working directory within the tree, attempt to
# find a directory of the form '.../build/scripts/environment/'.

first="$(cd $(our_path_dir) && pwd)"
current="${first}"
last=""

# Try to find a valid root match until we are no longer making forward
# progress and have reached the top of the directory tree.

until [ "${current}" = "${last}" ]; do

    # Check to see if the directory is a root match and if so, leave
    # with successful status.

    if [ -d "${current}/build/scripts/environment" ] && [ -f "${current}/Makefile" ]; then
        export BuildRoot="${current}"
        break
    fi

    # If there was no match, save the current directory, and prune off
    # a piece of the path to try again.

    last="${current}"
    current=`dirname "${last}"`
done

unset first
unset current
unset last

if [ -z "${BuildRoot}" ]; then
    echo "Could not establish a root directory for this project above '${first}'! This script must be sourced from WITHIN the project tree."

    # If we're sourced, simply return so we don't close the user's session.

    if [ ${sourced} -eq 1 ]; then
        return 1
    else
        exit 1
    fi
fi

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

export MAKEFLAGS="--no-print-directory -r -R -I ${BuildRoot}/third_party/nuovations-build-make/repo/make -I ${BuildRoot}/build/make"

# Users can create both build-global and -local
# additional/overriding environment information.

BuildGlobalEnvironment="${HOME}/.buildrc"
BuildLocalEnvironment="${BuildRoot}/build/${USER}/buildrc"

# Try the build-global file

if [ -r "${BuildGlobalEnvironment}" ]; then
    . "${BuildGlobalEnvironment}"
fi

# Try the build-local file

if [ -r "${BuildLocalEnvironment}" ]; then
    . "${BuildLocalEnvironment}"
fi

# Clean-up any variables we have set

unset BuildGlobalEnvironment
unset BuildLocalEnvironment

# Display to the user how we configured the build environment.

${BuildRoot}/third_party/nuovations-build-make/repo/scripts/printenv
