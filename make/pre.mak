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
#      This file is the generic "head" or pre make header included in
#      any makefile used in the build tree.
#

BuildCurrentDirectory           := $(shell /bin/pwd -L)

include pre/host.mak

include pre/macros.mak

$(call ErrorIfUndefined,BuildProduct)

# Determine all potential project-sourced product makefiles.

AllProductMakefilesWithPath      = $(sort $(wildcard $(BuildRoot)/build/make/products/*.mak))

# Find a match for the current build product among those makefiles.

BuildProductMakefile             = $(filter %/$(BuildProduct).mak,$(AllProductMakefilesWithPath))

# Include the match, if any. If no match was found, this will error out.

include $(BuildProductMakefile)

$(call ErrorIfUndefined,BuildConfig)

include configs/$(BuildConfig).mak

# A TargetOS must be defined.

$(call ErrorIfUndefined,TargetOS)

# However, target-specific suffixes may not be.

-include pre/macros/$(TargetOS)/suffixes.mak

include pre/tools.mak

-include pre/macros/$(HostOS)/environment.mak

$(call ErrorIfUndefined,ToolTuple)

# MakeBuildTuple <product> <tool tuple> <configuration>
#
# Scope: Private
#
# Generates a build tuple, suitable for use in path names, that can be
# used to qualify intermediate or final build results. The product and
# configuration may be optionally-specified.

MakeBuildTuple                   = $(if $(1),$(call Slashify,$(1)),)$(if $(3),$(call Slashify,$(2)),$(2))$(if $(3),$(3),)

# UnconditionalHostBuildTuple
#
# Scope: Private
#
# The current host build tuple, qualified by the current build
# product, tool chain and build configuration, suitable for use to
# qualify intermediate or final build results.

UnconditionalHostBuildTuple     := $(call MakeBuildTuple,$(BuildProduct),$(HostToolTuple),$(BuildConfig))

# UnconditionalTargetBuildTuple
#
# Scope: Private
#
# The current target build tuple, qualified by the current build
# product, tool chain and build configuration, suitable for use to
# qualify intermediate or final build results.

UnconditionalTargetBuildTuple   := $(call MakeBuildTuple,$(BuildProduct),$(TargetToolTuple),$(BuildConfig))

# UnconditionalBuildTuple
#
# Scope: Private
#
# The current build tuple, qualified by the current build product,
# tool chain and build configuration, suitable for use to qualify
# intermediate or final build results.

UnconditionalBuildTuple         := $(call MakeBuildTuple,$(BuildProduct),$(ToolTuple),$(BuildConfig))

_BuildConfigSpecializedDefault  := Yes
BuildConfigSpecialized          ?= $(_BuildConfigSpecializedDefault)

_BuildProductSpecializedDefault := Yes
BuildProductSpecialized         ?= $(_BuildProductSpecializedDefault)

# ConditionalBuildTuple
#
# Scope: Private
#
# The current build tuple, qualified with the current tool chain and
# optionally-qualified by the current build product and configuration,
# depending on the value of 'BuildConfigSpecialized' and
# 'BuildProductSpecialized'.  Unlike UnconditionalBuildTuple, we want
# to always evaluate this for each local Makefile in case it specified
# a value for BuildProductSpecialized or BuildConfigSpecialized.

ConditionalBuildTuple           := $(call MakeBuildTuple,$(if $(call IsNo,$(BuildProductSpecialized)),,$(BuildProduct)),$(ToolTuple),$(if $(call IsNo,$(BuildConfigSpecialized)),,$(BuildConfig)))
