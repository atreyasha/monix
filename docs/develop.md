## Table of Contents
-   [Tasks](#tasks)

## Tasks

Next

1.  **TODO** add `sync` target to monix and private makefiles
    which can sync certain files that need to be copied

2.  **TODO** manually create basic directories such as
    `downloads` and `desktop` directory for qutebrowser

3.  File-system encryption

    1.  practice this on virtual machine first and then migrate to real
        hardware

    2.  reinstall arch on own hardware with encrypted version

    3.  add this information to readme pre-monix

Long-term

1.  Downgrade-related

    1.  add hook to automatically track downgraded packages as well and
        add conditional when installing them to check if the array is
        not empty -\> coordinate with `downgrade`

    2.  add a new test suite to check for downgraded packages

2.  Pacman hooks

    1.  possibly add pacman hook to update package lists + `pip` in
        `monix`:
        <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages>

    2.  add a test hook after every system update to ensure tracked
        files are the same -\> think of how to update configuration
        files in both directions seamlessly

    3.  add a hook to convert all optional (non-true) orphans to
        explicit packages -\> or at least to check them after each
        upgrade -\> `pacman -Qttdq`

3.  Backup

    1.  reduce size of `personal` directory to keep only important data

    2.  optimize an elegant and portable backup scheduling of the
        `personal` directory

    3.  perhaps use tarballs with `rsync` to ensure only relevant data
        is updated

    4.  think of separating important and unimportant data -\> only back
        up the important data

    5.  organize drive to ensure backups all make good sense
