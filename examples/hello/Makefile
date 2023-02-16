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
#      This file is a make file for a simple, toy program and set of
#      libraries that are primarily intended for basic build and target
#      system sanity checking as well as for demonstrating the basic
#      structure and capabilities of a build system make file.
#

include pre.mak

SubMakefiles		      = \
    lib/Makefile                \
    $(Null)

TransformCAsCPlusPlus	     := Yes
LinkAgainstCPlusPlus	     := Yes

PROGRAMS		     := hello

HelloLibBuildDir	     := lib
HelloLibResultsDir	     := hello/lib
HelloLibIncludeDir	     := include

AlphabetBuildDir 	      =
AlphabetName		      = alphabet
AlphabetBuildPath	      = $(HelloLibBuildDir)
AlphabetResultsDir	      = $(HelloLibResultsDir)
AlphabetIncludePath	      = $(HelloLibIncludeDir)
AlphabetLibraryPath	      = $(AlphabetBuildPath)/$(AlphabetName)
AlphabetDependPath	      = $(call GenerateStaticLibraryResultPaths,$(AlphabetResultsDir)/$(AlphabetBuildDir),$(AlphabetName))

HelloBuildDir 		      =
HelloName		      = hello
HelloBuildPath		      = $(HelloLibBuildDir)
HelloResultsDir		      = $(HelloLibResultsDir)
HelloIncludePath	      = $(HelloLibIncludeDir)
HelloLibraryPath	      = $(HelloBuildPath)/$(HelloName)
HelloDependPath		      = $(call GenerateSharedLibraryResultPaths,$(HelloResultsDir)/$(HelloBuildDir),$(HelloName))

GoodbyeBuildDir 	      =
GoodbyeName		      = goodbye
GoodbyeBuildPath	      = $(HelloLibBuildDir)
GoodbyeResultsDir	      = $(HelloLibResultsDir)
GoodbyeIncludePath	      = $(HelloLibIncludeDir)
GoodbyeLibraryPath	      = $(GoodbyeBuildPath)/$(GoodbyeName)
GoodbyeDependPath	      = $(call GenerateSharedLibraryResultPaths,$(GoodbyeResultsDir)/$(GoodbyeBuildDir),$(GoodbyeName))

SalutationsBuildDir 	      =
SalutationsName		      = salutations
SalutationsBuildPath	      = $(HelloLibBuildDir)
SalutationsResultsDir	      = $(HelloLibResultsDir)
SalutationsIncludePath	      = $(HelloLibIncludeDir)
SalutationsLibraryPath	      = $(SalutationsBuildPath)/$(SalutationsName)
SalutationsDependPath	      = $(call GenerateSharedLibraryResultPaths,$(SalutationsResultsDir)/$(SalutationsBuildDir),$(SalutationsName))

hello_SOURCES		      = \
    main.c                      \
    $(Null)

hello_INCLUDES		      = \
    include                     \
    $(Null)

hello_LDLIBS		      = \
    $(HelloLibraryPath)         \
    $(GoodbyeLibraryPath)       \
    $(AlphabetLibraryPath)      \
    $(SalutationsLibraryPath)   \
    $(Null)

hello_DEPLIBS		      = \
    $(HelloDependPath)          \
    $(GoodbyeDependPath)        \
    $(AlphabetDependPath)       \
    $(SalutationsDependPath)    \
    $(Null)

# Let make know that the DEPLIBS have a prerequisite in lib/Makefile.

$(hello_DEPLIBS): lib/Makefile

include post.mak
