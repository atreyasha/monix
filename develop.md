## Table of Contents
-   [Tasks](#tasks)
    -   [Migration to NixOS by emulating current
        build](#migration-to-nixos-by-emulating-current-build)
    -   [Backup](#backup)
-   [Reproduction logs for Arch
    Linux](#reproduction-logs-for-arch-linux)
    -   [pacman hooks](#pacman-hooks)
    -   [linux-lts](#linux-lts)
    -   [sudo](#sudo)
    -   [beep](#beep)
    -   [tlp-runner](#tlp-runner)
    -   [light](#light)
    -   [mesa-video-driver](#mesa-video-driver)
    -   [udev-battery-rules](#udev-battery-rules)
    -   [ufw-firewall](#ufw-firewall)
    -   [openssh](#openssh)
    -   [gnupg](#gnupg)
    -   [acpi-audio-jack](#acpi-audio-jack)
    -   [i3-cycle](#i3-cycle)
    -   [pre-sleep-i3lock](#pre-sleep-i3lock)
    -   [early-kms](#early-kms)
    -   [timesync](#timesync)
    -   [fonts](#fonts)
    -   [zsh](#zsh)
    -   [avahi and cups](#avahi-and-cups)

## Tasks

### Migration to NixOS by emulating current build

1.  **TODO** sort out clipboard pasting into guest system -\>
    faster configs

2.  **TODO** figure out guest additions inside virtualbox
    basic image

3.  add dbus instructions to `.xinitrc`: <https://nixos.wiki/wiki/I3>

4.  figure out how to keep only recent builds and not all

### Backup

1.  re-arrange system to keep personal data in single location, which
    should be backed up regularly

## Reproduction logs for Arch Linux

### pacman hooks

1.  use `pacdiff -o` for checking differences in configuration files

2.  use `paccache -rvk2` to only keep last two caches

### linux-lts

1.  install `linux-lts`{.verbatim} and uninstall `linux`{.verbatim} to
    overcome occasional dark display upon waking from sleep with DP
    monitor

2.  error message:
    `kernel: i915 0000:00:02.0: [drm] *ERROR* failed to enable link training`{.verbatim}

3.  this bug has not occurred with linux-lts, some discussion shows this
    could be a resolution: see
    <https://bbs.archlinux.org/viewtopic.php?id=196370> and
    <https://www.reddit.com/r/archlinux/comments/4oa926/new_install_intel_dp_start_link_train_i915_failed/>

### sudo

1.  install `sudo`{.verbatim}

2.  add or uncomment the following
    `%wheel      ALL=(ALL) ALL`{.verbatim} to allow for wheel users to
    access sudo

3.  use `visudo`{.verbatim} to prevent any syntax errors

### beep

1.  disable analog beep
    `sudo echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf`{.verbatim}

### tlp-runner

1.  instal `tlp`{.verbatim}

2.  copy existing `tlp.conf`{.verbatim} to `/etc/tlp.conf`{.verbatim}
    for disabling bluetooth, wifi and wwan at startup

3.  run `sudo systemctl enable tlp.service`{.verbatim} and
    `sudo systemctl start tlp.service`{.verbatim}

### light

1.  install `light`{.verbatim} for managing backlight

2.  add local user to `video`{.verbatim} group by running
    `usermod -a -G video shankar`{.verbatim}

### mesa-video-driver

1.  install `mesa`{.verbatim} package and avoid
    `xf86-video-intel`{.verbatim}

### udev-battery-rules

1.  copy `60-onbattery.rules`{.verbatim} and
    `61-onpower.rules`{.verbatim} to `/etc/udev/rules.d`{.verbatim}

2.  reload rules `sudo udevadm control --reload`{.verbatim}

### ufw-firewall

1.  install `ufw`{.verbatim}

2.  retain default settings that deny incoming requests while allowing
    outgoing

3.  run `sudo systemctl enable ufw.service`{.verbatim} and
    `sudo systemctl start ufw.service`{.verbatim}

4.  run `sudo ufw enable`{.verbatim} to enable it outside systemd

### openssh

1.  install `openssh`{.verbatim}

2.  run `systemctl --user enable ssh-agent.service`{.verbatim} and
    `systemctl --user start ssh-agent.service`{.verbatim} on local file

3.  `SSH_AUTH_SOCK`{.verbatim} environmental variable needs to be set in
    shellrc

4.  stow `~/.ssh/config`{.verbatim} with instructions for adding keys to
    ssh agent

### gnupg

1.  install `gnupg`{.verbatim}

2.  stow `~/.gnupg/gpg-agent`{.verbatim} to get relevant agent
    functionalities and cached keys

### acpi-audio-jack

1.  install `acpid`{.verbatim}

2.  copy `audio_jack`{.verbatim} to `/etc/acpi/events`{.verbatim}

3.  run `sudo sytemctl enable acpid.service`{.verbatim} and
    `sudo sytemctl start acpid.service`{.verbatim}

### i3-cycle

1.  run `pip install --user i3-cycle`{.verbatim}

2.  move raw python script to `~/bin`{.verbatim} because installed
    script gets slowed down due to path regexes

### pre-sleep-i3lock

1.  all i3lock scripts have `sleep 0.1`{.verbatim} to prevent i3 mode
    red color from being captured in screenshot

2.  i3lock post-suspend requires `sleep 1`{.verbatim} to prevent short
    real display

3.  i3lock uses no forking `-n`{.verbatim} for simple lock to ensure it
    does not work in background; this allows dpms changes to persist
    until unlock

4.  i3lock was tested with concurrent lock and suspend, and there is a
    PID check to ensure no double i3locks are created

5.  copy `pre-sleep@.service`{.verbatim} to
    `/etc/systemd/system`{.verbatim}

6.  run `sudo systemctl enable pre-sleep@$USER.service`{.verbatim},
    remember to replace `$USER`{.verbatim} with the actual user

7.  suspension after i3lock is delayed if less than or equal to 10
    seconds are left before dpms down -\> not sure about this but it is
    possible

8.  **buggy, needs more testing:**
    `xset -display :0 dpms force on`{.verbatim} to ensure screen lights
    up after suspend, in case it was locked and dimmed earlier

### early-kms

1.  add `MODULES=(intel_agp i915)`{.verbatim} to
    `/etc/mkinitcpio.conf`{.verbatim}

2.  run `sudo mkinitcpio -P`{.verbatim}

### timesync

1.  run `sudo systemctl enable systemd-timesyncd.service`{.verbatim} in
    order to sync time

### fonts

1.  install `ttf-dejavu`{.verbatim}, `ttf-font-awesome`{.verbatim},
    `otf-font-awesome`{.verbatim} and AUR
    `nerd-fonts-bitstream-vera-mono`{.verbatim} for terminal font

2.  update cache using `fc-cache -fv`{.verbatim}

3.  i3 uses fc-match to find best font which mostly ends up defaulting
    to `DejaVu Sans`{.verbatim}, which is why it appears as a default

### zsh

1.  install `zsh`{.verbatim} and use as main shell with
    `chsh -s /usr/bin/zsh`{.verbatim}

### avahi and cups

1.  systemd-level services need to be initialized for this
