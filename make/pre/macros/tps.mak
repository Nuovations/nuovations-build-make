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

_PackageRootDefault              = $(CURDIR)

PackageRoot                      = $(_PackageRootDefault)

PackageThirdPartyName           := README.third_party

_GeneratePackagePaths            = $(addprefix $(call Slashify,$(PackageRoot)),$(1))

_PackageThirdPartyPath           = $(call _GeneratePackagePaths,$(PackageThirdPartyName))

PackageThirdPartyPath            = $(wildcard $(_PackageThirdPartyPath))

_PackageHasThirdPartyPath        = $(if $(PackageThirdPartyPath),Y,N)

PackageLicenseFile               = $(if $(PackageName),$(call _GeneratePackagePaths,$(PackageName).license),)
PackageURLFile                   = $(if $(PackageName),$(call _GeneratePackagePaths,$(PackageName).url),)
PackageVersionFile               = $(if $(PackageName),$(call _GeneratePackagePaths,$(PackageName).version),)

define _package-extract-third_party-field-from-path
$(shell sed -n -e 's/$(1):[[:space:]]*//gp' "$(2)")
endef

define _package-extract-third_party-field
$(call _package-extract-third_party-field-from-path,$(1),$(_PackageThirdPartyPath))
endef

PackageName                     ?= $(if $(call IsYes,$(_PackageHasThirdPartyPath)),$(call _package-extract-third_party-field,Short Name),$(Null))
PackageURL                      ?= $(if $(call IsYes,$(_PackageHasThirdPartyPath)),$(call _package-extract-third_party-field,URL),$(if $(wildcard $(PackageURLFile)),$(shell cat $(PackageURLFile)),))
PackageVersion                  ?= $(if $(call IsYes,$(_PackageHasThirdPartyPath)),$(call _package-extract-third_party-field,Version),$(if $(wildcard $(PackageVersionFile)),$(shell cat $(PackageURLFile)),))

PackagePatchDir                  = $(call _GeneratePackagePaths,$(PackageName).patches)
PackagePatchPaths                = $(sort $(wildcard $(PackagePatchDir)/*.patch*))

PackageSnapshotFile             := $(PackageName)-snapshot.tar.bz2
PackageSnapshotPath             := $(call Slashify,$(PackageSnapshotDir))$(PackageSnapshotFile)
PackageDefaultGoal              := $(if $(BuildMode),$(call ToLower,$(BuildMode)),stage)

# expand-and-patch-package
#
define expand-and-patch-package
$(call expand-archive,$(call _GeneratePackagePaths,$(PackageArchive)),.)
$(call patch-directory,$(@),$(PackagePatchArgs),$(PackagePatchPaths))
$(Verbose)touch $(@)
endef
