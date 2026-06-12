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
#      This file is the make header for all third-party software 
#      targets used in the project.
#

# Default target and dependency for generating the package license file.

.PHONY: license local-license
license: recursive local-license

# Improve overall make iteration performance by only evaluating these
# rules if the package name is defined, which is indicative of a
# "glue" makefile specifically tuned to building a third-party
# package.

ifneq ($(PackageName),)

_touch_stamps         := $(Null)

# The canonical third-party stage pipeline, as a file-to-file
# dependency chain.

$(PackagePatchStamp):     $(PackageSourceStamp)
$(PackageConfigureStamp): $(PackagePatchStamp)
$(PackageBuildStamp):     $(PackageConfigureStamp)
$(PackageStageStamp):     $(PackageBuildStamp)

# For each stage, generate:
#
#   1. The phony convenience target (for example, 'build')
#   2. A default no-op '-local' hook (for example, 'build-local')
#   3. The stamp rule that calls the hook and touches
#
# The glue makefile overrides the '-local' target with real work
# and may add file prerequisites to the stamp via prerequisite-only
# rules.

define _PackageStageRuleTemplate
_touch_stamps         := $$(StampDirectory)/.$(1)-stamp $$(_touch_stamps)
_$(1)_touch_stamps    := $$(_touch_stamps)

.PHONY: $(1)
$(1): $$(StampDirectory)/.$(1)-stamp

$$(StampDirectory)/.$(1)-stamp: | $$(StampDirectory)
	+$$(Verbose)$$(MAKE) -f $$(FirstMakefile) --no-print-directory $(1)-local
	$$(Verbose)touch "$$(@)"

# This might seem a little confusing; however, the convention is
# *-local for "local" hooks implemented by other, site or project
# makefiles foreign to this infrastructure and local-* for targets
# within this infrastructure. Here, local-* prevents "Nothing to be
# done for 'patch-local'" output when the site or project makefiles
# foreign to this infrastructure have no commands for that stage while
# obviating the need for double-colon ('::') rules.

.PHONY: $(1)-local local-$(1)
$(1)-local: local-$(1)

local-$(1):
	$(Verbose):

.PHONY: $(1)-touch
$(1)-touch:
	$$(Verbose)$$(RM) $(RMFLAGS) $$(_$(1)_touch_stamps)
endef # _PackageStageRuleTemplate

# The stage list is iterated in reverse (latest stage first) so that
# the per-stage _<stage>_touch_stamps accumulator builds up correctly.
# Each invocation of _PackageStageRuleTemplate prepends the current
# stage's stamp onto _touch_stamps and snapshots the result into
# _<stage>_touch_stamps:
#
#                           _<stage>_touch_stamps after this iteration
#   iter 1: stage      -->  stage
#   iter 2: build      -->  build stage
#   iter 3: configure  -->  configure build stage
#   iter 4: patch      -->  patch configure build stage
#   iter 5: source     -->  source patch configure build stage
#
# So `make source-touch` invalidates everything; `make build-touch`
# invalidates build and stage; `make stage-touch` invalidates only
# stage. Iterating forward would invert this and break the cascade
# semantics -- do not "tidy" this into _PackageStagesForward without
# also rethinking the accumulator.
#
# _PackageStagesForward is present unused but exists to document the
# normal, logical package build order.

_PackageStagesForward := source patch configure build stage
_PackageStagesReverse := stage build configure patch source

$(foreach _stage,$(_PackageStagesReverse),$(eval $(call _PackageStageRuleTemplate,$(_stage))))

# Convenience default: 'make touch' invalidates build + stage, which
# is the common case for "I edited source in a package source
# directory". After this a 'make build' or 'make stage' (or just
# 'make') is required (see "rebuild" target below).

.PHONY: touch
touch: build-touch
touch: recursive

# Convenience default: 'make rebuild' invalidates the build + stage
# AND rebuilds.

.PHONY: rebuild
rebuild:
	+$(Verbose)$(MAKE) -f $(FirstMakefile) --no-print-directory touch
	+$(Verbose)$(MAKE) -f $(FirstMakefile) --no-print-directory

# Always include in the private 'local-license' target a command that'll
# always succeed to avoid "make[n]: Nothing to be done for `license'." 
# messages for make files that do not have an 'license' target with
# commands.

local-license: $(PackageLicenseFile)
	$(Quiet)true

define BuildPrintHelpTpsSnapshot
$(Quiet)echo "    snapshot"
$(Quiet)echo "        Archive and compress the final build products from their staging"
$(Quiet)echo "        location in the results directory to a file within the software"
$(Quiet)echo "        package directory."
$(Quiet)echo
$(Quiet)echo "        The purpose of this is to support the 'replay' target goal which"
$(Quiet)echo "        can be later used to reanimate the final build products in the"
$(Quiet)echo "        staging location in the results directory without having to rebuild"
$(Quiet)echo "        the source from scratch. This is primarily designed to be an"
$(Quiet)echo "        efficiency boost to development engineers and should not be used for"
$(Quiet)echo "        customer- or quality assurance-bound builds."
$(Quiet)echo
endef

define BuildPrintHelpTpsReplay
$(Quiet)echo "    replay"
$(Quiet)echo "        Reanimate the final build products in the staging location in the"
$(Quiet)echo "        results directory without having to rebuild the source from scratch."
$(Quiet)echo
$(Quiet)echo "        The core build infrastructure automatically provides the necessary"
$(Quiet)echo "        macros, rules and commands to support the 'replay' target."
$(Quiet)echo
endef # BuildPrintHelpTpsSnapshot

