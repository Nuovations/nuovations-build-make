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
#      This is the example product-specific makefile for and using the
#      Nuovations Build (Make) build system.
#

#
# The target operating system is simply the host operating system.
#
TargetOS                = $(HostOS)

#
# The canonical target architecture, vendor and operating system
# tuple. It is simply the host tuple.
#
TargetTuple             = $(HostTuple)

#
# The tool vendor, chain and version to use
#
# Default to any version of Apple LLVM/clang on Darwin and GNU GCC on
# any other host build system. Apple has a GCC front end for LLVM/clang;
# however, it reports versions as clang does, so this still requires
# some customization for Darwin.
#

ifeq ($(HostOS),darwin)
_DefaultToolVendor      = apple
_DefaultToolProduct     = clang
else
_DefaultToolVendor      = gnu
_DefaultToolProduct     = gcc
endif # HostOS
_DefaultToolVersion     = x.x.x

HostToolVendor          = $(_DefaultToolVendor)
HostToolProduct         = $(_DefaultToolProduct)
HostToolVersion         = $(_DefaultToolVersion)

TargetToolVendor        = $(_DefaultToolVendor)
TargetToolProduct       = $(_DefaultToolProduct)
TargetToolVersion       = $(_DefaultToolVersion)

#
# Processor- and architecture-specific machine and language flags.
#
MACHFLAGS               += $(Null)
LANGFLAGS               += $(Null)

CPPOPTFLAGS             += $(MACHFLAGS)

CCLANGSTDFLAGS          += $(call ToolAssertLanguageStandardFlag,$(LangStandardC2011))
CXXLANGSTDFLAGS         += $(call ToolAssertLanguageStandardFlag,$(LangStandardCxx2014))

CCOPTIMIZER              = $(OPTIMIZER)

CCOPTFLAGS              += $(CCLANGSTDFLAGS) $(CCLANGFLAGS) $(LANGFLAGS)

CXXOPTIMIZER             = $(OPTIMIZER)

CXXOPTFLAGS             += $(CXXLANGSTDFLAGS) $(CXXLANGFLAGS) $(LANGFLAGS)

LDFLAGS                 += $(Null)

#
# The product- or project-specific top-level makefile to which make
# goals will be dispatched for this product and all of its
# configurations.
#
BuildProductTopMakefile := $(BuildRoot)/Examples.mak

