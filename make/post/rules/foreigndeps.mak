#
#    Copyright (c) 2025 Nuovation System Design, LLC. All Rights Reserved.
#

#
#    Copyright 2020 nlbuild-autotools Authors. All Rights Reserved.
#

#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

#
#    Description:
#      This file is the automake header for building foreign make
#      (that is, outside of the current make directory) dependencies.
#
#      Two types of foreign make dependencies are supported:
#
#        * file
#
#            EXPLICIT dependecies that follow the form '<DIR>/<TARGET>'
#            where '$(MAKE) -C <DIR> <TARGET>' will produce and satisfy
#            the desired dependency expected by the current make file
#
#        * subdir
#
#            IMPLICIT dependecies that follow the form '<DIR>'
#            where '$(MAKE) -C <DIR>' will produce and satisfy
#            the desired dependencies expected by the current
#            make file.
#
#      This defines make targets and commands for handling such
#      foreign make dependencies.  overridden by project make files.
#

# The user-supported and -visible targets for foreign dependencies are:
#
#   * foreign-deps
#
#       Build all foreign target dependencies, including both files or
#       subdirectories.
#
#   * foreign-file-deps
#
#       Build only foreign file target dependencies.
#
#   * foreign-subdir-deps
#
#       Build only foreign subdirectory target dependencies.
#

.PHONY: foreign-file-deps foreign-subdir-deps foreign-deps

foreign-deps: foreign-file-deps foreign-subdir-deps

foreign-file-deps:

foreign-subdir-deps:

#
# if defined(ForeignFileDependencies) || defined(ForeignSubdirDependencies)
#
ifneq ($(strip $(ForeignFileDependencies)$(ForeignSubdirDependencies)),)

#
# Foreign target dependency sentinel file management
#

# All foreign target dependency sentinel files are of the form
# [.<path>]<sentinel file stem><unique invocation qualifier, where
# [.<path>] is only included if the <path> is non-empty.

# This defines the <sentinel file stem>.

FOREIGN_DEPENDENCIES_SENTINEL_STEM      := .build_foreign_deps_

# This defines the <unique invocation qualifier>.
#
# Check to see if FOREIGN_DEPENDENCIES_SENTINEL_ID has been set for
# this make invocation.

ifneq ($(origin FOREIGN_DEPENDENCIES_SENTINEL_ID),environment)

  # the parent of this shell is the "root" make invocation
  override FOREIGN_DEPENDENCIES_SENTINEL_ID:=$(shell echo $$PPID)

  # makes makedirs_id an environment var
  export FOREIGN_DEPENDENCIES_SENTINEL_ID

endif

#
# foreign-create-dependencies-sentinel-name <target path> <unique invocation qualifier>
#
# This creates a name for a foreign target dependency sentinel
# file using the specified target path and unique invocation
# qualifier.
#
# The target path will be transformed by eliding double-dot (..)
# sequences, transforming path separators (/) into underscores (_),
# and transforming dots (.) into underscores (_).
#
define foreign-create-dependencies-sentinel-name
$(if $(1),.$(subst .,_,$(subst /,_,$(subst ..,,$(1)))),)$(FOREIGN_DEPENDENCIES_SENTINEL_STEM)$(2)
endef

#
# foreign-create-unique-dependencies-sentinel-name <target path> <unique invocation qualifier>
#
# This creates a unique name for a foreign target dependency sentinel
# file using the specified target path, qualified by the current make
# process identifier.
#
define foreign-create-unique-dependencies-sentinel-name
$(call foreign-create-dependencies-sentinel-name,$(1),$(FOREIGN_DEPENDENCIES_SENTINEL_ID))
endef

#
# MARK: ForeignSubdirDependencies
#
ifdef ForeignSubdirDependencies

ifeq ($(MAKECMDGOALS),$(filter-out clean distclean,$(MAKECMDGOALS)))

# Always ensure that foreign-subdir-deps runs first against any
# non-clean target goals such that make file maintainers do not have
# to set up any explicit dependencies when they define
# ForeignSubdirDependencies.
#
# Do this by tricking make into building foreign-subdir-deps first
# by forcing it to try to make an include file that depends on
# foreign-subdir-deps.

-include .foreign_deps_trick_never_exists.min

.foreign_deps_trick_never_exists.min: foreign-subdir-deps

endif # ifeq ($(MAKECMDGOALS),$(filter-out clean distclean,$(MAKECMDGOALS)))

define foreign-subdir-make
	$(Echo) "Processing \"$(call GenerateBuildRootEllipsedPath,$(if $(call IsAbsolutePath,$(1)),$(1),$(BuildCurrentDirectory)/$(1)))\""
	+$(Verbose)$(MAKE) $(MFLAGS) -C "$(1)"
endef # foreign-subdir-make

#
# foreign-create-unique-subdir-dependencies-sentinel-name <target subdirectory>
#
# This creates the name of a foreign subdirectory dependency sentinel
# file of the form:
#
#   <target subdirectory>/<sentinel stem><sentinel unique id>
#
define foreign-create-unique-subdir-dependencies-sentinel-name
$(call Deslashify,$(1))/$(call foreign-create-unique-dependencies-sentinel-name,$(notdir $(call Slashify,$(1))))
endef

#
# foreign-create-unique-subdir-dependencies-sentinel-name-glob <target subdirectory> <glob pattern>
#
# This creates the glob name pattern of a foreign subdirectory
# dependency sentinel file of the form:
#
#   <target subdirectory>/<sentinel stem><glob pattern>
#
define foreign-create-unique-subdir-dependencies-sentinel-name-glob
$(call Deslashify,$(1))/$(call foreign-create-dependencies-sentinel-name,$(notdir $(call Slashify,$(1))),$(2))
endef

