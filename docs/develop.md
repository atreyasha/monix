## Table of Contents
-   [Tasks](#tasks)

## Tasks

Long-term

1.  Installation workflow

    1.  EITHER consider replacing `cp` with `rsync`, which can preserve
        directory trees -\> can encode directories similar to `stow` but
        with hard files instead of links

    2.  OR consider combining home and root partitions, such that `stow`
        can be used with symlinks

        1.  need to think more about the practicality and necessity of
            this

        2.  perhaps hard-copies are enough since root-level
            configuration files are not likely to change

2.  Network

    1.  consider changing to another network manager such as `connman`
        for faster boot and resolving

    2.  need to change many scripts in `monix` and `dotfiles` to reflect
        overall changes

3.  File-system encryption

    1.  practice this on new phyiscal system in September

    2.  practice this on virtual machine with new `dotfiles` workflows
        as well

    3.  reinstall arch on own hardware with encrypted version

    4.  add this information to readme pre-monix

    5.  test all of these changes with virtual machine, but try to keep
        cache of packages instead of always re-installing -\> think of
        the best way to do this, maybe with a shared folder

4.  Conf-path management

    1.  think about adding file or directory checks in `systemd`, `udev`
        and `acpi` rules, since these files could be missing if
        `dotfiles` is not used

        1.  maybe `systemd` has a file-existence checking option as a
            requisite

        2.  however, these frameworks will perform error handling well

        3.  handling errors for them could lead to other problems

        4.  best-case scenario would be user-level alternatives, but
            these are likely not possible

        5.  i3blocks persistent queries are not very elegant and perhaps
            a bad use of resources -\> also annoying since changes will
            always occur

5.  General

    1.  Look into slow wifi disabling on login -\> appears to be slowed
        down due to docker booting up

6.  Sync

    1.  think about adding `sync` functionality in case tests fail,
        which automatically corrects tests instead of expecting the user
        to do this manually

        1.  this could help for `pip` packages as well

7.  Downgrade

    1.  add pacman hook to update/log downgraded packages when feature
        is available upstream

    2.  add workflow to install `downgrade` packages from a file when
        available upstream

        1.  add conditional when installing to check array is not empty

        2.  add conditional to do an emptiness check for `pip` packages
            as well

    3.  add a new test suite to check for downgraded packages sanity

8.  Packages and cleaning

    1.  look through `pacman` package list and remove unnecessary
        packages

    2.  modify pacman hook for cleaning of `yay` caches with paccache:
        <https://github.com/Jguer/yay/issues/772>
