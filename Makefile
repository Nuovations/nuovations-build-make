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
#      This make file supports generating distributions of
#      nuovations-build-make.
#

.DEFAULT_GOAL: all

#
# This package
#
PACKAGE              := nuovations-build-make

TARGET               := $(PACKAGE)

#
# Make Jobs
#

JOBS                 ?= $(shell getconf _NPROCESSORS_ONLN)

#
# Tools
#
CAT                  ?= cat
CHMOD                ?= chmod
CMP                  ?= cmp
CP                   ?= cp
FIND                 ?= find
GZIP                 ?= gzip
INSTALL              ?= install
MKDIR                ?= mkdir
MV                   ?= mv
RM                   ?= rm
RMDIR                ?= rmdir
SED                  ?= sed
TAR                  ?= tar
TARFLAGS             ?= --format pax
XZ                   ?= xz

INSTALL_SCRIPT       ?= $(INSTALL) -m 755

dist_tar_ARCHIVE      = $(TAR) $(TARFLAGS) -chf -

dist_tgz_ARCHIVE      = $(dist_tar_ARCHIVE)
dist_tgz_COMPRESS     = $(GZIP) --best -c

dist_txz_ARCHIVE      = $(dist_tar_ARCHIVE)
dist_txz_COMPRESS     = $(XZ) --extreme -c

TGZ_EXTENSION        := .tar.gz
TXZ_EXTENSION        := .tar.xz

DIST_TARGETS	     ?= dist-tgz dist-txz
DIST_ARCHIVES         = $(dist_tgz_TARGETS) $(dist_txz_TARGETS)

#
# Verbosity
#

AT                   := @

DEFAULT_VERBOSITY    ?= 0

V                    ?= $(DEFAULT_VERBOSITY)

_PROGRESS            := printf "  %-13s %s\n"
PROGRESS             := $(AT)$(_PROGRESS)

V_AT                  = $(V_AT_$(V))
V_AT_                 = $(V_AT_$(DEFAULT_VERBOSITY))
V_AT_0                = $(AT)
V_AT_1                = 

V_CHMOD_TARGET        = $(V_CHMOD_TARGET_$(V))
V_CHMOD_TARGET_       = $(V_CHMOD_TARGET_$(DEFAULT_VERBOSITY))
V_CHMOD_TARGET_0      = $(PROGRESS) "CHMOD" "$(@)";
V_CHMOD_TARGET_1      = 

V_COPY_TARGET         = $(V_COPY_TARGET_$(V))
V_COPY_TARGET_        = $(V_COPY_TARGET_$(DEFAULT_VERBOSITY))
V_COPY_TARGET_0       = $(PROGRESS) "COPY" "$(@)";
V_COPY_TARGET_1       = 

V_COPY_DISTFILES      = $(V_COPY_DISTFILES_$(V))
V_COPY_DISTFILES_     = $(V_COPY_DISTFILES_$(DEFAULT_VERBOSITY))
V_COPY_DISTFILES_0    = $(AT)for file in $(DISTFILES); do $(_PROGRESS) "COPY" "$${file}"; done;
V_COPY_DISTFILES_1    = 

V_INSTALL             = $(V_INSTALL_$(V))
V_INSTALL_            = $(V_INSTALL_$(DEFAULT_VERBOSITY))
V_INSTALL_0           = $(PROGRESS) "INSTALL" "$(@)";
V_INSTALL_1           = 

V_MAKE_DIST_HOOK      = $(V_MAKE_DIST_HOOK_$(V))
V_MAKE_DIST_HOOK_     = $(V_MAKE_DIST_HOOK_$(DEFAULT_VERBOSITY))
V_MAKE_DIST_HOOK_0    = $(PROGRESS) "MAKE" "dist-hook";
V_MAKE_DIST_HOOK_1    = 

