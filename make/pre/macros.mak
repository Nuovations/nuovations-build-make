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
#      This file defines make macros common to all other make headers
#      and files.
#

include pre/macros/constants.mak
include pre/macros/undefined.mak
include pre/macros/environment.mak
include pre/macros/suffixes.mak
include pre/macros/strings.mak
include pre/macros/paths.mak
include pre/macros/pretty.mak
include pre/macros/verbosity.mak
include pre/macros/tps.mak

# Any of the three directories depend, object, and result may be
# involved in order-only dependencies. In general, it would be OK for
# them to have trailing slashes; however, make-3.81 has a bug such
# that trailing slashes in order-only dependencies causes make-3.81 to
# incorrectly regard other non-order-only dependencies as complete
# when they are not. See:
#
#   http://savannah.gnu.org/bugs/?22531
#
# for further information. So, to work around this, care must be taken
# that directories never HAVE trailing slashes to ensure correct
# operation with make-3.81.
#
# Judicious use of the Deslashify and Slashify macros ensure we achieve
# this goal.

##
## Makefiles
##

# FirstMakefile
#
# Returns the first makefile in the make-maintained MAKEFILE_LIST
# variable. This should be the name of the first makefile in the
# current directory that make invoked.

FirstMakefile                           = $(firstword $(MAKEFILE_LIST))

# LastMakefile
#
# Returns the last makefile in the make-maintained MAKEFILE_LIST
# variable. This should be the name of the last makefile included
# via an include, -include, or sinclude directive.

LastMakefile                            = $(lastword $(MAKEFILE_LIST))

# GenerateUnconditionalHostBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current unconditional host
# build tuple, effectively creating a build tuple-qualified directory
# name that can be used to store build-tuple-specific files.

GenerateUnconditionalHostBuildQualifiedDirectory        = $(call Deslashify,$(call Slashify,$(1))$(UnconditionalHostBuildTuple))

# GenerateUnconditionalTargetBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current unconditional target
# build tuple, effectively creating a build tuple-qualified directory
# name that can be used to store build-tuple-specific files.

GenerateUnconditionalTargetBuildQualifiedDirectory      = $(call Deslashify,$(call Slashify,$(1))$(UnconditionalTargetBuildTuple))

# GenerateUnconditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current unconditional default
# (that is, host or target, depending on the value of
# BuildHostSpecialized) build tuple, effectively creating a build
# tuple-qualified directory name that can be used to store
# build-tuple-specific files.

GenerateUnconditionalBuildQualifiedDirectory            = $(call Deslashify,$(call Slashify,$(1))$(UnconditionalBuildTuple))

# GenerateMakeUnconditionalHostBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# unconditional host build tuple, effectively creating a makefile- and
# build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

GenerateMakeUnconditionalHostBuildQualifiedDirectory    = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(UnconditionalHostBuildTuple))

# GenerateMakeUnconditionalTargetBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# unconditional target build tuple, effectively creating a makefile-
# and build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

GenerateMakeUnconditionalTargetBuildQualifiedDirectory  = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(UnconditionalTargetBuildTuple))

# GenerateMakeUnconditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# unconditional default (that is, host or target, depending on the
# value of BuildHostSpecialized) build tuple, effectively creating a
# makefile- and build tuple- qualified directory name that can be used
# to store makefile- and build-tuple-specific files.

GenerateMakeUnconditionalBuildQualifiedDirectory        = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(UnconditionalBuildTuple))

# GenerateConditionalHostBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current conditional host
# build tuple, effectively creating a build tuple-qualified directory
# name that can be used to store build-tuple-specific files.

GenerateConditionalHostBuildQualifiedDirectory          = $(call Deslashify,$(call Slashify,$(1))$(ConditionalHostBuildTuple))

# GenerateConditionalTargetBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current conditional target
# build tuple, effectively creating a build tuple-qualified directory
# name that can be used to store build-tuple-specific files.

GenerateConditionalTargetBuildQualifiedDirectory        = $(call Deslashify,$(call Slashify,$(1))$(ConditionalTargetBuildTuple))

# GenerateConditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current conditional default
# (that is, host or target, depending on the value of
# BuildHostSpecialized) build tuple, effectively creating a build
# tuple-qualified directory name that can be used to store
# build-tuple-specific files.

GenerateConditionalBuildQualifiedDirectory              = $(call Deslashify,$(call Slashify,$(1))$(ConditionalBuildTuple))

# GenerateMakeConditionalHostBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# conditional host build tuple, effectively creating a makefile- and
# build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

GenerateMakeConditionalHostBuildQualifiedDirectory      = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(ConditionalHostBuildTuple))

# GenerateMakeConditionalTargetBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# conditional target build tuple, effectively creating a makefile- and
# build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

GenerateMakeConditionalTargetBuildQualifiedDirectory    = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(ConditionalTargetBuildTuple))

# GenerateMakeConditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# conditional default (that is, host or target, depending on the value
# of BuildHostSpecialized) build tuple, effectively creating a
# makefile- and build tuple- qualified directory name that can be used
# to store makefile- and build-tuple-specific files.

GenerateMakeConditionalBuildQualifiedDirectory          = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(ConditionalBuildTuple))

# GenerateHiddenName <names>
#
# Scope: Public
#
# Generate file names that will be, by default, hidden from a normal
# directory listing

GenerateHiddenNames                     = $(addprefix $(Dot),$(1))

##
## Dependencies
##

DependBaseDirectoryName                := depend
DependBaseDirectory                    := $(call GenerateHiddenNames,$(DependBaseDirectoryName))

# HostDependDirectory
#
# The private or hidden directory where host-specific dependencies
# will be accessed.

HostDependDirectory                     = $(call GenerateMakeConditionalHostBuildQualifiedDirectory,$(DependBaseDirectory))

# TargetDependDirectory
#
# The private or hidden directory here target-specific dependencies
# will be accessed.

TargetDependDirectory                   = $(call GenerateMakeConditionalTargetBuildQualifiedDirectory,$(DependBaseDirectory))

# DependDirectory
#
# The private or hidden directory where default (that is, host or
# target, depending on the value of BuildHostSpecialized) dependencies
# will be accessed.

DependDirectory                         = $(call GenerateMakeConditionalBuildQualifiedDirectory,$(DependBaseDirectory))

# GenerateHostDependPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the host dependency
# directory, from the specified path(s).

GenerateHostDependPaths                 = $(addprefix $(call Slashify,$(HostDependDirectory)),$(notdir $(1)))

# GenerateTargetDependPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the target dependency
# directory, from the specified path(s).

GenerateTargetDependPaths               = $(addprefix $(call Slashify,$(TargetDependDirectory)),$(notdir $(1)))

# GenerateDependPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the default (that is,
# host or target, depending on the value of BuildHostSpecialized)
# dependency directory, from the specified path(s).

GenerateDependPaths                     = $(addprefix $(call Slashify,$(DependDirectory)),$(notdir $(1)))

##
## Intermediate Build Results
##

# Build directories are where intermediate build result files are located.

BuildBaseDirectoryName                 := build
BuildBaseDirectory                     := $(call GenerateHiddenNames,$(BuildBaseDirectoryName))

# HostBuildDirectory
#
# The private or hidden directory where host-specific intermediate
# build results will be accessed.

HostBuildDirectory                      = $(call GenerateMakeConditionalHostBuildQualifiedDirectory,$(BuildBaseDirectory))

# TargetBuildDirectory
#
# The private or hidden directory here target-specific intermediate
# build results will be accessed.

TargetBuildDirectory                    = $(call GenerateMakeConditionalTargetBuildQualifiedDirectory,$(BuildBaseDirectory))

# BuildDirectory
#
# The private or hidden directory where default (that is, host or
# target, building on the value of BuildHostSpecialized) intermediate
# build results will be accessed.

BuildDirectory                          = $(call GenerateMakeConditionalBuildQualifiedDirectory,$(BuildBaseDirectory))

# GenerateHostBuildPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the host build/object
# directory, from the specified path(s).

GenerateHostBuildPaths                  = $(addprefix $(call Slashify,$(HostBuildDirectory)),$(1))

# GenerateTargetBuildPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the target
# build/object directory, from the specified path(s).

GenerateTargetBuildPaths                = $(addprefix $(call Slashify,$(TargetBuildDirectory)),$(1))

# GenerateBuildPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the default (that is,
# host or target, building on the value of BuildHostSpecialized)
# build/object directory, from the specified path(s).

GenerateBuildPaths                      = $(addprefix $(call Slashify,$(BuildDirectory)),$(1))

##
## Final Build Results
##

