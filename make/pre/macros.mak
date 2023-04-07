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

# GenerateUnconditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current unconditional build
# tuple, effectively creating a build tuple-qualified directory name
# that can be used to store build-tuple-specific files.

GenerateUnconditionalBuildQualifiedDirectory            = $(call Deslashify,$(call Slashify,$(1))$(UnconditionalBuildTuple))

# GenerateMakeUnconditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# unconditional build tuple, effectively creating a makefile- and
# build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

GenerateMakeUnconditionalBuildQualifiedDirectory        = $(call Deslashify,$(call Slashify,$(1))$(call Slashify,$(call FirstMakefile))$(UnconditionalBuildTuple))

# GenerateConditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current conditional build
# tuple, effectively creating a build tuple-qualified directory name
# that can be used to store build-tuple-specific files.

GenerateConditionalBuildQualifiedDirectory              = $(call Deslashify,$(call Slashify,$(1))$(ConditionalBuildTuple))

# GenerateMakeConditionalBuildQualifiedDirectory <directory>
#
# Scope: Private
#
# Appends to the specified directory the current makefile name and
# conditional build tuple, effectively creating a makefile- and
# build tuple- qualified directory name that can be used to store
# makefile- and build-tuple-specific files.

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

DependDirectory                         = $(call GenerateMakeConditionalBuildQualifiedDirectory,$(DependBaseDirectory))

# GenerateDependPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the dependency directory,
# from the specified path(s).

GenerateDependPaths                     = $(addprefix $(call Slashify,$(DependDirectory)),$(notdir $(1)))

##
## Intermediate Build Results
##

# Build directories are where intermediate build result files are located.

BuildBaseDirectoryName                 := build
BuildBaseDirectory                     := $(call GenerateHiddenNames,$(BuildBaseDirectoryName))

BuildDirectory                          = $(call GenerateMakeConditionalBuildQualifiedDirectory,$(BuildBaseDirectory))

# GenerateBuildPaths <paths>
#
# Generates the name(s) of a path(s), rooted in the build/object
# directory, from the specified path(s).

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
ResultBuildDirectory                    = $(call GenerateUnconditionalBuildQualifiedDirectory,$(ResultBaseDirectory))

# GenerateResultSubdirectory <subdirectory>
#
# Generates the name of a subdirectory, rooted in the result directory.

GenerateResultSubdirectory              = $(call Deslashify,$(call Slashify,$(ResultBuildDirectory))$(subst $(call Slashify,$(call CanonicalizePath,$(BuildRoot))),,$(1)))

ResultDirectory			= $(call GenerateResultSubdirectory,$(CURDIR))

# GenerateResultPaths <subdirectory> <paths>
#
# Generates the name(s) of a path(s), rooted in the optional specified
# results subdirectory, from the specified path(s). If the subdirectory
# is not specified, the subdirectory is generated from the current
# directory.

GenerateResultPaths		= $(call CanonicalizePath,$(addprefix $(call Slashify,$(call GenerateResultSubdirectory,$(if $(1),$(1),$(BuildCurrentDirectory)))),$(2)))

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

# GenerateBaseDependPaths <paths>
#
# Generates the path(s) of the base (non-post-processed) dependency path(s),
# rooted in the dependency directory, from the specified path(s).

GenerateBaseDependPaths                 = $(call GenerateDependPaths,$(call GenerateBaseDependNames,$(1)))

# GeneratePatchedDependPaths <paths>
#
# Generates the path(s) of the patched (post-processed) dependency path(s),
# rooted in the dependency directory, from the specified path(s).

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

# GenerateObjectPaths <extension> <paths>
#
# Generates an object path(s), rooted in the build/object directory, by
# replacing the existing file extension of the specified path(s) with the
# supplied object extension.

GenerateObjectPaths                     = $(call GenerateBuildPaths,$(notdir $(call GenerateObjectNames,$(1),$(2))))

# GenerateSharedObjectPaths <paths>
#
# Generates a shared object path(s), rooted in the build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined shared object extension.

GenerateSharedObjectPaths               = $(call GenerateBuildPaths,$(notdir $(call GenerateSharedObjectNames,$(1))))

# GenerateStaticObjectPaths <paths>
#
# Generates a static object path(s), rooted in the build/object
# directory, by replacing the existing file extension of the specified
# path(s) with the defined static object extension.

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

# GenerateLibraryPaths <extension> <names>
#
# Generates a library path(s), rooted in the results directory, by
# concatenating a predefined library prefix, the specified name(s) and
# the specified library extension.

GenerateLibraryPaths                    = $(call GenerateResultPaths,,$(call GenerateLibraryNames,$(1),$(2)))

##
## Archive Libraries
##
## Archives of executable code and data that are linked once per
## program, resulting in both compile- and run-time duplication of
## both code and data.
##

# GenerateArchiveLibraryPaths <extension> <names>
#
# Generates an archive library path(s), rooted in the current
# (i.e. the directory in which this invoked) results directory, by
# concatenating a predefined library prefix, the specified name(s) and
# the defined archive library extension.

GenerateArchiveLibraryPaths             = $(call GenerateResultPaths,,$(call GenerateArchiveLibraryNames,$(1)))

# GenerateArchiveLibraryResultPaths <subdirectory> <names>
#
# Generates an archive library path(s), rooted in the specified results
# directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined archive library extension.

GenerateArchiveLibraryResultPaths       = $(call GenerateResultPaths,$(1),$(call GenerateArchiveLibraryNames,$(2)))

##
## Shared Libraries
##
## Shared executable code and data that can be concurrently used by
## multiple running programs.
##

# GenerateSharedLibraryPaths <extension> <names>
#
# Generates a shared library path(s), rooted in the current (i.e. the
# directory in which this invoked) results directory, by concatenating
# a predefined library prefix, the specified name(s) and the defined
# shared library extension.

GenerateSharedLibraryPaths              = $(call GenerateResultPaths,,$(call GenerateSharedLibraryNames,$(1)))

# GenerateSharedLibraryResultPaths <subdirectory> <names>
#
# Generates a shared library path(s), rooted in the specified results
# directory, by concatenating a predefined library prefix, the
# specified name(s) and the defined shared library extension.

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

# GenerateProgramPaths <paths>
#
# Generates a program name, rooted in the results directory, by
# concatenating a predefined program prefix, the specified name(s) and a
# predefined program suffix.

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
# Generates a image name, rooted in the results directory, by
# concatenating a predefined image prefix, the specified name(s) and a
# predefined image suffix.

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
# GenerateGenerationPaths <prefixes>
#
# Scope: Private
#
# Generates build generation build paths, paths used to indicate the
# current generation number of a program, image, archive or library
# build.

GenerateGenerationPaths                 = $(call GenerateBuildPaths,$(call GenerateGenerationNames,$(1)))