V_MAKE_TARGET         = $(V_MAKE_TARGET_$(V))
V_MAKE_TARGET_        = $(V_MAKE_TARGET_$(DEFAULT_VERBOSITY))
V_MAKE_TARGET_0       = $(PROGRESS) "MAKE" "$(@)";
V_MAKE_TARGET_1       = 

V_MKDIR_P             = $(V_MKDIR_P_$(V))
V_MKDIR_P_            = $(V_MKDIR_P_$(DEFAULT_VERBOSITY))
V_MKDIR_P_0           = $(PROGRESS) "MKDIR" "$(1)";
V_MKDIR_P_1           = 

V_PROGRESS            = $(V_PROGRESS_$(V))
V_PROGRESS_           = $(V_PROGRESS_$(DEFAULT_VERBOSITY))
V_PROGRESS_0          = $(PROGRESS)
V_PROGRESS_1          = $(AT)true

V_RMDIR               = $(V_RMDIR_$(V))
V_RMDIR_              = $(V_RMDIR_$(DEFAULT_VERBOSITY))
V_RMDIR_0             = $(PROGRESS) "RMDIR" "$(1)";
V_RMDIR_1             = 

V_SED                 = $(V_SED_$(V))
V_SED_                = $(V_SED_$(DEFAULT_VERBOSITY))
V_SED_0               = $(PROGRESS) "SED" "$(@)";
V_SED_1               = 

V_TGZ                 = $(V_TGZ_$(V))
V_TGZ_                = $(V_TGZ_$(DEFAULT_VERBOSITY))
V_TGZ_0               = $(PROGRESS) "TGZ" "$(@)";
V_TGZ_1               = 

V_TXZ                 = $(V_TXZ_$(V))
V_TXZ_                = $(V_TXZ_$(DEFAULT_VERBOSITY))
V_TXZ_0               = $(PROGRESS) "TXZ" "$(@)";
V_TXZ_1               = 

#
# create-dir <directory>
#
# Create the specified directory, including any parent directories
# that may not exist.
#
define create-dir
$(PROGRESS) "MKDIR" "$(1)"; \
$(MKDIR) -p "$(1)"
endef # create-dir

#
# remove-dir <directory>
#
# If the specified directory exists, then ensure all of the
# directories are writable by the current user, and then forcibly
# remove the directory and all of its contents, sleeping for five (5)
# seconds and failure before trying the removal again.
#
define remove-dir
$(V_RMDIR) \
if [ -d "$(1)" ]; then \
    $(FIND) "$(1)" -type d ! -perm -200 -exec $(CHMOD) u+w {} ';' \
    && $(RM) -rf "$(1)" \
    || { sleep 5 && $(RM) -rf "$(1)"; }; \
fi
endef # remove-dir

#
# Source directories
#

abs_srcdir            = $(abspath $(srcdir))
abs_top_srcdir        = $(abspath $(top_srcdir))
srcdir                = $(patsubst %/,%,$(dir $(firstword $(MAKEFILE_LIST))))
top_srcdir            = $(srcdir)

#
# Build directories
#

abs_builddir          = $(abspath $(builddir))
abs_top_builddir      = $(abspath $(top_builddir))
builddir              = .
top_builddir          = $(builddir)

#
# Install directories
#

DESTDIR              ?=

prefix               ?= /usr/local
exec_prefix          ?= "${prefix}"
bindir               ?= "${exec_prefix}/bin"

distdir               = $(PACKAGE)-$(VERSION)

dist_tgz_TARGETS      = $(distdir)$(TGZ_EXTENSION)
dist_txz_TARGETS      = $(distdir)$(TXZ_EXTENSION)

DISTFILES            := $(shell $(CAT) $(srcdir)/MANIFEST)

#
# Package version files:
#
# .default-version - The default package version. This file is ALWAYS checked
#                    in and should always represent the current baseline
#                    version of the package.
#
# .dist-version    - The distributed package version. This file is NEVER
#                    checked in within the upstream repository, is auto-
#                    generated, and is only found in the package distribution.
#
# .local-version   - The current source code controlled package version. This
#                    file is NEVER checked in within the upstream repository,
#                    is auto-generated, and can always be found in both the
#                    build tree and distribution.
#
# When present, the .local-version file is preferred first, the
# .dist-version second, and the .default-version last.
#

