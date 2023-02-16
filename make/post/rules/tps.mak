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

# Always include in the private 'local-license' target a command that'll
# always succeed to avoid "make[n]: Nothing to be done for `license'." 
# messages for make files that do not have an 'license' target with
# commands.

local-license: $(PackageLicenseFile)
	$(Quiet)true

#
# Third-party software snapshot/replay targets.
#

# Create, if necessary, the snapshot archive directory.

$(PackageSnapshotDir):
	$(create-directory)

# Snapshot a build from the temporary installation area.

.PHONY: snapshot
snapshot: stage $(PackageSnapshotPath)

# Archive the temporary installation area to a snapshot file.

$(PackageSnapshotPath): | $(PackageSnapshotDir) $(ResultDirectory)
	$(Echo) "Saving snapshot to \"$(@)\""
	@rm -f $@
	$(Verbose)tar -C $(ResultDirectory) --bzip2 -cf $@ .
	$(Verbose)chmod a-w $@

# Replay a snapshot file to the temporary installation area.
ifeq ($(wildcard $(PackageSnapshotPath)),)
.PHONY: replay
replay: snapshot
else
.PHONY: replay
replay: | $(ResultDirectory)
	$(Echo) "Replaying snapshot from: $(PackageSnapshotPath)"
	$(Echo) "Replaying snapshot to \"$(call GenerateBuildRootEllipsedPath,$(ResultDirectory))\""
	$(Verbose)tar -C $(ResultDirectory) --bzip2 -xf $(PackageSnapshotPath)
endif
