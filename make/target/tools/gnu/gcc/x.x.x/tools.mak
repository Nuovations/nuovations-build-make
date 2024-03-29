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
#      This file defines the access paths and basic flags for the GNU
#      Compiler Collection (GCC), any version.
#

ToolRoot            = /usr
ToolPrefix          = $(CROSS_COMPILE)

# We'll accept any x.x or x.x.x version of GCC with any build cruft
# trailing behind the version number.

GccVersRegExp       = ([[:digit:]]{1,}\.*){2,3}
GccBuildRegExp      = .+

# We'll accept any version of binutils with any build cruft trailing
# behind the version number.

BinutilsVersRegExp  = [[:digit:]]{1,}\.([[:digit:]]{1,}[-.]*){1,}
BinutilsBuildRegExp = .*

GccBinDir           = $(ToolRoot)/bin
GccIncDir           = $(ToolRoot)/include
GccLibDir           = $(ToolRoot)/lib

ToolBinDir          = $(GccBinDir)
ToolIncDir          = $(GccIncDir)
ToolLibDir          = $(GccLibDir)

# Include the GCC common definitions.

include target/tools/$(ToolVendor)/$(ToolProduct)/tools.mak
