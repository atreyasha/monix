## Table of Contents
-   [Tasks](#tasks)
    -   [Arch linux reproducibility
        script](#arch-linux-reproducibility-script)

## Tasks

### Arch linux reproducibility script

1.  Specific extra minimal tasks

    1.  **TODO** add `sync` target to monix and private
        makefiles which can sync certain files that need to be copied

    2.  **TODO** find a way to manually create `downloads`
        from qutebrowser, or do it while creating filesystem structure

    3.  **TODO** deploy all private files from private repo,
        or think of secure way to handle this -\> adjust `dotfiles` as
        well since GPG key is needed to commit

2.  Next tasks

    1.  make script work such that re-installing can be done harmlessly
        even on fully installed system

    2.  add hook to automatically track downgraded packages as well and
        add conditional when installing them to check if the array is
        not empty -\> coordinate with `downgrade`

    3.  add a new test suite to check for downgraded packages

    4.  possibly add pacman hook to update package lists + `pip` in
        `monix`:
        <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages>

    5.  add a test hook after every system update to ensure tracked
        files are the same -\> think of how to update configuration
        files in both directions seamlessly

    6.  add a hook to convert all optional (non-true) orphans to
        explicit packages -\> or at least to check them after each
        upgrade -\> `pacman -Qttdq`

3.  Backup

    1.  figure out how to restore `personal` data

    2.  figure out how to restore private dotfiles like `neomutt`,
        `ssh`, `gnupg` and `pass` files -\> to fully emulate current
        distribution

    3.  re-arrange system to keep personal data in single location,
        which should be backed up regularly
