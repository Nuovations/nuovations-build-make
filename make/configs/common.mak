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
#      This file defines common options for the all build
#      configurations.
#

WARNINGS                                                    = \
    $(call ToolAssertWarningFlag,$(WarnEnable))		      \
    $(call ToolAssertWarningFlag,$(WarnAll))		      \
    $(call ToolAssertWarningFlag,$(WarnCharIndices))	      \
    $(call ToolAssertWarningFlag,$(WarnFormatStrings))	      \
    $(call ToolAssertWarningFlag,$(WarnParentheses))	      \
    $(call ToolAssertWarningFlag,$(WarnReturnType))	      \
    $(call ToolAssertWarningFlag,$(WarnSequencePoint))	      \
    $(call ToolAssertWarningFlag,$(WarnShadow))		      \
    $(call ToolAssertWarningFlag,$(WarnUninitialized))	      \
    $(call ToolAssertWarningFlag,$(WarnTypeLimits))	      \
    $(call ToolAssertWarningFlag,$(WarnUnused))               \
    $(Null)

CCWARNINGS                                                  = \
    $(WARNINGS)			                              \
    $(call ToolAssertWarningFlag,$(WarnImplicitDeclarations)) \
    $(call ToolAssertWarningFlag,$(WarnStrictProtos))	      \
    $(call ToolAssertWarningFlag,$(WarnMissingProtos))        \
    $(Null)

CXXWARNINGS                                                 = \
    $(WARNINGS)                                               \
    $(Null)

DEFINES += \
	BUILD_CONFIG=\"$(BuildConfig)\" \
	BUILD_CONFIG_$(call ToUpper,$(BuildConfig)) \
	BUILD_PRODUCT=\"$(BuildProduct)\" \
	BUILD_PRODUCT_$(call ToUpper,$(BuildProduct)) \

#
#  Include toolchain-specific settings.
#

-include configs/$(ToolVendor)-$(ToolProduct)-$(ToolVersion).mak
