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
#      This file is the top-level makefile for any project integrating
#      the Nuovations Build (Make) build system.
#
#      Typically, a project integration Nuovations Build (Make) will
#      create a symbolic link from this file to 'Makefile' at the top
#      of their project tree.
#

include pre/macros.mak

# Attempting to set BuildConfig or BuildProduct externally from this
# make file is an error. Let the user know about it if they've tried
# to do this.

ErrorIfDefined                  = $(if $(value $(1)),$(call error,The make variable "$(1)" may not be defined at the top of the project. Please run 'make help' for more information),)

$(call ErrorIfDefined,BuildConfig)
$(call ErrorIfDefined,BuildProduct)

# This is the top-level make file that will actually build the tree
# and to which the build is dispatched from here.

BuildMakefile                   = $(BuildRoot)/third_party/nuovations-build-make/repo/make/layout.mak

# This is the list of products that are supported for top-level builds
# in this tree.

AllProductMakefilesWithPath     = $(sort $(wildcard build/make/products/*.mak))
AllProductMakefilesWithPath     += $(sort $(wildcard $(BuildRoot)/third_party/nuovations-build-make/repo/make/products/*.mak))
AllProductMakefiles             = $(filter-out common.mak,$(sort $(notdir $(AllProductMakefilesWithPath))))
BuildProducts                   = $(basename $(AllProductMakefiles))

# This is the list of configurations that are supported for top-level builds
# in this tree.

AllConfigMakefilesWithPath      = $(sort $(wildcard build/make/configs/*.mak))
AllConfigMakefilesWithPath      += $(sort $(wildcard $(BuildRoot)/third_party/nuovations-build-make/repo/make/configs/*.mak))
AllConfigMakefiles              = $(filter-out common.mak,$(sort $(notdir $(AllConfigMakefilesWithPath))))
BuildConfigs                    = $(basename $(AllConfigMakefiles))

# This is the concatenator used for building make targets, the general
# form of which is <product><concatenator><configuration>, with some
# additional targets for specific tree actions, such as
# sanity-checking or cleaning a target. These special-case targets
# have the form of <action><concatenator><product>[<concatenator>
# <configuration>], where the configuration piece is optional since it
# is not necessarily used for all configurations.

TargetConcatenator              = -

AddTargetPrefix                 = $(addprefix $(1)$(TargetConcatenator),$(2))
AddTargetSuffix                 = $(addsuffix $(TargetConcatenator)$(1),$(2))
AddTargetInfix                  = $(call AddTargetSuffix,$(lastword $(call SplitTarget,$(1))),$(call AddTargetPrefix,$(firstword $(call SplitTarget,$(1))),$(2)))
RemoveTargetPrefix              = $(subst $(1)$(TargetConcatenator),,$(2))
RemoveTargetSuffix              = $(subst $(TargetConcatenator)$(1),,$(2))

# These are the completely-specified product configurations based on
# the lists of products and configurations.

ProductConfigs                  = $(foreach BuildConfig,$(BuildConfigs),$(call AddTargetSuffix,$(BuildConfig),$(BuildProducts)))

# These are the special-case build actions supported by this tree.

BuildActions                    = $(AllBuildAction)       \
                                  $(CheckBuildAction)     \
                                  $(CleanBuildAction)     \
                                  $(DistCleanBuildAction) \
                                  $(PrepareBuildAction)   \
                                  $(PrettyBuildAction)    \
                                  $(LintBuildAction)

#
# All-related variables
#
# All targets are for building the entirety of the software in the
# project tree for a particular product, configuration or combination
# thereof.
#
# The all build action is implicit, so specifying 'make
# product-configuration' is the same as specifying 'make
# all-product-configuration'.

AllBuildAction                  = all

GenerateAllBuildTarget          = $(call AddTargetPrefix,$(AllBuildAction),$(1))

AllBuildProducts                = $(call GenerateAllBuildTarget,$(BuildProducts))
AllBuildConfigs                 = $(call GenerateAllBuildTarget,$(BuildConfigs))
AllProductConfigs               = $(call GenerateAllBuildTarget,$(ProductConfigs))

#
# Check-related variables
#
# Check targets are for validating the sanity of the build environment
# and tool chain selected for a particular product, configuration or
# combination thereof.
#

CheckBuildAction                = check

GenerateCheckBuildTarget        = $(call AddTargetPrefix,$(CheckBuildAction),$(1))

CheckBuildProducts              = $(call GenerateCheckBuildTarget,$(BuildProducts))
CheckBuildConfigs               = $(call GenerateCheckBuildTarget,$(BuildConfigs))
CheckProductConfigs             = $(call GenerateCheckBuildTarget,$(ProductConfigs))

#
# Prepare-related variables
#
# Prepare targets is meant to do a depth first pass before 'all'
#

PrepareBuildAction              = prepare

GeneratePrepareBuildTarget      = $(call AddTargetPrefix,$(PrepareBuildAction),$(1))

PrepareBuildProducts            = $(call GeneratePrepareBuildTarget,$(BuildProducts))
PrepareBuildConfigs             = $(call GeneratePrepareBuildTarget,$(BuildConfigs))
PrepareProductConfigs           = $(call GeneratePrepareBuildTarget,$(ProductConfigs))

#
# Clean-related variables
#
# Clean targets are for cleaning up and restoring to a clean state the
# build tree for a particular product, configuration or combination
# thereof.
#

CleanBuildAction                = clean

GenerateCleanBuildTarget        = $(call AddTargetPrefix,$(CleanBuildAction),$(1))

CleanBuildProducts              = $(call GenerateCleanBuildTarget,$(BuildProducts))
CleanBuildConfigs               = $(call GenerateCleanBuildTarget,$(BuildConfigs))
CleanProductConfigs             = $(call GenerateCleanBuildTarget,$(ProductConfigs))

#
# DistClean-related variables
#
# DistClean targets are for cleaning up and restoring to a clean state the
# build tree for a particular product, configuration or combination
# thereof.  Removes product+config specific .build, .depend, and result
# directories.
#

DistCleanBuildAction            = distclean

GenerateDistCleanBuildTarget    = $(call AddTargetPrefix,$(DistCleanBuildAction),$(1))

DistCleanBuildProducts          = $(call GenerateDistCleanBuildTarget,$(BuildProducts))
DistCleanBuildConfigs           = $(call GenerateDistCleanBuildTarget,$(BuildConfigs))
DistCleanProductConfigs         = $(call GenerateDistCleanBuildTarget,$(ProductConfigs))

#
# Pretty-related variables
#
# Pretty targets are for reformatting the source files of the build
# tree according to project-specific style settings for a particular
# product, configuration or combination thereof.
#

PrettyBuildAction               = pretty

GeneratePrettyBuildTarget       = $(call AddTargetPrefix,$(PrettyBuildAction),$(1))

PrettyBuildProducts             = $(call GeneratePrettyBuildTarget,$(BuildProducts))
PrettyBuildConfigs              = $(call GeneratePrettyBuildTarget,$(BuildConfigs))
PrettyProductConfigs            = $(call GeneratePrettyBuildTarget,$(ProductConfigs))

#
# Lint-related variables
#
# Lint (aka pretty-check) targets are for checking source files of the build
# tree according to project-specific style settings for a particular
# product, configuration or combination thereof.
#

LintBuildAction                 = lint

GenerateLintBuildTarget         = $(call AddTargetPrefix,$(LintBuildAction),$(1))

LintBuildProducts               = $(call GenerateLintBuildTarget,$(BuildProducts))
LintBuildConfigs                = $(call GenerateLintBuildTarget,$(BuildConfigs))
LintProductConfigs              = $(call GenerateLintBuildTarget,$(ProductConfigs))

#
# Other Support Functions
#

# SetMakeVars
#
# This sets a list of specified make variables to their analogous
# counterpart in a second list.

SetMakeVars                     = $(join $(addsuffix =,$(1)),$(2))

# SplitTarget
#
# This breaks the specified build target apart into white-space
# separated words.

SplitTarget                     = $(subst $(TargetConcatenator), ,$(1))

# SplitAndFilterTarget
#
# This breaks the specified build target apart into white-space
# separated words and filters out the specified word, if it exists,
# from the list.

SplitAndFilterTarget            = $(filter-out $(1),$(call SplitTarget,$(2)))

# WordFromTarget <target>
#
# This extracts the specified work from the specified concatenated target.

WordFromTarget                  = $(word $(2),$(call SplitTarget,$(1)))

# ActionFromTarget <target>
#
# This extracts the build action from the specified concatenated target.

ActionFromTarget                = $(call WordFromTarget,$(1),1)

# ConfigurationFromTarget <target>
#
# This extracts the build configuration from the specified concatenated target.

ConfigurationFromTarget         = $(call WordFromTarget,$(1),3)

# ProductFromTarget <target>
#
# This extracts the build product from the specified concatenated target.

ProductFromTarget               = $(call WordFromTarget,$(1),2)

# SetBuildVarsFromList
#
# This sets the build variables from by choosing two words from a list
# of words.

SetBuildVarsFromList            = $(call SetBuildVars,$(word $(1),$(3)) $(word $(2),$(3)))

# SetBuildVars
#
# This sets two specific build variables to the specified list of values.

SetBuildVars                    = $(call SetMakeVars,BuildProduct BuildConfig,$(1))

# SetBuildVarsFromFilteredTarget
#
# This takes target, splits it into a white-space separated list of
# words, filters out a specific word and then sets build variables
# from the first (1) and second (2) words in the resulting list.

SetBuildVarsFromFilteredTarget  = $(call SetBuildVarsFromList,1,2,$(call SplitAndFilterTarget,$(1),$(2)))

#
# Functions for printing out pro- and postlogue banners when
# dispatching action targets.
#

BannerSingleBorder      = --------------------------------------------------------------------------------
BannerDoubleBorder      = ================================================================================

BannerDateStamp         = $(shell date '+%F %T %Z')

# prologue-banner <target>
#
# Displays to standard output a banner including the current time of
# day and which action, product and configuration are being made.

define prologue-banner
$(Echo) "$(BannerSingleBorder)"
$(Echo) "$(call BannerDateStamp): Making '$(call ActionFromTarget,$(1))' for '$(call ConfigurationFromTarget,$(1))' configuration of '$(call ProductFromTarget,$(1))'"
$(Echo) "$(BannerDoubleBorder)"
endef

# prologue-banner <target>
#
# Displays to standard output a banner including the current time of
# day and a done message.

define postlogue-banner
$(Echo) "$(BannerDoubleBorder)"
$(Echo) "$(call BannerDateStamp): done."
endef

#
# Functions for dispatching a build action
#
GenerateMakeArgs                = -f $(BuildMakefile) $(call SetBuildVarsFromFilteredTarget,$(1),$(2))

# DispatchBuildAction <target> <local action> <project action>
#
# Displays to standard output a prologue indicating the build action
# requested, checks the sanity of the tools for this build
# configuration and then dispatches the requested action to the
# top-level project make file and then displays to standard output a
# completion postlogue.
#
# The local action is the target action for this make file. The
# project action is the target action dispatched to the top-level
# project make file and may be empty.

define DispatchBuildAction
$(call prologue-banner,$(1))
+$(Verbose)$(MAKE) $(call GenerateMakeArgs,$(2),$(1)) $(3)
$(call postlogue-banner,$(1))
endef

# DispatchPrepareAction <target> <local action> <project action>
#
# For prepare only
#

define DispatchPrepareAction
+$(Verbose)$(MAKE) $(call GenerateMakeArgs,$(2),$(1)) $(3)
endef

#
# Explicit Targets
#

#
# Build Action Targets
#

#
# All Action Targets
#

# Generate all configurations for all products.
#
# As noted above, the all build action is implicit, so specifying
# 'make product-configuration' is the same as specifying 'make
# all-product-configuration'.

.PHONY: $(AllBuildAction)
$(AllBuildAction): $(AllBuildProducts)

# Generate all action for all product configutions.
#
# Here, we leverage GNU make secondary expansion so that $@ is
# expanded in the prerequisites list. We could have counted on GNU
# make emulation of System V behavior here; however, that's both less
# explicit and less reliable.
#
# Leveraging secondary expansion results in a makefile that is
# ultimately shorter by O(n^1/(x*y)), where 'x' is the number of
# products and 'y' the number of configurations.

.SECONDEXPANSION:
.PHONY: $(AllBuildAction)
$(AllBuildAction): $(AllProductConfigs)

# Generate all action for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(AllBuildProducts)
$(AllBuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate all action for all product configurations.
#
# Note, we don't specify 'all' as the target goal for the sub-make
# files because while 'all' is assumed to be the default goal for all
# make files in the project tree, we simply want to do what is default
# for all make files in the tree, which may or may not actually be
# 'all'.
#
# Here, again, we leverage GNU make secondary expansion

.PHONY: $(AllProductConfigs)
$(AllProductConfigs): $$(call GenerateCheckBuildTarget,$$(call RemoveTargetPrefix,$(AllBuildAction),$$(@)))
	$(call DispatchPrepareAction,$(@),$(AllBuildAction),$(PrepareBuildAction))
	$(call DispatchBuildAction,$(@),$(AllBuildAction),$(AllBuildAction))

# Generate specific configurations for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(BuildConfigs)
$(BuildConfigs): $(call AddTargetSuffix,$$@,$(BuildProducts))

# Generate all configurations for a specific product.
#
# Here, again, we leverage GNU make secondary expansion.

.SECONDEXPANSION:
.PHONY: $(BuildProducts)
$(BuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate all configurations for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(ProductConfigs)
$(ProductConfigs): $(call GenerateAllBuildTarget,$$@)

#
# Check Action Targets
#

# Generate check action for all product configutions.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(CheckBuildAction)
$(CheckBuildAction): $(CheckProductConfigs)

# Generate check action for all product configurations.

.PHONY: $(CheckProductConfigs)
$(CheckProductConfigs):
	$(Verbose)$(MAKE) $(call GenerateMakeArgs,$(CheckBuildAction),$@) check-tools

#
# Clean Action Targets
#

# Generate clean action for all product configutions.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(CleanBuildAction)
$(CleanBuildAction): $(CleanProductConfigs)

# Generate clean action for a specific configuration for all products.
#
# Here, again, we leverage GNU make secondary expansion to make a
# tuple consisting of the clean build action, all products, and the
# configuration associated with the target goal.

.SECONDEXPANSION:
.PHONY: $(CleanBuildConfigs)
$(CleanBuildConfigs): $$(call AddTargetInfix,$$(@),$(BuildProducts))

# Generate clean action for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(CleanBuildProducts)
$(CleanBuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate clean action for all product configurations.

.PHONY: $(CleanProductConfigs)
$(CleanProductConfigs):
	$(call DispatchBuildAction,$(@),$(CleanBuildAction),$(CleanBuildAction))

#
# DistClean Action Targets
#

# Generate distclean action for all product configutions.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(DistCleanBuildAction)
$(DistCleanBuildAction): $(DistCleanProductConfigs)

# Generate distclean action for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(DistCleanBuildProducts)
$(DistCleanBuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate distclean action for all product configurations.
#
# Sets an extra BuildAction variable which can be used
# by product Makefiles to do special dependencies steps
# (e.g. cleaning up all generated breadcrumb files first).

.PHONY: $(DistCleanProductConfigs)
$(DistCleanProductConfigs):
	$(call DispatchBuildAction,$(@),$(DistCleanBuildAction),$(DistCleanBuildAction) BuildAction=$(DistCleanBuildAction))

#
# Pretty Action Targets
#

# Generate pretty action for all product configutions.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(PrettyBuildAction)
$(PrettyBuildAction): $(PrettyProductConfigs)

# Generate pretty action for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(PrettyBuildProducts)
$(PrettyBuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate pretty action for all product configurations.

.PHONY: $(PrettyProductConfigs)
$(PrettyProductConfigs):
	$(call DispatchBuildAction,$(@),$(PrettyBuildAction),$(PrettyBuildAction))

#
# Lint Action Targets
#

# Generate lint action for all product configutions.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(LintBuildAction)
$(LintBuildAction): $(LintProductConfigs)

# Generate lint action for all products.
#
# Here, again, we leverage GNU make secondary expansion

.SECONDEXPANSION:
.PHONY: $(LintBuildProducts)
$(LintBuildProducts): $(call AddTargetPrefix,$$@,$(BuildConfigs))

# Generate lint action for all product configurations.

.PHONY: $(LintProductConfigs)
$(LintProductConfigs):
	$(call DispatchBuildAction,$(@),$(LintBuildAction),$(LintBuildAction))

#
# Help Target
#

define BuildPrintHelp
$(Quiet)echo "This projects supports the following build products:"
$(Quiet)echo
$(Quiet)echo "    $(sort $(BuildProducts))"
$(Quiet)echo
$(Quiet)echo "Generate all build configurations for a specific build product"
$(Quiet)echo "product by specifying the product as the make target. For"
$(Quiet)echo "example:"
$(Quiet)echo
$(Quiet)echo "    % make $(firstword $(BuildProducts))"
$(Quiet)echo
$(Quiet)echo "Specific build configurations supported are:"
$(Quiet)echo
$(Quiet)echo "    $(sort $(BuildConfigs))"
$(Quiet)echo
$(Quiet)echo "These will generate that build configuration for all"
$(Quiet)echo "supported build products. For example:"
$(Quiet)echo
$(Quiet)echo "    % make $(firstword $(BuildConfigs))"
$(Quiet)echo
$(Quiet)echo "Generate a specific build configuration for a specific"
$(Quiet)echo "build product by specifying one of the following as the"
$(Quiet)echo "make target:"
$(Quiet)echo
$(Quiet)echo "    $(sort $(ProductConfigs))"
$(Quiet)echo
$(Quiet)echo "For example:"
$(Quiet)echo
$(Quiet)echo "    % make $(firstword $(ProductConfigs))"
$(Quiet)echo
$(Quiet)echo "The following build actions are supported:"
$(Quiet)echo
$(Quiet)echo "    $(sort $(BuildActions))"
$(Quiet)echo
$(Quiet)echo "Where the '$(AllBuildAction)' is an implicit build action in all of the"
$(Quiet)echo "above examples. For example, to run the '$(CleanBuildAction)' build action"
$(Quiet)echo "for all build products for a specific build configuration:"
$(Quiet)echo
$(Quiet)echo "    % make $(firstword $(CleanBuildConfigs))"
$(Quiet)echo
$(Quiet)echo "Or, for example to run the '$(CleanBuildAction)' build action for a specific"
$(Quiet)echo "build product and build configuration:"
$(Quiet)echo
$(Quiet)echo "    % make $(firstword $(CleanProductConfigs))"
$(Quiet)echo
endef # BuildPrintHelp

.PHONY: help-local
help-local:
	$(call BuildPrintHelp)

#
# Clean all dependencies and intermediate object files generated by nlbuild
# deleting what is contained in nested .build and .depend directories.
# This is different than productconfig specific distclean, which recursively
# calls distclean in submakefiles.  It might be good to run the
# distclean-product-config target first because the local Makefiles might do
# more cleanup (like removing files untarred in build steps) than what this
# rule alone does.  We don't make $(DistCleanProductConfigs) a dependency
# to make this faster and because $(DistCleanProductConfigs) can fail when
# the default manifest is not the right one for all products (e.g. the
# wrong branch could be current and a product specific Makefile could fail
# because it expected a different branch to be mapped for a repo).
#

.PHONY: distcleanall
distcleanall:
	rm -rf ${BuildRoot}/results ; find ${BuildRoot} -depth -type d \( -name ".build" -o -name ".depend" \) -exec rm -rf {} \;

include post/rules/help.mak
include post/rules/print.mak
