Getting Started
===============

To get started with nuovations-build-make, as a project owner or maintainer, you
will need to do two things:

  1. Import nuovations-build-make into your project.
  2. Author makefiles and/or makefile "headers" for your project and its products.

# Importing nuovations-build-make into Your Project

This project is typically subtreed (or git submoduled) into a target
project repository and serves as the seed for that project's build system.

Assuming that you already have a project repository established in
git, perform the following in your project repository:

```sh
1. % git remote add nuovations-build-make https://<PATH_TO_REPOSITORY>/nuovations-build-make.git
2. % git fetch nuovations-build-make
```

By convention, the nuovations-build-make package should be placed in
"third_party/nuovations-build-make/repo":

```sh
3. % mkdir third_party
4. % git subtree add --prefix=third_party/nuovations-build-make/repo --squash --message="Add subtree mirror of repository 'https://<PATH_TO_REPOSITORY>/nuovations-build-make.git' branch 'main' at commit 'HEAD'." nuovations-build-make HEAD
```

At this point, you now have the nuovations-build-make package integrated
into your project. The next step is using the nuovations-build-make-provided
examples as templates. To do this, a convenience script has been provided
that will get you started. You can tune and customize the results, as needed,
for your project. From the top level of your project tree:

```sh
5. % third_party/nuovations-build-make/repo/scripts/mkskeleton -I third_party/nuovations-build-make/repo/scripts/mkskeleton --package "<name>" --product "<name>"
```

If you have more than one product in your project, feel free to add as many
products as are in your project with additional `--product <name>` options.

When the `mkskeleton` script is complete, you will find the following files
and directories in your project:

