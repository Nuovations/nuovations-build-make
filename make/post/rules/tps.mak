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
local-license:
	$(Quiet)true
endif # ifneq ($(PackageName),)