# Result directories are where final build result files are located.
#
# Unlike depend and build directories, result directories are at the
# top of the project tree and are "public". That is, they can assume
# to be traversed by any other command or executable in the project.

ResultBaseDirectoryName                := results
ResultBaseDirectory                     = $(call Deslashify,$(call Slashify,$(call CanonicalizePath,$(BuildRoot)))$(ResultBaseDirectoryName))

ResultHostBuildDirectory                = $(call GenerateUnconditionalHostBuildQualifiedDirectory,$(ResultBaseDirectory))
ResultTargetBuildDirectory              = $(call GenerateUnconditionalTargetBuildQualifiedDirectory,$(ResultBaseDirectory))
ResultBuildDirectory                    = $(call GenerateUnconditionalBuildQualifiedDirectory,$(ResultBaseDirectory))

# GenerateHostResultSubdirectory <subdirectory>
#
# Generates the name of a subdirectory, rooted in the host result directory.

GenerateHostResultSubdirectory          = $(call Deslashify,$(call Slashify,$(ResultHostBuildDirectory))$(subst $(call Slashify,$(call CanonicalizePath,$(BuildRoot))),,$(1)))

# GenerateTargetResultSubdirectory <subdirectory>
#
# Generates the name of a subdirectory, rooted in the target result directory.

GenerateTargetResultSubdirectory        = $(call Deslashify,$(call Slashify,$(ResultTargetBuildDirectory))$(subst $(call Slashify,$(call CanonicalizePath,$(BuildRoot))),,$(1)))

# GenerateResultSubdirectory <subdirectory>
#
# Generates the name of a subdirectory, rooted in the default (that
# is, host or target, building on the value of BuildHostSpecialized)
# result directory.

GenerateResultSubdirectory              = $(call Deslashify,$(call Slashify,$(ResultBuildDirectory))$(subst $(call Slashify,$(call CanonicalizePath,$(BuildRoot))),,$(1)))

# GenerateHostResultPaths <subdirectory> <paths>
#
# Generates the name(s) of a path(s), rooted in the optional specified
# host results subdirectory, from the specified path(s). If the
# subdirectory is not specified, the subdirectory is generated from
# the current directory.

GenerateHostResultPaths                 = $(call CanonicalizePath,$(addprefix $(call Slashify,$(call GenerateHostResultSubdirectory,$(if $(1),$(1),$(CURDIR)))),$(2)))

# GenerateHostResultPaths <subdirectory> <paths>
#
# Generates the name(s) of a path(s), rooted in the optional specified
# target results subdirectory, from the specified path(s). If the
# subdirectory is not specified, the subdirectory is generated from
# the current directory.

GenerateTargetResultPaths               = $(call CanonicalizePath,$(addprefix $(call Slashify,$(call GenerateTargetResultSubdirectory,$(if $(1),$(1),$(CURDIR)))),$(2)))

# GenerateResultPaths <subdirectory> <paths>
#
# Generates the name(s) of a path(s), rooted in the optional specified
# default (that is, host or target, building on the value of
# BuildHostSpecialized) results subdirectory, from the specified
# path(s). If the subdirectory is not specified, the subdirectory is
# generated from the current directory.

GenerateResultPaths                     = $(call CanonicalizePath,$(addprefix $(call Slashify,$(call GenerateResultSubdirectory,$(if $(1),$(1),$(CURDIR)))),$(2)))

# HostResultDirectory
#
# The public directory where host-specific final build results will be
# accessed.

HostResultDirectory                     = $(call GenerateHostResultSubdirectory,$(CURDIR))

# TargetResultDirectory
#
# The public directory where target-specific final build results will be
# accessed.

TargetResultDirectory                   = $(call GenerateTargetResultSubdirectory,$(CURDIR))

# ResultDirectory
#
# The public directory where default (that is, host or target,
# building on the value of BuildHostSpecialized) final build results
# will be accessed.

ResultDirectory                         = $(call GenerateResultSubdirectory,$(CURDIR))

##
## Build Root
##

# GenerateRelativeBuildRoot <path>
#
# Generates the relative path components (i.e. '../') to the build
# root from the specified path.

GenerateRelativeBuildRoot               = $(call GenerateRelativeBasePath,$(1),$(call CanonicalizePath,$(BuildRoot)))

# RelativeBuildRoot
#
# The relative path components to the build root from the current
# directory.

RelativeBuildRoot                       = $(call GenerateRelativeBuildRoot,$(CURDIR))

