## Table of Contents
-   [Tasks](#tasks)

## Tasks

Long-term

1.  File-system encryption

    1.  practice this on new phyiscal system in September

    2.  practice this on virtual machine with new `dotfiles` workflows
        as well

    3.  reinstall arch on own hardware with encrypted version

    4.  add this information to readme pre-monix

2.  Clean, sync and verify

    1.  implement cleaning of `yay` caches with paccache:
        <https://github.com/Jguer/yay/issues/772>

    2.  think about adding `sync` functionality in case tests fail,
        which automatically corrects tests instead of expecting the user
        to do this manually

    3.  test all of these changes with virtual machine, but try to keep
        cache of packages instead of always re-installing -\> think of
        the best way to do this, maybe with a shared folder

3.  Installation workflow

    1.  EITHER consider replacing `cp` with `rsync`, which can preserve
        directory trees -\> can encode directories similar to `stow` but
        with hard files instead of links

    2.  OR consider combining home and root partitions, such that `stow`
        can be used with symlinks

        1.  need to think more about the practicality and necessity of
            this

        2.  perhaps hard-copies are enough since root-level
            configuration files are not likely to change

4.  Downgrade

    1.  add pacman hook to update downgraded packages when feature is
        available upstream

    2.  add workflow to install `downgrade` packages from a file when
        available upstream

        1.  add conditional when installing to check array is not empty

        2.  add conditional to do an emptiness check for `pip` packages
            as well

    3.  add a new test suite to check for downgraded packages sanity

5.  Packages

    1.  look through `pacman` package list and remove unnecessary
        packages
