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
#      This file defines access paths, environment variables and basic
#      flags for tools common to all Mentor Graphics (formerly
#      CodeSourcery) Sourcery CodeBench versions.
#

#
# Sourcery CodeBench has historically used and probably will continue to use
# GNU tools for its tool chain, so just source the GNU GCC common
# tools.
#

include target/tools/gnu/gcc/tools.mak

#
# However, Sourcery CodeBench is almost exclusively for cross-compiling, so
# override the standard GNU GCC tool names with the cross-compiler
# equivalents.
#

AR			:= $(ToolBinDir)/$(CROSS_COMPILE)ar
AS			:= $(ToolBinDir)/$(CROSS_COMPILE)gcc
CPP			:= $(ToolBinDir)/$(CROSS_COMPILE)cpp
CC			:= $(ToolBinDir)/$(CROSS_COMPILE)gcc
CXX			:= $(ToolBinDir)/$(CROSS_COMPILE)g++
DEPEND			:= $(ToolBinDir)/$(CROSS_COMPILE)cpp
LD			= $(ToolBinDir)/$(CROSS_COMPILE)$(if $(LinkAgainstCPlusPlus),g++,gcc)
NM			:= $(ToolBinDir)/$(CROSS_COMPILE)nm
OBJCOPY			:= $(ToolBinDir)/$(CROSS_COMPILE)objcopy
RANLIB			:= $(ToolBinDir)/$(CROSS_COMPILE)ranlib
STRIP			:= $(ToolBinDir)/$(CROSS_COMPILE)strip

#
# GCC (in most cases) is actually comprised of two separate packages:
# the core GCC and binutils. The versions for these two packages are
# independent and, consequently, must be checked as such.
#

#
# Macros for checking GCC tool versions
#

GccSedTool		= .\{1,\}
GccSedVers		= \([[:digit:]]\{1,\}\.*\)\{3,3\}
GccSedBuild		= .\{1,\}
GccSedRegExp		= ^.*$(GccSedTool) (Sourcery CodeBench \(Lite \)*\($(GccSedBuild)\)) \($(GccSedVers)\)
GccSedCommand		= "s/$(GccSedRegExp)/Sourcery \3 (\2)/gp"
GccSedArgs		= $(GccSedCommand)

GccGrepRegExp		= ^\(Sourcery $(GccVersRegExp) ($(GccBuildRegExp))\)$$
GccGrepPattern		= "$(GccGrepRegExp)"
GccGrepArgs		= $(GccGrepPattern)

#
# Macros for checking binutils tool versions
#

BinutilsSedTool		= \([[:alpha:]]\{1,\} *\)\{1,2\}
BinutilsSedVers		= \([[:digit:]]\{1,\}\.*\)\{2,\}
BinutilsSedBuild	= .\{1,\}
BinutilsSedRegExp	= ^.*GNU $(BinutilsSedTool) (Sourcery CodeBench \(Lite \)*\($(BinutilsSedBuild)\)) \($(BinutilsSedVers)\)

BinutilsSedCommand	= "s/$(BinutilsSedRegExp)/Sourcery \4 (\3)/gp"
BinutilsSedArgs		= $(BinutilsSedCommand)

BinutilsGrepRegExp	= ^\(Sourcery $(BinutilsVersRegExp) ($(BinutilsBuildRegExp))\)$$
BinutilsGrepPattern	= "$(BinutilsGrepRegExp)"
BinutilsGrepArgs	= $(BinutilsGrepPattern)