# VERSION_FILE should be and is intentionally an immediate (:=) rather
# than a deferred (=) variable to ensure the value binds once and only once
# for a given MAKELEVEL even as .local-version and .dist-version are created
# during makefile execution.

VERSION_FILE                      := $(if $(wildcard $(builddir)/.local-version),$(builddir)/.local-version,$(if $(wildcard $(srcdir)/.dist-version),$(srcdir)/.dist-version,$(srcdir)/.default-version))

#
# The two-level variables and the check against MAKELEVEL ensures that
# not only can the package version be overridden from the command line
# but also when the version is NOT overridden that we bind the version
# once and only once across potential sub-makes to prevent the version
# from flapping as VERSION_FILE changes.
#

export MAYBE_PACKAGE_VERSION      := $(if $(filter 0,$(MAKELEVEL)),$(shell cat $(VERSION_FILE) 2> /dev/null),$(MAYBE_PACKAGE_VERSION))

PACKAGE_VERSION                   ?= $(MAYBE_PACKAGE_VERSION)

VERSION                            = $(PACKAGE_VERSION)

#
# check-file <macro suffix>
#
# Check whether a file, referenced by the $(@) variable, should be
# updated / regenerated based on its dependencies, referenced by the
# $(<) variable by running the make macro check-file-<macro suffix>.
#
# The $(<) is passed as the first argument if the macro wants to process
# it and the prospective new output file, which the macro MUST
# generate, as the second.
#
# This macro will ensure that any required parent directories are created
# prior to invoking check-file-<macro suffix>.
#
# This macro is similar to and inspired by that from Linux Kbuild and
# elsewhere.
#
#   <macro suffix> - The name, suffixed to "check-file-", which indicates
#                    the make macro to invoke.
#
#
define check-file
$(V_AT)set -e;                                      \
$(_PROGRESS) "CHECK" "$(@)";                        \
$(MKDIR) -p $(dir $(@));                            \
$(call check-file-$(1),$(<),$(@).N);                \
if [ -r "$(@)" ] && $(CMP) -s "$(@)" "$(@).N"; then \
    $(RM) -f "$(@).N";                              \
else                                                \
    $(_PROGRESS) "GEN" "$(@)";                      \
    $(MV) -f "$(@).N" "$(@)";                       \
fi
endef # check-file

#
# check-file-.local-version
#
# Speculatively regenerate .local-version and check to see if it needs
# to be updated.
#
# If PACKAGE_VERSION has been supplied anywhere other than in this file
# (which is implicitly the contents of .local-version), then use that;
# otherwise, attempt to generate it from the SCM system.
#
# This is called from $(call check-file,.local-version).
#
define check-file-.local-version
if [ "$(origin PACKAGE_VERSION)" != "file" ]; then     \
    echo "$(PACKAGE_VERSION)" > "$(2)";                \
else                                                   \
    $(abs_top_srcdir)/scripts/mkversion                \
        -b "$(PACKAGE_VERSION)" "$(top_srcdir)"        \
        > "$(2)";                                      \
fi
endef

#
# check-file-.dist-version
#
# Speculatively regenerate .dist-version and check to see if it needs
# to be updated.
#
# This is called from $(call check-file,.dist-version).
#
define check-file-.dist-version
$(CAT) "$(1)" > "$(2)"
endef

all: $(builddir)/.local-version

#
# Version file regeneration rules.
#
.PHONY: force

$(builddir)/.local-version: $(srcdir)/.default-version force

$(distdir)/.dist-version: $(builddir)/.local-version force

$(distdir)/.dist-version $(builddir)/.local-version:
	$(call check-file,$(@F))

$(DESTDIR)$(bindir):
	$(call create-dir,"$(@)")