| File or Directory                      | Description |
| -------------------------------------- | ----------- |
| build                                  | Build-related makefile headers and scripts. |
| build/make                             | Build-related makefile headers that will be searched in by make when called for via make `include` directives. |
| build/make/products                    | Product-specific makefile headers that will be used when building for a specific product.
| build/make/products/*.mak              | Product-specific makefile header(s). |
| build/scripts                          | Build-related setup and support scripts. |
| build/scripts/environment              | Build-related per-shell setup scripts. This is a symbolic link to the nuovations-build-make root. |
| *.mak                                  | Project- or product-specific makefile to which builds are dispatched for your project and/or products. |
| Makefile                               | Top-level makefile for all configurations and products in the project from which any top-level build is dispatched. This is a symbolic link symbolic link to the nuovations-build-make repo subtree. |
| third_party/nuovations-build-make/repo | The directory or a symbolic link thereto containing the nuovations-build-make repo. |

Before authoring or modifying makefiles and/or makefile "headers" for your
project and its products, you may want to familiarize yourself with
nuovations-build-make by looking at the _examples_ directory at the top of
nuovations-build-make project repository. To begin that exploration, you
might try the following steps:

  # `source build/scripts/environment/setup.${SHELL}`
  # `make help`
  # `make`
  # `make clean`

where `${SHELL}` is the shell for your current interactive login shell, for example `bash`.

## Supported Build Host Systems

The only external dependency for nuovations-build-make is GNU make 3.81 or later.

The nuovations-build-make system supports and has been tested against the
following POSIX-based build host systems:

  * i686-pc-cygwin
  * i686-pc-linux-gnu
  * x86_64-apple-darwin
  * x86_64-pc-cygwin
  * x86_64-pc-linux-gnu
  * x86_64-unknown-linux-gnu

It should generally work and run on an POSIX- and UNIX-compatible OS or environment.

# Author Makefiles and/or Makefile "Headers" for your Project and its Products

There are a handful of different types of makefiles or makefile "headers" you
may find yourself writing for your project and its products:

  1. Makefile "Headers"
     a. Product "Headers"
     b. Target Tool "Headers"
     c. Configuration "Headers"
  2. Makefiles
     a. Product or Project
     b. Archive Library
     c. Shared Library
     d. Executable Program
     e. Executable Image
     f. Recursive
     g. Third-party
     h. Other
     
In particular for (2), it is more than likely that you will author makefiles
that include some combination of (b) through (g) above. The aforementioned
nuovations-build-make "examples" illustrate all of the above.

## Makefile "Headers"

These makefiles are unique in that they are included by other makefiles and,
as a result, are not standalone.

If you are content with the build configurations already present with
nuovations-build-make and are building for a native host rather than a
cross-compiled target environment, then one or more product "headers" is
all you will need to modify or author for your project.

### Product

If you used the `mkskeleton` script to setup your project, then default
templates for the products you specified with that script have already
been created under _build/make/products/*.mak_.

Your product makefile header can be as simple or as complicated as
dictated by the needs of your project and product. Over time, you may
find it useful for your product makefile header to include other makefile
headers to the extent there is sharing of common values or configuration
across products.

**NOTE:** If you create such shared makefile headers among your products,
use a subdirectory to do so. Otherwise, nuovations-build-make will pick
up any _build/make/products/*.mak_ file as a product to be built.

The most important values for a product makefile header are:

`BuildProductTopMakefile`
: The absolute path (likely qualified with `$(BuildRoot)`, to the product- or project-specific top-level makefile to which make goals will be dispatched for this product and all of its configurations.

`TargetOS`
: The canonical name of the OS for which the product is being built. For example, `darwin`, `linux`, or `freertos`. If you are building a "host native" product, then this can simply be set to `$(HostOS)`.

`TargetTuple`
: The GNU automake `config.guess`-style tuple of target processor architecture, target vendor, and target operating system. For example, `x86_64-apple-darwin`. If you are building a "host native" product, then this can simply be set to `$(HostTuple)`.

`ToolVendor`
: The target toolchain vendor being used to build your product, for example `gnu`. If you cannot find a supported vendor in _make/target/tools/..._ under the nuovations-build-make repository, you can create your own. More information on how to do that can be found below.

`ToolProduct`
: The target toolchain product being used to build your product, for example `gcc`. If you cannot find a supported product in _make/target/tools/..._ under the nuovations-build-make repository, you can create your own. More information on how to do that can be found below.

`ToolVersion`
: The target toolchain version being used to build your product, for example `9.x.x`. If you cannot find a supported version in _make/target/tools/..._ under the nuovations-build-make repository, you can create your own. More information on how to do that can be found below.

Everything else is optional and project- and/or product-specific. The
templates created by `mkskeleton` set up some C and C++ compiler flags.
As project and product maintainer, you are free to remove, elaborate on,
or leave these as-is.

### Target Tool

### Configuration

## Makefiles

The _examples_ project provided in the top-level of the nuovations-build-make
repository will likely provide inspiring examples for most of the use cases
below.

As shown in those examples and as intimated above, most of the below use cases
can be arbitrarily combined into a single makefile or broken out across separate
makefiles. The right choice is ultimately up to you as project and product
maintainer.

Regardless of the content, all standalone makefiles in the project are "bookended"
at the top and bottom with these makefile headers:

```
include pre.mak

...

include post.mak
```

As appropriate, you are free to place content above and below these `include`
directives; however, in most cases, the bulk of your makefile content should
fall between these two "bookends".

### Product or Project

As noted above for the `BuildProductTopMakefile` makefile variable set in each
product makefile "header", it references the absolute path of the makefile to
which any build make target goal is dispatched.

You may have one such makefile for all products in your project, a unique makefile
per product, or something in between.

Regardless, the contents of this makefile contain what make should build for your
product, including the dependencies. This might be as simple as a single artifact
like an archive or shared library or as complex as many such libraries, executable
programs, a boot loader, an operating system kernel, a root file system images,
and software update images.

### Archive Library

TBD

### Shared Library

TBD

### Executable Program

TBD

### Executable Image

TBD

### Recursive

TBD

### Third-party

TBD

### Other

TBD

