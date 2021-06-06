## Table of Contents
-   [Tasks](#tasks)
    -   [Arch linux reproducibility
        script](#arch-linux-reproducibility-script)
-   [Reproduction logs for Arch
    Linux](#reproduction-logs-for-arch-linux)
    -   [pacman](#pacman)
    -   [network manager](#network-manager)
    -   [beep](#beep)
    -   [tlp-runner](#tlp-runner)
    -   [light](#light)
    -   [udev-battery-rules](#udev-battery-rules)
    -   [ufw-firewall](#ufw-firewall)
    -   [acpi-audio-jack](#acpi-audio-jack)
    -   [i3-cycle](#i3-cycle)
    -   [pre-sleep-i3lock](#pre-sleep-i3lock)
    -   [timesync](#timesync)
    -   [zsh](#zsh)
    -   [avahi and cups](#avahi-and-cups)
    -   [virtualization setup -\> read Arch Wiki to confirm if anything
        must be
        done](#virtualization-setup---read-arch-wiki-to-confirm-if-anything-must-be-done)

## Tasks

### Arch linux reproducibility script

1.  Specific tasks

    1.  **TODO** installation steps via `Makefile`

        1.  enable network manager to ensure it works on reboot

        2.  git clone and install yay manually with makepkg

        3.  install all packages using yay -\> add option to ignore all
            prompts

        4.  downgrade picom afterwards to 7.5-3 with --ala-only option

        5.  install all python files

        6.  update all configuration files from system defaults

        7.  go through modular steps and install configuration files +
            enable systemd services

        8.  get all private files from private repo as well

    2.  reboot after installation

2.  High-level concepts

    1.  make script work such that re-installing can be done harmlessly
        even on fully installed system

    2.  make script easily maintainable with cronjobs which update
        packages and perform other book-keeping tasks

    3.  keep package list updated in this repository, as well as other
        workflows

    4.  add test suites to build repo which tests for necessary
        variables and runs

    5.  replace user-level python packages from installation when we
        find AUR alternatives to them

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

4.  possibly other hooks for systemm updates -\> this can happen later
    on

### network manager

1.  run `sudo systemctl enable NetworkManager.service`{.verbatim} and
    `sudo systemctl start NetworkManager.service`{.verbatim}

### beep

1.  disable analog beep
    `sudo echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf`{.verbatim}

### tlp-runner

1.  copy existing `tlp.conf`{.verbatim} to `/etc/tlp.conf`{.verbatim}
    for disabling bluetooth, wifi and wwan at startup

2.  run `sudo systemctl enable tlp.service`{.verbatim} and
    `sudo systemctl start tlp.service`{.verbatim}

### light

1.  add local user to `video`{.verbatim} group by running
    `usermod -a -G video shankar`{.verbatim}

### udev-battery-rules

1.  copy `60-onbattery.rules`{.verbatim} and
    `61-onpower.rules`{.verbatim} to `/etc/udev/rules.d`{.verbatim}

2.  reload rules `sudo udevadm control --reload`{.verbatim}

### ufw-firewall

1.  copy config file

2.  retain default settings that deny incoming requests while allowing
    outgoing

3.  run `sudo systemctl enable ufw.service`{.verbatim} and
    `sudo systemctl start ufw.service`{.verbatim}

4.  run `sudo ufw enable`{.verbatim} to enable it outside systemd

### acpi-audio-jack

1.  copy `audio_jack`{.verbatim} to `/etc/acpi/events`{.verbatim}

2.  run `sudo sytemctl enable acpid.service`{.verbatim} and
    `sudo sytemctl start acpid.service`{.verbatim}

### i3-cycle

1.  run `pip install --user i3-cycle`{.verbatim}

### pre-sleep-i3lock

1.  copy `pre-sleep@.service`{.verbatim} to
    `/etc/systemd/system`{.verbatim}

2.  run `sudo systemctl enable pre-sleep@$USER.service`{.verbatim},
    remember to replace `$USER`{.verbatim} with the actual user

### timesync

1.  run `sudo systemctl enable systemd-timesyncd.service`{.verbatim} in
    order to sync time

### zsh

1.  use as main shell with `chsh -s /usr/bin/zsh`{.verbatim}

### avahi and cups

1.  systemd-level services need to be initialized for this

### virtualization setup -\> read Arch Wiki to confirm if anything must be done
