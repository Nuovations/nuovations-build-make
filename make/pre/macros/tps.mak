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
#      This file defines make macros common to all third-party software
#      make headers and files.
#
#    Third-party packages may either:
#
#      1. Define 'PackageName' in their own makefile and then provide
#         $(PackageName).url and $(PackageName).version files at the
#         top-level of the third-party package.
#      2. Include README.third_party, per the Google Chromium template
#         <https://chromium.googlesource.com/chromium/src/+/HEAD/third_party/README.chromium.template> at the top level of the third-party package, from
#         which name (required), URL (optional), and version (optional)
#         are extracted.
#

_ThirdPartyFile                 := README.third_party

PackageThirdPartyFile           := $(wildcard $(_ThirdPartyFile))

_PackageHasThirdPartyFile       := $(if $(PackageThirdPartyFile),Y,N)

PackageLicenseFile		= $(if $(PackageName),$(PackageName).license,)
PackageURLFile			= $(if $(PackageName),$(PackageName).url,)
PackageVersionFile		= $(if $(PackageName),$(PackageName).version,)

define _package-extract-third_party-field
$(shell sed -n -e 's/$(1):[[:space:]]*//gp' "$(_ThirdPartyFile)")
endef

ifeq ($(call IsYes,$(_PackageHasThirdPartyFile)),Y)
PackageName                     := $(call _package-extract-third_party-field,Short Name)
PackageURL                      := $(call _package-extract-third_party-field,URL)
PackageVersion                  := $(call _package-extract-third_party-field,Version)
else
PacakgeURL                      ?= $(shell cat $(PackageURLFile))
PackageVersion			?= $(shell cat $(PackageVersionFile))
endif

PackagePatchDir			= $(PackageName).patches
PackagePatchPaths		= $(sort $(wildcard $(PackagePatchDir)/*.patch*))

PackageSnapshotFile		:= $(PackageName)-snapshot.tar.bz2
PackageSnapshotPath		:= $(call Slashify,$(PackageSnapshotDir))$(PackageSnapshotFile)
PackageDefaultGoal		:= $(if $(BuildMode),$(call ToLower,$(BuildMode)),stage)

# expand-and-patch-package
#
define expand-and-patch-package
$(call expand-archive,$(PackageArchive),.)
$(call patch-directory,$(@),$(PackagePatchArgs),$(PackagePatchPaths))
$(Verbose)touch $(@)
endef
