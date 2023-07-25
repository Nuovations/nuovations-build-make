# Changes, Release Notes, and What's New

## Nuovations Build (Make)

#### 0.9.13d (2023-07-25)

    * Added the `-t` batch flag to patch to avoid hanging builds with
      interactive user input prompts.

    * Added the `copy-and-enable-user-executable` and
      `copy-and-enable-user-executable-result` macros. These copy a
      regular file and enable user execute permissions on the
      destination. These are most commonly used for scripts (for
      example, bash, perl, python, etc.).

#### 0.9.12d (2023-06-24)

    * Addressed an issue in which linker resolve path arguments did
      not work correctly with GCC and GCC-based toolchains.

#### 0.9.11d (2023-06-16)

    * Addressed an issue in which the 'snapshot' third-party package
      target did not work correctly when there was more than one build
      job.

#### 0.9.10d (2023-05-19)

    * Addressed a portability issue with the 'monte' examples program
      under iOS/macOS/tvOS (Darwin).

#### 0.9.9d (2023-04-11)

    * Optimized the performance of build iteration, particularly under
      Darwin / macOS.

    * Addressed an issue in which a third-party package version was
      not correctly evaluated when using a `<package>.version` file.

    * Addressed issues with `IsYes` and `IsNo` in which a variable set
      to `1` or `0` would not correctly evaluate to `Y` or `N`,
      respectively.

    * Changed `BuildMode` to `PackageBuildMode` and assigned it a
      default value of `stage` to avoid undefined variable warnings.

#### 0.9.8d (2023-04-11)

    * Resolved an issue when building against Apple clang/LLVM with
      linking shared libraries.

    * Replaced the deprecated `std::random_shuffle` with
      `std::shuffle` in the _monte_ example.

    * Addressed an issue when making a distribution of Nuovations
      Build (Make) by defaulting to the POSIX 2001 `pax` tar format
      rather than the legacy `v7` format.

    * Ensure that both `{Host,Target}Tool{Vendor,Product,Version}` are
      defined in the examples project reflective of the new
      requirements established in 0.9.7d.

    * Leverage `INSTALL` and `INSTALLFLAGS` for `host-install-result`.

    * Exclusively leverage variables for `distcleanall` top-level
      target and add verbose progress output.

    * Fixed (added) the `distclean` action for a specific
      configuration for all products. So, for example, `make
      distclean-relese` now works correctly.

#### 0.9.7d (2023-04-06)

    * Added parallel host- and target-qualified variables, macros, and
      functions to lay the groundwork for supporting host- or
      target-specific builds with the eventual goal of supporting both
      side-by-side.

      - Added checks to ensure that the host OS and the host- and
        target-qualified tool tuples are set. Default the unqualified
        tool tuple values to their target instances.

    * Added a default value for 'BuildVerbose' of 'No'.

#### 0.9.6d (2023-04-06)

    * Added support for a 'PackageRoot', defaulting to the current
      directory, for third-party archive or source packages. This
      allows makefile(s) for the package and the metadata and archive
      or source to be in disparate locations.

    * Addressed an issue in which 'clean' and 'distclean' targets
      would fail due to missing files or directories. Ensure that such
      errors are always ignored in their target recipes.

#### 0.9.5d (2023-04-04)

    * Added two functions, 'create-symlink' and
      'create-symlink-result' for creating a symbolic link from a name
      to a target destination.

    * Addressed an issue where the 'make-submakefile' function was not
      correctly handling both absolute and relative makefile paths
      when displaying verbose progress output.

#### 0.9.4d (2023-02-27)

    * Added support for generating monotonically-increasing, per-target
      build generation numbers. This addressed an issue in which targets
      would always be out of date due to the absence of this support.

#### 0.9.3d (2023-02-22)

    * Addressed an issue in setup.sh where basename issues an error
      under certain shells that it was provided with no argument.

#### 0.9.2d (2023-02-21)

    * Added implicit rules for transforming output from auto-generated
      source files in the build directory.

#### 0.9.1d (2023-02-21)

    * Ensure that the top-level makefile, 'Makefile', is present as an
      additional test for establishing BuildRoot when setting up the shell
      environment.

    * When setting up the shell environment, refine the method by which the
      first directory path iterator is derived such that it is compatible with
      bash, dash, ksh, sh, and zsh.

    * Addressed three documentation typos in GETTING_STARTED.md.

#### 0.9.0d (2023-02-20)

    * First public, open-source release.