# GenerateBaseDependNames <paths>
#
# Generates the name(s) of the base (non-post-processed) dependency path(s)
# from the specified path(s).

GenerateBaseDependNames                 = $(call ChangeFileExtension,$(BaseDependSuffix),$(1))

# GeneratePatchedDependNames <paths>
#
# Generates the name(s) of the patched (post-processed) dependency path(s)
# from the specified path(s).

GeneratePatchedDependNames              = $(call ChangeFileExtension,$(PatchedDependSuffix),$(1))

# GenerateHostBaseDependPaths <paths>
#
# Generates the path(s) of the base (non-post-processed) dependency
# path(s), rooted in the host dependency directory, from the specified
# path(s).

GenerateHostBaseDependPaths             = $(call GenerateHostDependPaths,$(call GenerateBaseDependNames,$(1)))

# GenerateTargetBaseDependPaths <paths>
#
# Generates the path(s) of the base (non-post-processed) dependency
# path(s), rooted in the target dependency directory, from the
# specified path(s).

GenerateTargetBaseDependPaths           = $(call GenerateTargetDependPaths,$(call GenerateBaseDependNames,$(1)))

# GenerateBaseDependPaths <paths>
#
# Generates the path(s) of the base (non-post-processed) dependency
# path(s), rooted in the default (that is, host or target, building on
# the value of BuildHostSpecialized) dependency directory, from the
# specified path(s).

GenerateBaseDependPaths                 = $(call GenerateDependPaths,$(call GenerateBaseDependNames,$(1)))

# GenerateHostPatchedDependPaths <paths>
#
# Generates the path(s) of the patched (post-processed) dependency
# path(s), rooted in the host dependency directory, from the specified
# path(s).

GenerateHostPatchedDependPaths          = $(call GenerateHostDependPaths,$(call GeneratePatchedDependNames,$(1)))

# GenerateTargetPatchedDependPaths <paths>
#
# Generates the path(s) of the patched (post-processed) dependency
# path(s), rooted in the target dependency directory, from the
# specified path(s).

GenerateTargetPatchedDependPaths        = $(call GenerateTargetDependPaths,$(call GeneratePatchedDependNames,$(1)))

# GeneratePatchedDependPaths <paths>
#
# Generates the path(s) of the patched (post-processed) dependency
# path(s), rooted in the default (that is, host or target, building on
# the value of BuildHostSpecialized) dependency directory, from the
# specified path(s).

GeneratePatchedDependPaths              = $(call GenerateDependPaths,$(call GeneratePatchedDependNames,$(1)))

# GenerateObjectNames <extension> <paths>
#
# Generates an object name(s) by replacing the existing file extension of
# the specified path(s) with the supplied object extension.

GenerateObjectNames                     = $(call ChangeFileExtension,$(1),$(2))

# GenerateSharedObjectNames <paths>
#
# Generates a shared object name(s) by replacing the existing file
# extension of the specified path(s) with the defined shared object
# extension.

GenerateSharedObjectNames               = $(call GenerateObjectNames,$(SharedObjectSuffix),$(1))

# GenerateStaticObjectNames <paths>
#
# Generates a static object name(s) by replacing the existing file
# extension of the specified path(s) with the defined static object
# extension.

GenerateStaticObjectNames               = $(call GenerateObjectNames,$(StaticObjectSuffix),$(1))

# GenerateHostObjectPaths <extension> <paths>
#
# Generates an object path(s), rooted in the host build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the supplied object extension.

GenerateHostObjectPaths                 = $(call GenerateHostBuildPaths,$(notdir $(call GenerateObjectNames,$(1),$(2))))

# GenerateTargetObjectPaths <extension> <paths>
#
# Generates an object path(s), rooted in the target build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the supplied object extension.

GenerateTargetObjectPaths               = $(call GenerateTargetBuildPaths,$(notdir $(call GenerateObjectNames,$(1),$(2))))

# GenerateObjectPaths <extension> <paths>
#
# Generates an object path(s), rooted in the default (that is, host or
# target, building on the value of BuildHostSpecialized) build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the supplied object extension.

GenerateObjectPaths                     = $(call GenerateBuildPaths,$(notdir $(call GenerateObjectNames,$(1),$(2))))

# GenerateHostSharedObjectPaths <paths>
#
# Generates a shared object path(s), rooted in the host build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined shared object extension.

