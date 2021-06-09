## Table of Contents
-   [Tasks](#tasks)
    -   [Arch linux reproducibility
        script](#arch-linux-reproducibility-script)
-   [Reproduction logs for Arch
    Linux](#reproduction-logs-for-arch-linux)
    -   [pacman](#pacman)
    -   [virtualization setup -\> read Arch Wiki to confirm if anything
        must be
        done](#virtualization-setup---read-arch-wiki-to-confirm-if-anything-must-be-done)
    -   [ufw-firewall](#ufw-firewall)

## Tasks

### Arch linux reproducibility script

1.  Specific tasks

    1.  **TODO** update all configuration files from system
        defaults -\> think about which ones are truly needed

    2.  **TODO** install configuration files + enable systemd
        services + other commands below

    3.  **DONE** install all python dependencies

        **CLOSED:** *\[2021-06-08 Tue 16:49\]*

    4.  **DONE** downgrade picom afterwards to 7.5-3 with
        --ala-only, --noconfim and yes

        **CLOSED:** *\[2021-06-08 Tue 16:48\]*

    5.  **DONE** install all packages using yay -\> add
        option to ignore all prompts, ignore confirmations

        **CLOSED:** *\[2021-06-08 Tue 16:45\]*

    6.  **DONE** git clone and install yay manually with
        makepkg

        **CLOSED:** *\[2021-06-08 Tue 16:26\]*

    7.  **DONE** enable network manager to ensure it works on
        reboot

        **CLOSED:** *\[2021-06-08 Tue 16:22\]*

    8.  add test suites to build repo which tests for necessary
        variables and runs

    9.  get all private files from private repo as well

    10. reboot after installation

2.  Next tasks

    1.  make script work such that re-installing can be done harmlessly
        even on fully installed system

    2.  add hook to automatically track downgraded packages as well and
        add conditional when installing them to check if the array is
        not empty

    3.  possibly add pacman hook to update package lists + `pip` in
        `monix`:
        <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages>

    4.  add a test hook after every system update to ensure tracked
        files are the same -\> think of how to update configuration
        files in both directions seamlessly

3.  Backup

    1.  figure out how to restore `personal` data

    2.  figure out how to restore private dotfiles like `neomutt`,
        `ssh`, `gnupg` and `pass` files -\> to fully emulate current
        distribution

    3.  re-arrange system to keep personal data in single location,
        which should be backed up regularly

## Reproduction logs for Arch Linux

### pacman

1.  need to export specific files for this, including `pacman.conf` and
    `pacman.d/*`

2.  use `pacdiff -o` for checking differences in configuration files

3.  use `paccache -rvk2` to only keep last two caches

### virtualization setup -\> read Arch Wiki to confirm if anything must be done

### ufw-firewall

1.  copy config file

2.  retain default settings that deny incoming requests while allowing
    outgoing

3.  run `sudo systemctl enable ufw.service`{.verbatim}, might need to be
    started as well

4.  run `sudo ufw enable`{.verbatim} to enable it outside systemd
