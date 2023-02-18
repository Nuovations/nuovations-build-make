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
#      This file defines the access paths and basic flags for the
#      Mentor Graphics (formerly CodeSourcery) Sourcery CodeBench
#      2011.03-65.
#

ToolRoot		= /usr/local/CodeSourcery/Sourcery_CodeBench/2011.03-65

# Sourcery CodeBench uses GNU tools for its tool chain, so specify the
# expected version and build patterns in terms of those variables.

GccVersRegExp		= 4\.5\.2
GccBuildRegExp		= 2011\.03-65

BinutilsVersRegExp	= 2\.20\.51\.20100809
BinutilsBuildRegExp	= 2011\.03-65

SourceryGxxArchDir	= $(patsubst %-,%,$(CROSS_COMPILE))
SourceryGxxBinDir	= $(ToolRoot)/bin
SourceryGxxIncDir	= $(ToolRoot)/$(SourceryGxxArchDir)/libc/usr/include
SourceryGxxLibDir	= $(ToolRoot)/$(SourceryGxxArchDir)/libc/usr/lib

ToolBinDir		= $(SourceryGxxBinDir)
ToolIncDir		= $(SourceryGxxIncDir)
ToolLibDir		= $(SourceryGxxLibDir)

# Include the Sourcery CodeBench common definitions

include target/tools/$(ToolVendor)/$(ToolProduct)/tools.mak