GenerateHostSharedObjectPaths           = $(call GenerateHostBuildPaths,$(notdir $(call GenerateSharedObjectNames,$(1))))

# GenerateTargetSharedObjectPaths <paths>
#
# Generates a shared object path(s), rooted in the target build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined shared object extension.

GenerateTargetSharedObjectPaths         = $(call GenerateTargetBuildPaths,$(notdir $(call GenerateSharedObjectNames,$(1))))

# GenerateSharedObjectPaths <paths>
#
# Generates a shared object path(s), rooted in the default (that is,
# host or target, building on the value of BuildHostSpecialized)
# build/object directory, by replacing the existing file extension of
# the specified path(s) with the defined shared object extension.

GenerateSharedObjectPaths               = $(call GenerateBuildPaths,$(notdir $(call GenerateSharedObjectNames,$(1))))

# GenerateHostStaticObjectPaths <paths>
#
# Generates a static object path(s), rooted in the host build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined static object extension.

GenerateHostStaticObjectPaths           = $(call GenerateHostBuildPaths,$(notdir $(call GenerateStaticObjectNames,$(1))))

# GenerateTargetStaticObjectPaths <paths>
#
# Generates a static object path(s), rooted in the target build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined static object extension.

GenerateTargetStaticObjectPaths         = $(call GenerateTargetBuildPaths,$(notdir $(call GenerateStaticObjectNames,$(1))))

# GenerateStaticObjectPaths <paths>
#
# Generates a static object path(s), rooted in the default (that is,
# host or target, building on the value of BuildHostSpecialized)
# build/object directory, by replacing the existing file extension of
# the specified path(s) with the defined static object extension.

GenerateStaticObjectPaths               = $(call GenerateBuildPaths,$(notdir $(call GenerateStaticObjectNames,$(1))))

# GenerateLibraryNames <extension> <names>
#
# Generates a library name(s) by concatenating a predefined library
# prefix, the specified name(s) and the specified library extension.

GenerateLibraryNames                    = $(addsuffix $(1),$(addprefix $(LibraryPrefix),$(2)))

# GenerateArchiveLibraryNames <names>
#
# Generates an archive library name(s) by concatenating a predefined
# library prefix, the specified name(s) and the defined archive library
# extension.

GenerateArchiveLibraryNames             = $(call GenerateLibraryNames,$(ArchiveLibrarySuffix),$(1))

# GenerateSharedLibraryNames <names>
#
# Generates a shared library name(s) by concatenating a predefined
# library prefix, the specified name(s) and the defined shared library
# extension.

GenerateSharedLibraryNames              = $(call GenerateLibraryNames,$(SharedLibrarySuffix),$(1))

# GenerateHostLibraryPaths <extension> <names>
#
# Generates a library path(s), rooted in the host results directory,
# by concatenating a predefined library prefix, the specified name(s)
# and the specified library extension.

GenerateHostLibraryPaths                = $(call GenerateHostResultPaths,,$(call GenerateLibraryNames,$(1),$(2)))

# GenerateTargetLibraryPaths <extension> <names>
#
# Generates a library path(s), rooted in the target results directory,
# by concatenating a predefined library prefix, the specified name(s)
# and the specified library extension.

GenerateTargetLibraryPaths              = $(call GenerateTargetResultPaths,,$(call GenerateLibraryNames,$(1),$(2)))

# GenerateLibraryPaths <extension> <names>
#
# Generates a library path(s), rooted in the default (that is, host or
# target, building on the value of BuildHostSpecialized) results
# directory, by concatenating a predefined library prefix, the
# specified name(s) and the specified library extension.

GenerateLibraryPaths                    = $(call GenerateResultPaths,,$(call GenerateLibraryNames,$(1),$(2)))

##
## Archive Libraries
##
## Archives of executable code and data that are linked once per
## program, resulting in both compile- and run-time duplication of
## both code and data.
##

# GenerateHostArchiveLibraryPaths <extension> <names>
#
# Generates an archive library path(s), rooted in the current
# (i.e. the directory in which this invoked) host results directory,
# by concatenating a predefined library prefix, the specified name(s)
# and the defined archive library extension.

GenerateHostArchiveLibraryPaths         = $(call GenerateHostResultPaths,,$(call GenerateArchiveLibraryNames,$(1)))

