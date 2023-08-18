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
#      This file defines make macros for manipulating and querying
#      paths.
#

# ChangeFileExtension <extension> <path>
#
# Replaces the existing file extension of the specified path with the
# supplied extension.

ChangeFileExtension		= $(addsuffix $(1),$(basename $(2)))

# Deslashify <path>
#
# Ensure that there is NO trailing directory delimiter at the end of
# the specified path.

Deslashify			= $(patsubst %$(Slash),%,$(1))

# Slashify <path>
#
# Ensure that there is a single trailing directory delimiter at the
# end of the specified path.

Slashify			= $(call Deslashify,$(1))$(Slash)

# IsPath <path>
#
# if the path contains path components (i.e. a directory delimiter),
# the path is returned.

IsPath				= $(if $(findstring $(Slash),$(1)),$(1),)

# IsRelativePath <path>
#
# If the path is relative (i.e. does not contain a leading directory
# delimiter), the path is returned.

IsRelativePath			= $(shell echo $(1) | $(SED) $(SEDFLAGS) -ne '/^[^/]/p')

# IsAbsolutePath <path>
#
# If the path is absolute (i.e. contains a leading directory
# delimiter), the path is returned.

IsAbsolutePath			= $(shell echo $(1) | $(SED) $(SEDFLAGS) -ne '/^[/]/p')

# FilterRelativePaths <paths>
#
# Returns only relative paths from the specified list of paths.

FilterRelativePaths		= $(foreach path,$(1),$(call IsRelativePath,$(path)))

# FilterAbsolutePaths <paths>
#
# Returns only absolute paths from the specified list of paths.

FilterAbsolutePaths		= $(foreach path,$(1),$(call IsAbsolutePath,$(path)))

# GenerateRelativeBasePath <path> <base>
#
# Generates the relative path of the specified directory to the base
# directory.

GenerateRelativeBasePath	= $(shell echo $(1) | $(SED) $(SEDFLAGS) -e s,$(call Slashify,$(2)),,g -e 's/[^\/]\{1,\}\(\/*\)/..\1/g')

# RemovePath <path> <base>
#
# Attempts to return the specified path with the base path removed, if
# path contains the base path.

RemovePath			= $(strip $(subst $(2),,$(1)))

# ReplacePath <path> <base> <replacement>
#
# Attempts to return the specified path with the base path removed and
# replaced with the specified replacement, if path contains the base
# path.

ReplacePath			= $(strip $(subst $(2),$(3),$(1)))

# CanonicalizePath <path>
#
# Attempt to canonicalize the specified path to an absolute path by
# collapsing multiple path separators, resolving '.' and '..' 
# components, and resolving symbolic links.

CanonicalizePath		= $(abspath $(1))

# GenerateEllipsedPath <path> <subpath>
#
# Generates a path suitable, for example, for display during a
# "silent" (i.e. don't echo commands as they are executed) build by
# replacing the specified leading subpath in the specified path with
# '...'.

GenerateEllipsedPath		= $(call ReplacePath,$(1),$(2),...)

# GenerateBuildRootEllipsedPath <path>
#
# Generates a path suitable for display during a "silent" (i.e. don't
# echo commands as they are executed) build by replacing the build root in
# the specified path with '...'.

GenerateBuildRootEllipsedPath	= $(call GenerateEllipsedPath,$(1),$(call CanonicalizePath,$(BuildRoot)))