#
# FOREIGN_SUBDIR_DEPENDENCY_template <foreign subdir target>
#
# This template defines targets and associated commands for building a
# foreign subdir target depedendency via a subdirectory make (for
# example, `make -C ../foo` for directory '../foo').
#
define FOREIGN_SUBDIR_DEPENDENCY_template

# The foreign subdirectory dependency depends on a sentinel for it such that
# make is forced to visit the directory (should any of its
# dependencies have changed since the last visit).

FOREIGN_SUBDIR_CLEANFILE_GLOBS += $(call foreign-create-unique-subdir-dependencies-sentinel-name-glob,$(1),*)

foreign-subdir-deps: $(call foreign-create-unique-subdir-dependencies-sentinel-name,$(1)) 

$$(call foreign-create-unique-subdir-dependencies-sentinel-name,$(1)):
	$(Verbose)touch "$$(@)"
	$(call foreign-subdir-make,$(1))
	$(Verbose)$(RM) $(RMFLAGS) $(filter-out $$(@),$(wildcard $(call foreign-create-unique-subdir-dependencies-sentinel-name-glob,$(1),*)))

endef # FOREIGN_SUBDIR_DEPENDENCY_template

# Clean up any foreign subdirectory dependency sentinel files by
# hooking on any clean target is invoked.
#
# NOTE: We CANNOT just hook on 'clean-local' since it won't be recognized
# unless the make file including this one uses it.

clean distclean: foreign-subdir-dependency-clean

foreign-subdir-dependency-clean:
	$(Verbose)$(RM) $(RMFLAGS) $(FOREIGN_SUBDIR_CLEANFILE_GLOBS)

# Instantiate the foreign subdirectory dependency template for each
# subdirectory in ForeignSubdirDependencies.

$(foreach foreign-subdir-dependency,$(ForeignSubdirDependencies),$(eval $(call FOREIGN_SUBDIR_DEPENDENCY_template,$(foreign-subdir-dependency))))

endif # ForeignSubdirDependencies

#
# MARK: ForeignFileDependencies
#
ifdef ForeignFileDependencies

foreign-file-deps: $(ForeignFileDependencies)

define foreign-file-make
	$(Echo) "Processing \"$(call GenerateBuildRootEllipsedPath,$(if $(call IsAbsolutePath,$(1)),$(1),$(BuildCurrentDirectory)/$(1)))\""
	+$(Verbose)$(MAKE) $(MFLAGS) -C "$(dir $(1))" "$(notdir $(1))"
endef # foreign-file-make

#
# foreign-create-unique-file-dependencies-sentinel-name <target file
#
# This creates the name of a foreign file dependency sentinel file of
# the form:
#
#   $(dir <target file>)/$(notdir <target file>)<sentinel stem><sentinel unique id>
#
define foreign-create-unique-file-dependencies-sentinel-name
$(call Deslashify,$(dir $(1)))/$(call foreign-create-unique-dependencies-sentinel-name,$(notdir $(1)))
endef

#
# foreign-create-unique-file-dependencies-sentinel-name-glob <target file <glob pattern>
#
# This creates the glob name pattern of a foreign file dependency
# sentinel file of the form:
#
#    $(dir <target file>)/$(notdir <target file>)<sentinel stem><glob pattern>
#
define foreign-create-unique-file-dependencies-sentinel-name-glob
$(call Deslashify,$(dir $(1)))/$(call foreign-create-dependencies-sentinel-name,$(notdir $(1)),$(2))
endef

#
# FOREIGN_FILE_DEPENDENCY_template <foreign file target>
#
# This template defines targets and associated commands for building a
# foreign file target depedendency via a subdirectory make (for
# example, `make -C ../foo bar` for target 'bar' in directory
# '../foo').
#
define FOREIGN_FILE_DEPENDENCY_template

# The foreign file dependency depends on a sentinel for it such that
# make is forced to visit the directory that creates it (should any of
# its dependencies have changed since the last visit).

FOREIGN_FILE_CLEANFILE_GLOBS += $(call foreign-create-unique-file-dependencies-sentinel-name-glob,$(1),*)

$(1): $$(call foreign-create-unique-file-dependencies-sentinel-name,$(1))
	$(call foreign-file-make,$(1))

$$(call foreign-create-unique-file-dependencies-sentinel-name,$(1)):
	$(Verbose)touch "$$(@)"
	$(Verbose)$(RM) $(RMFLAGS) $(filter-out $$(@),$(wildcard $(call foreign-create-unique-file-dependencies-sentinel-name-glob,$(1),*)))

endef # FOREIGN_FILE_DEPENDENCY_template

# Clean up any foreign file dependency sentinel files by hooking on
# any clean target is invoked.
#
# NOTE: We CANNOT just hook on 'clean-local' since it won't be recognized
# unless the make file including this one uses it.

clean distclean: foreign-file-dependency-clean

foreign-file-dependency-clean:
	$(Verbose)$(RM) $(RMFLAGS) $(FOREIGN_FILE_CLEANFILE_GLOBS)

# Instantiate the foreign file dependency template for each file in
# ForeignFileDependencies.

$(foreach foreign-file-dependency,$(ForeignFileDependencies),$(eval $(call FOREIGN_FILE_DEPENDENCY_template,$(foreign-file-dependency))))

endif # ForeignFileDependencies

endif # ForeignFileDependencies || ForeignSubdirDependencies