# GenerateTargetArchiveLibraryPaths <extension> <names>
#
# Generates an archive library path(s), rooted in the current
# (i.e. the directory in which this invoked) target results directory,
# by concatenating a predefined library prefix, the specified name(s)
# and the defined archive library extension.

GenerateTargetArchiveLibraryPaths       = $(call GenerateTargetResultPaths,,$(call GenerateArchiveLibraryNames,$(1)))

# GenerateArchiveLibraryPaths <extension> <names>
#
# Generates an archive library path(s), rooted in the current
# (i.e. the directory in which this invoked) default (that is, host or
# target, building on the value of BuildHostSpecialized) results
# directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined archive library extension.

GenerateArchiveLibraryPaths             = $(call GenerateResultPaths,,$(call GenerateArchiveLibraryNames,$(1)))

# GenerateHostArchiveLibraryResultPaths <subdirectory> <names>
#
# Generates an archive library path(s), rooted in the specified host
# results directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined archive library extension.

GenerateHostArchiveLibraryResultPaths   = $(call GenerateHostResultPaths,$(1),$(call GenerateArchiveLibraryNames,$(2)))

# GenerateTargetArchiveLibraryResultPaths <subdirectory> <names>
#
# Generates an archive library path(s), rooted in the specified target
# results directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined archive library extension.

GenerateTargetArchiveLibraryResultPaths = $(call GenerateTargetResultPaths,$(1),$(call GenerateArchiveLibraryNames,$(2)))

# GenerateArchiveLibraryResultPaths <subdirectory> <names>
#
# Generates an archive library path(s), rooted in the specified
# default (that is, host or target, building on the value of
# BuildHostSpecialized) results directory, by concatenating a
# predefined library prefix, the specified name(s) and the defined
# archive library extension.

GenerateArchiveLibraryResultPaths       = $(call GenerateResultPaths,$(1),$(call GenerateArchiveLibraryNames,$(2)))

##
## Shared Libraries
##
## Shared executable code and data that can be concurrently used by
## multiple running programs.
##

# GenerateHostSharedLibraryPaths <extension> <names>
#
# Generates a shared library path(s), rooted in the current (i.e. the
# directory in which this invoked) host results directory, by
# concatenating a predefined library prefix, the specified name(s) and
# the defined shared library extension.

GenerateHostSharedLibraryPaths          = $(call GenerateHostResultPaths,,$(call GenerateSharedLibraryNames,$(1)))

# GenerateTargetSharedLibraryPaths <extension> <names>
#
# Generates a shared library path(s), rooted in the current (i.e. the
# directory in which this invoked) target results directory, by
# concatenating a predefined library prefix, the specified name(s) and
# the defined shared library extension.

GenerateTargetSharedLibraryPaths        = $(call GenerateTargetResultPaths,,$(call GenerateSharedLibraryNames,$(1)))

# GenerateSharedLibraryPaths <extension> <names>
#
# Generates a shared library path(s), rooted in the current (i.e. the
# directory in which this invoked) default (that is, host or target,
# building on the value of BuildHostSpecialized) results directory, by
# concatenating a predefined library prefix, the specified name(s) and
# the defined shared library extension.

GenerateSharedLibraryPaths              = $(call GenerateResultPaths,,$(call GenerateSharedLibraryNames,$(1)))

# GenerateHostSharedLibraryResultPaths <subdirectory> <names>
#
# Generates a shared library path(s), rooted in the specified host
# results directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined shared library extension.

GenerateHostSharedLibraryResultPaths    = $(call GenerateHostResultPaths,$(1),$(call GenerateSharedLibraryNames,$(2)))

# GenerateTargetSharedLibraryResultPaths <subdirectory> <names>
#
# Generates a shared library path(s), rooted in the specified target
# results directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined shared library extension.

GenerateTargetSharedLibraryResultPaths  = $(call GenerateTargetResultPaths,$(1),$(call GenerateSharedLibraryNames,$(2)))

# GenerateSharedLibraryResultPaths <subdirectory> <names>
#
# Generates a shared library path(s), rooted in the specified default
# (that is, host or target, building on the value of
# BuildHostSpecialized) results directory, by concatenating a
# predefined library prefix, the specified name(s) and the defined
# shared library extension.

GenerateSharedLibraryResultPaths        = $(call GenerateResultPaths,$(1),$(call GenerateSharedLibraryNames,$(2)))

##
## Programs
##
## Standalone executables.
##