define BuildPrintHelpTps
$(Quiet)echo "This makefile supports the following additional build targets:"
$(Quiet)echo
$(Quiet)echo "    license"
$(Quiet)echo "        Summarize the package license content to \"$(PackageName).license\"."
$(Quiet)echo
$(Quiet)echo "    source"
$(Quiet)echo "        Unarchive, if necessary, the package sources."
$(Quiet)echo
$(Quiet)echo "    patch"
$(Quiet)echo "        Patch, if necessary, the package sources."
$(Quiet)echo
$(Quiet)echo "    configure"
$(Quiet)echo "        Configure, if necessary, the package for building."
$(Quiet)echo
$(Quiet)echo "    build"
$(Quiet)echo "        Build the package artifacts to the build directory."
$(Quiet)echo
$(Quiet)echo "    stage"
$(Quiet)echo "        Stage the package artifacts to the results directory."
$(Quiet)echo
$(Quiet)echo "    source-touch"
$(Quiet)echo "        Invalidate the 'source' stamp sentinel file; making a rebuild of that"
$(Quiet)echo "        target goal and later possible."
$(Quiet)echo
$(Quiet)echo "    patch-touch"
$(Quiet)echo "        Invalidate the 'patch' stamp sentinel file; making a rebuild of that"
$(Quiet)echo "        target goal and later possible."
$(Quiet)echo
$(Quiet)echo "    configure-touch"
$(Quiet)echo "        Invalidate the 'configure' stamp sentinel file; making a rebuild of"
$(Quiet)echo "        that target goal and later possible."
$(Quiet)echo
$(Quiet)echo "    build-touch"
$(Quiet)echo "        Invalidate the 'build' stamp sentinel file; making a rebuild of that"
$(Quiet)echo "        target goal and later possible."
$(Quiet)echo
$(Quiet)echo "    stage-touch"
$(Quiet)echo "        Invalidate the 'stage' stamp sentinel file; making a rebuild of that"
$(Quiet)echo "        target goal possible."
$(Quiet)echo
$(Quiet)echo "    touch"
$(Quiet)echo "        A convenience alias for 'build-touch'."
$(Quiet)echo
$(Quiet)echo "    rebuild"
$(Quiet)echo "        A convenience alias for 'build-touch' and '$(PackageBuildMode)'."
$(Quiet)echo
$(Quiet)echo "This makefile additionally supports a behavior-altering 'BuildMode' variable."
$(Quiet)echo "When 'BuildMode' is set to 'snapshot', the results of the build that were"
$(Quiet)echo "staged to the results directory are placed into a compressed \"snapshot\""
$(Quiet)echo "archive."
$(Quiet)echo
$(Quiet)echo "This build mode is typically used by the person responsible for updating and"
$(Quiet)echo "maintaining a given third-party software package for which snapshot/replay"
$(Quiet)echo "builds are desired."
$(Quiet)echo
$(Quiet)echo "When 'BuildMode' is set to 'replay', the results of a previously-snapshot"
$(Quiet)echo "build are \"reanimated\" to the results directory."
$(Quiet)echo
$(Quiet)echo "The following makefile targets support these build modes:"
$(Quiet)echo
$(call BuildPrintHelpTpsSnapshot)
$(call BuildPrintHelpTpsReplay)
endef # BuildPrintHelpTps

#
# Third-party software snapshot/replay targets.
#

# Improve overall make iteration performance by only evaluating these
# rules if the package build mode is not the default mode.
#
# This particular header evaluates about 6x more slowly if the various
# directory and path variables have to be expanded and evaluated
# during iteration. Consequently, only expand and evaluate when
# necessary.

ifneq ($(PackageBuildMode),$(_PackageBuildModeDefault))

# Create, if necessary, the snapshot archive directory.

$(PackageSnapshotDir):
	$(create-directory-result)

# Snapshot a build from the temporary installation area.

.PHONY: snapshot
snapshot: $(PackageSnapshotPath)

# Archive the temporary installation area to a snapshot file.

$(PackageSnapshotPath): $(PackageStageStamp) | $(PackageSnapshotDir) $(ResultDirectory)
	$(Echo) "Saving snapshot to \"$(@)\""
	$(Verbose)$(RM) $(RMFLAGS) "$(@)"
	$(Verbose)tar -C $(ResultDirectory) --bzip2 -cf "$(@)" .
	$(Verbose)chmod a-w "$(@)"

# Replay a snapshot file to the temporary installation area.
ifeq ($(wildcard $(PackageSnapshotPath)),)
.PHONY: replay
replay: snapshot
else
.PHONY: replay
replay: | $(ResultDirectory)
	$(Echo) "Replaying snapshot from \"$(PackageSnapshotPath)\""
	$(Echo) "Replaying snapshot to \"$(call GenerateBuildRootEllipsedPath,$(ResultDirectory))\""
	$(Verbose)tar -C $(ResultDirectory) --bzip2 -xf $(PackageSnapshotPath)
endif # ifeq ($(wildcard $(PackageSnapshotPath)),)
endif # ifneq ($(PackageBuildMode),$(_PackageBuildModeDefault))
else
BuildPrintHelpTps := $(Null)
local-license:
	$(Quiet)true
endif # ifneq ($(PackageName),)
