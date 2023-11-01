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
#      This file is the make header for all Darwin host (i.e. non-
#      target or -toolchain-specific) tools used in the project.
#

LNDIR		= lndir -silent
SIZE		= /usr/bin/stat -f "%z"

# host-install <source path> <destination path>
#
# Host-dependent implementation of the macro for installing a
# destination file from a source file.
#
# Any missing parent directories in the destination path are created.

define host-install
$(Verbose)$(MKDIR) $(MKDIRFLAGS) "$(dir $(1))"
$(Verbose)$(INSTALL) $(INSTALLFLAGS) "$(1)" "$(2)"
endef