dist-hook: $(distdir)/.dist-version

#
# Stage the distribution files to a distribution directory
#
stage: $(DISTFILES) $(builddir)/.local-version
	$(call remove-dir,$(distdir))
	$(call create-dir,$(distdir))
	$(V_MAKE_DIST_HOOK)$(MAKE) -s distdir="$(distdir)" dist-hook
	$(V_COPY_DISTFILES)(cd $(abs_top_srcdir); $(dist_tar_ARCHIVE) $(DISTFILES) | (cd $(abs_builddir)/$(distdir); $(TAR) $(TARFLAGS) -xBpf -))

#
# Produce an architecture-independent distribution using a tar archive
# with gzip compression
#
$(dist_tgz_TARGETS): stage
	$(V_TGZ)$(dist_tgz_ARCHIVE) $(distdir) | $(dist_tgz_COMPRESS) > "$(@)"

#
# Produce an architecture-independent distribution using a tar archive
# with xz compression
#
$(dist_txz_TARGETS): stage
	$(V_TXZ)$(dist_txz_ARCHIVE) $(distdir) | $(dist_txz_COMPRESS) > "$(@)"

#
# Produce an architecture-independent distribution of the
# nlbuild-autotools core.
#

dist: $(DIST_TARGETS) $(builddir)/.local-version
	$(call remove-dir,$(distdir))

dist-tgz: $(dist_tgz_TARGETS)

dist-txz: $(dist_txz_TARGETS)

check-clean-examples:
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-examples-debug
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-examples-development
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-examples-release
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-debug
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-development
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-release
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean-examples
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples clean

check-distclean-examples: check-clean-examples
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-examples-debug
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-examples-development
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-examples-release
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-debug
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-development
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-release
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean-examples
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples distclean

check-examples: check-clean-examples check-distclean-examples
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples examples-debug
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples examples-development
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples examples-release
	+$(V_AT)$(MAKE) -j $(JOBS) -C examples examples
	+$(V_AT)$(MAKE) check-clean-examples
	+$(V_AT)$(MAKE) check-distclean-examples

#
# check-examples-with-shell <shell name> <shell source command>
#
# Check the package by running the examples against a particular shell.
# to be updated.
#
# This performs the following steps:
#
#   1. Displays progress about the target being made, the shell being
#      invoked, and the make being performed for 'examples'.
#   2. Invokes the specified shell with the '-c' option, changing
#      directory to 'examples', sourcing the appropriate shell-specific
#      build environment setup script, and then re-invoking this makefile
#      from that shell with the 'check-examples' target.
#
define check-examples-with-shell
$(V_MAKE_TARGET)
$(V_PROGRESS) "$(shell echo $(1) | tr '[[:lower:]]' '[[:upper:]]')" "$(shell which $(1))"
$(V_PROGRESS) "MAKE" "examples"
$(V_AT)$(1) -c 'cd examples && $(2) build/scripts/environment/setup.$(1) && $(MAKE) -C $(CURDIR) check-examples'
endef # check-examples-with-shell

check-examples-bash:
	$(call check-examples-with-shell,bash,.)

check-examples-csh:
	$(call check-examples-with-shell,csh,source)

check-examples-dash:
	$(call check-examples-with-shell,dash,.)

check-examples-sh:
	$(call check-examples-with-shell,sh,.)

check-examples-tcsh:
	$(call check-examples-with-shell,tcsh,source)

check-examples-zsh:
	$(call check-examples-with-shell,zsh,.)

check: check-examples-bash check-examples-csh check-examples-dash check-examples-sh check-examples-tcsh check-examples-zsh

distcheck:
	$(V_MAKE_TARGET)
	+$(V_AT)$(MAKE) check
	+$(V_AT)$(MAKE) -j $(JOBS) dist

clean-local:
	$(V_PROGRESS) "CLEAN" "."
	$(V_AT)$(RM) -f *~ "#"*

clean: clean-local