# GenerateProgramNames <paths>
#
# Generates a program name(s) by concatenating a predefined program
# prefix, the specified name(s) and a predefined program suffix.

GenerateProgramNames                    = $(addsuffix $(ProgramSuffix),$(addprefix $(ProgramPrefix),$(1)))

# GenerateHostProgramPaths <paths>
#
# Generates a program name, rooted in the host results directory, by
# concatenating a predefined program prefix, the specified name(s) and
# a predefined program suffix.

GenerateHostProgramPaths                = $(call GenerateHostResultPaths,,$(call GenerateProgramNames,$(1)))

# GenerateTargetProgramPaths <paths>
#
# Generates a program name, rooted in the target results directory, by
# concatenating a predefined program prefix, the specified name(s) and
# a predefined program suffix.

GenerateTargetProgramPaths              = $(call GenerateTargetResultPaths,,$(call GenerateProgramNames,$(1)))

# GenerateProgramPaths <paths>
#
# Generates a program name, rooted in the default (that is, host or
# target, building on the value of BuildHostSpecialized) results
# directory, by concatenating a predefined program prefix, the
# specified name(s) and a predefined program suffix.

GenerateProgramPaths                    = $(call GenerateResultPaths,,$(call GenerateProgramNames,$(1)))

##
## Images
##
## "Bare metal" or other executables that typically function outside
## of a standard C or C++ runtime environment that may lack a 'main'
## entry point. These are commonly used on embedded targets without an
## operating system or for bootloaders and operating system kernels
## themselves.
##

# GenerateImageNames <paths>
#
# Generates an image name(s) by concatenating a predefined program
# prefix, the specified name(s) and a predefined image suffix.

GenerateImageNames                      = $(addsuffix $(ImageSuffix),$(addprefix $(ImagePrefix),$(1)))
GenerateImageMapNames                   = $(addsuffix $(ImageMapSuffix),$(addprefix $(ImagePrefix),$(1)))
GenerateImageBinNames                   = $(addsuffix $(ImageBinSuffix),$(addprefix $(ImagePrefix),$(1)))
GenerateImageSrecNames                  = $(addsuffix $(ImageSrecSuffix),$(addprefix $(ImagePrefix),$(1)))

# GenerateImagePaths <paths>
#
# Generates an image name, rooted in the default (that is, host or
# target, building on the value of BuildHostSpecialized) results
# directory, by concatenating a predefined image prefix, the specified
# name(s) and a predefined image suffix.

GenerateImagePaths                      = $(call GenerateResultPaths,,$(call GenerateImageNames,$(1)))
GenerateImageMapPaths                   = $(call GenerateResultPaths,,$(call GenerateImageMapNames,$(1)))
GenerateImageBinPaths                   = $(call GenerateResultPaths,,$(call GenerateImageBinNames,$(1)))
GenerateImageSrecPaths                  = $(call GenerateResultPaths,,$(call GenerateImageSrecNames,$(1)))

##
## Generations
##
## Related to build generartion file names, files used to indicate the
## current generation number of a program, image, archive or library
## build.
##

#
# GenerateGenerationNames <prefixes>
#
# Scope: Private
#
# Generates build generation file names, files used to indicate the
# current generation number of a program, image, archive or library
# build.

GenerationNameSuffix                    = -generation
GenerateGenerationNames                 = $(addsuffix $(GenerationNameSuffix),$(call GenerateHiddenNames,$(1)))

#
# GenerateHostGenerationPaths <prefixes>
#
# Scope: Private
#
# Generates build generation host build paths, paths used to indicate
# the current generation number of a program, image, archive or
# library build.

GenerateHostGenerationPaths             = $(call GenerateHostBuildPaths,$(call GenerateGenerationNames,$(1)))

#
# GenerateTargetGenerationPaths <prefixes>
#
# Scope: Private
#
# Generates build generation target build paths, paths used to
# indicate the current generation number of a program, image, archive
# or library build.

GenerateTargetGenerationPaths           = $(call GenerateTargetBuildPaths,$(call GenerateGenerationNames,$(1)))

#
# GenerateGenerationPaths <prefixes>
#
# Scope: Private
#
# Generates build generation default (that is, host or target,
# building on the value of BuildHostSpecialized) build paths, paths
# used to indicate the current generation number of a program, image,
# archive or library build.

GenerateGenerationPaths                 = $(call GenerateBuildPaths,$(call GenerateGenerationNames,$(1)))
