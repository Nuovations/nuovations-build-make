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
#      This file is the make header for all common
#      (i.e. non-toolchain-specific) tools used in the project.
#

# Source the make header for the host (non-toolchain) tools

include host/tools.mak

# Before we can source the correct make header for the desired target
# or host tool chain, we need to ensure that the correct target and
# host tool chain tuple variables are set.

$(call ErrorIfUndefined,HostToolVendor)
$(call ErrorIfUndefined,HostToolProduct)
$(call ErrorIfUndefined,HostToolVersion)

$(call ErrorIfUndefined,TargetToolVendor)
$(call ErrorIfUndefined,TargetToolProduct)
$(call ErrorIfUndefined,TargetToolVersion)

MakeToolTuple         = $(1)/$(2)/$(3)

HostToolTuple         = $(call MakeToolTuple,$(HostToolVendor),$(HostToolProduct),$(HostToolVersion))
TargetToolTuple       = $(call MakeToolTuple,$(TargetToolVendor),$(TargetToolProduct),$(TargetToolVersion))

# Everything from here forward defaults to using Tool*, if it is a
# variable or function not qualified with "Host" or "Target". Default
# to the target definitions for the tool tuple values.

ToolVendor            = $(TargetToolVendor)
ToolProduct           = $(TargetToolProduct)
ToolVersion           = $(TargetToolVersion)

ToolTuple             = $(call MakeToolTuple,$(ToolVendor),$(ToolProduct),$(ToolVersion))

MakeToolNameFromTuple = $(join $(notdir $(1))," $(2)")

MakeHostToolName      = $(call MakeToolNameFromTuple,$(1),$(HostToolTuple))
MakeTargetToolName    = $(call MakeToolNameFromTuple,$(1),$(TargetToolTuple))
MakeToolName          = $(call MakeToolNameFromTuple,$(1),$(ToolTuple))

# Source the make header for the target tools specified by the current
# ToolTuple.

include target/tools/$(ToolTuple)/tools.mak

#
# Macros for checking make version
#
# At this point, we'll happily accept 3.81, 3.82, or releases of 4.0
# or later.
#

MAKESedVers           = [[:digit:]]\{1,\}\.[[:digit:]]\{1,\}
MAKESedRegExp         = ^.*\(GNU Make $(MAKESedVers)\).*$
MAKESedCommand        = "s/$(MAKESedRegExp)/\1/gp"
MAKESedArgs           = $(MAKESedCommand)

MAKEGrepRegExp        = ^.*\(GNU Make \(3\.8[12]\|4.[[:digit:]]*\)\).*$
MAKEGrepPattern       = "$(MAKEGrepRegExp)"
MAKEGrepArgs          = $(MAKEGrepPattern)
