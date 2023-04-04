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
#      This file is the make header for all common host (i.e. non-
#      target or -toolchain-specific) tools used in the project.
#

#
# General host build tools we expect to find in normal system
# locations (e.g. /bin, /usr/bin, /sbin, and /usr/sbin).
#

INSTALL                 = /usr/bin/install
INSTALLFLAGS            = -C

MKDIR                   = mkdir
MKDIRFLAGS              = -p

#
# Use "rmdir -p --ignore-fail-on-non-empty" to remove non-empty directories
# and their ancestors
#

RMDIR                   = rmdir
RMDIRFLAGS              = -p --ignore-fail-on-non-empty
ifeq ($(call IsYes,$(BuildVerbose)),Y)
RMDIRFLAGS              += -v
endif

PATCH                   = patch
PATCHFLAGS              = -s
ifeq ($(call IsYes,$(BuildVerbose)),Y)
RMDIRFLAGS              += --verbose
endif

RM                      = rm
RMFLAGS                 = -f
ifeq ($(call IsYes,$(BuildVerbose)),Y)
RMFLAGS                 += -v
endif

SED                     = sed
SEDFLAGS                =
#
# Script used for creating and updating build generation numbers.
#

MKGENERATION           := $(BuildRoot)/third_party/nuovations-build-make/repo/scripts/mkgeneration
MKGENERATIONFLAGS       =

# Common macro used in target commands for creating a directory as
# the target goal.

define create-directory
$(Echo) "Creating \"$(call GenerateBuildRootEllipsedPath,$@)\""
$(Verbose)$(MKDIR) $(MKDIRFLAGS) $@
endef

# Common macro used in target distclean commands for removing all
# empty subdirectories of a directory, and then remove the directory
# itself and its ancestors if it is empty.

define remove-empty-directory-and-ancestors
-$(Verbose)if [ -d $(1) ]; then \
        if [ "$$(ls -A $(1))" ]; then \
                find $(1)/* -depth -type d -exec $(RMDIR) {} +; \
        fi; \
        $(RMDIR) $(RMDIRFLAGS) $(1); \
fi;
endef

# create-symlink <link name> <target>
#
# Common macro to create a symbolic (that is, soft) link from the
# specified name to the target.

define create-symlink
$(Echo) "Linking \"$(call GenerateBuildRootEllipsedPath,$(2))\""
$(Verbose)ln -sf "$(1)" "$(2)"
endef

# create-symlink-result <link name> <target>
#
# Common macro to create a symbolic (that is, soft) link from the
# dependency built-in make variable to the target built-in make
# variable.

define create-symlink-result
$(call create-symlink,$(<),$(@))
endef

# create-links <source directory> <target directory>
#
# Common macro to create a "link farm" from a source directory to the
# target directory.

define create-links
$(Echo) "Shadowing \"$(call GenerateBuildRootEllipsedPath,$(1))\""
$(Verbose)$(LNDIR) $(1)/. $(2)
endef

# Common macro used in target commands for copying a file as the
# target goal from the target dependency.

define copy-result
$(Echo) "Copying \"$(call GenerateBuildRootEllipsedPath,$@)\""
$(Verbose)cp -f "$(<)" "$(@)"
endef

# Common macro used in target commands for moving a file as the
# target goal from the target dependency.

define move-result
$(Echo) "Moving \"$(call GenerateBuildRootEllipsedPath,$@)\""
$(Verbose)mv -f "$(<)" "$(@)"
endef

# Common macro used in target commands for installing a file as the
# target goal from the target dependency. Any missing parent
# directories in the target result are created, differing from
# copy-result above in which parent directories MUST exist.
#
# This is conducted in a host-dependent fashion.

define install-result
$(Echo) "Installing \"$(call GenerateBuildRootEllipsedPath,$@)\""
$(host-install-result)
endef

# expand-archive <source archive> <destination directory>
#
define expand-archive
$(Echo) "Expanding \"$(1)\" to \"$(2)\""
$(Verbose)extension=`echo $(1) | awk -F . '{if (NF > 1) {print $$NF}}'`; \
if [ $$extension = "7z" ]; then \
        7zr x -yw"$(2)" "$(1)" > /dev/null; \
elif [ $$extension = "bz2" ]; then \
        tar -C "$(2)" --bzip2 -xf "$(1)"; \
elif [ $$extension = "gz" ]; then \
        tar -C "$(2)" --gzip -xf "$(1)"; \
elif [ $$extension = "tar" ]; then \
        tar -C "$(2)" -xf "$(1)"; \
elif [ $$extension = "xz" ]; then \
        tar -C "$(2)" --xz -xf "$(1)"; \
elif [ $$extension = "Z" ]; then \
        tar -C "$(2)" -Z -xf "$(1)"; \
elif [ $$extension = "zip" ]; then \
        unzip -d "$(2)" -qo "$(1)"; \
else \
        echo "Unrecognized archive extension \"$$extension\"!"; \
        false; \
fi
endef

# patch-directory <directory> <arguments> <patch file> ...
#
define patch-directory
$(Verbose)for patch in $(3); do \
        echo "Applying \"$$patch\" to \"$(1)\""; \
        extension=`echo $$patch | awk -F . '{if (NF > 1) {print $$NF}}'`; \
        if [ $$extension = "bz2" ]; then \
                uncompressor="bunzip2 -c"; \
        elif [ $$extension = "gz" ]; then \
                uncompressor="gunzip -c"; \
        elif [ $$extension = "xz" ]; then \
                uncompressor="xz -d -c"; \
        elif [ $$extension = "Z" ]; then \
                uncompressor="uncompress -c"; \
        elif [ $$extension = "zip" ]; then \
                uncompressor="unzip -p"; \
        else \
                uncompressor="cat"; \
        fi; \
        $$uncompressor $$patch | $(PATCH) $(PATCHFLAGS) $(2) -d "$(1)" || exit; \
done
endef

# Fail the build if either HostOS or HostTuple are not defined.

# UpdateGenerationPath <path>
#
# Scope: Private
#
# Update the generation number associated with an archive, image,
# library, program or other target.
#
define UpdateGenerationPath
$(Echo) "Updating ($(notdir $(MKGENERATION))) \"$(1)\""
$(Verbose)$(MKGENERATION) $(MKGENERATIONFLAGS) "$(1)"
endef

$(call ErrorIfUndefined,HostOS)
$(call ErrorIfUndefined,HostTuple)

# Now that we know the host tuple, we can set the location we expect
# to find known, pre-built, project-local host exectuables, libraries
# and includes.

HostToolRoot            := $(BuildRoot)/build/tools/host
HostBinDir              := $(HostToolRoot)/$(HostTuple)/bin
HostSbinDir             := $(HostToolRoot)/$(HostTuple)/sbin
HostLibDir              := $(HostToolRoot)/$(HostTuple)/lib
HostIncDir              := $(HostToolRoot)/include
HostDataDir             := $(HostToolRoot)/share

include host/tools/$(HostOS).mak

include host/tools/perl.mak
