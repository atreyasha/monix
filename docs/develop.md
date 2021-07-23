## Table of Contents
-   [Tasks](#tasks)

## Tasks

**TODO** Next

1.  use `localectl` to add X-keyboard-mapping file so it does not get
    forgotten and reset to `us` -\> add this to routines, test and
    readme as well

    1.  consider removing this from `.xinitrc` since it is read from the
        system

    2.  think of which part of `monix` to place this in -\> either
        readme or conf

    3.  test this routine with fixture of `localectl` command -\> this
        should be better than using `setxkbmap` which is only necessary
        within an X session

2.  manually create basic directories such as `downloads` and `desktop`
    directory for qutebrowser

3.  commit `downgrade.conf` to repository as well with its own
    `Makefile` and test routine

4.  add `sync` target to monix and private makefiles which can sync
    certain files that need to be copied

    1.  figure out how to make this interact gracefully with code in
        `test` -\> re-use test cases

Long-term

1.  Repository workflow

    1.  consider replacing `cp` with `rsync`, which can preserve
        directory trees -\> can encode directories similar to `stow` but
        with hard files instead of links

    2.  think about combining home and root partitions, such that
        `monix` can be used effectively with `stow` instead of copied
        files

        1.  need to think more about the practicality and necessity of
            this

        2.  or try repository again using stow to check if things work

2.  File-system encryption

    1.  practice this on virtual machine with new `dotfiles` workflows
        as well

    2.  reinstall arch on own hardware with encrypted version

    3.  add this information to readme pre-monix

3.  Pacman hooks and/or update management scripts in `dotfiles`

    1.  add a hook to convert all optional (non-true) orphans to
        explicit packages -\> or at least to check them after each
        upgrade -\> `pacman -Qttdq`

    2.  **possible duplicate:** add pacman hook to update package
        lists + `pip` in `monix`:
        <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages>

    3.  **possible duplicate:** add a test hook after every system
        update to ensure tracked files are the same -\> think of how to
        update configuration files in both directions seamlessly

4.  Downgrade-related

    1.  add hook to automatically track downgraded packages as well and
        add conditional when installing them to check if the array is
        not empty -\> coordinate with `downgrade`

    2.  this should be synced with update management scripts in
        `dotfiles`

    3.  add a new test suite to check for downgraded packages
