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
#      This file defines the access paths and basic flags for the Denx
#      Software Engineering Embedded Linux Development Kit (ELDK) v4.2.
#

ToolRoot		= /usr/local/eldk/4.2

# The ELDK v4.2 uses GNU tools for its tool chain, so specify the
# expected version and build patterns in terms of those variables.

GccVersRegExp		= 4\.2\.2
GccBuildRegExp		=

# For the GNU binutils portion of ELDK 4.2, the version and build
# information are variable among different architectures (e.g. PPC 4xx
# vs. ARM). Consequently, we need to be a little more flexible in
# specifying our version match.

BinutilsVersRegExp	= \(2\.17\.50\.0\.12\|2\.17\.90\.20070806\)
BinutilsBuildRegExp	= 20070128

EldkArchDir		= $(patsubst %-,%,$(CROSS_COMPILE))
EldkBinDir		= $(ToolRoot)/usr/bin
EldkIncDir		= $(ToolRoot)/$(EldkArchDir)/usr/include
EldkLibDir		= $(ToolRoot)/$(EldkArchDir)/lib

ToolBinDir		= $(EldkBinDir)
ToolIncDir		= $(EldkIncDir)
ToolLibDir		= $(EldkLibDir)

# Include the ELDK common definitions

include target/tools/$(ToolVendor)/$(ToolProduct)/tools.mak
