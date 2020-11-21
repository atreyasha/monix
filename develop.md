## Table of Contents
-   [Tasks](#tasks)
    -   [System reproducibility](#system-reproducibility)
-   [System reproduction logs after basic Arch
    installation](#system-reproduction-logs-after-basic-arch-installation)
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
-   [Completed](#completed)

Tasks
-----

### System reproducibility

1.  **TODO** work on script which returns arch linux OS state
    to current state using package list backups, dotfile installation
    scheme and notes for important steps taken from experience -\> test
    this with virtual machine -\> perhaps each update backs up package
    list as well

2.  root files need to be added via hard files, use gnu install for
    those commands, make simple root install script which uses directory
    structure for installs

3.  figure how to dump all package names and associated systemd rules
    which need to be recreated

System reproduction logs after basic Arch installation
------------------------------------------------------

### linux-lts

1.  install `linux-lts` and uninstall `linux` to overcome occasional
    dark display upon waking from sleep with DP monitor

2.  error message:
    `kernel: i915 0000:00:02.0: [drm] *ERROR* failed to enable link training`

3.  this bug has not occurred with linux-lts, some discussion shows this
    could be a resolution: see
    <https://bbs.archlinux.org/viewtopic.php?id=196370> and
    <https://www.reddit.com/r/archlinux/comments/4oa926/new_install_intel_dp_start_link_train_i915_failed/>

### sudo

1.  install `sudo`

2.  add or uncomment the following `%wheel      ALL=(ALL) ALL` to allow
    for wheel users to access sudo

3.  use `visudo` to prevent any syntax errors

### beep

1.  disable analog beep
    `sudo echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf`

### tlp-runner

1.  instal `tlp`

2.  copy existing `tlp.conf` to `/etc/tlp.conf` for disabling bluetooth,
    wifi and wwan at startup

3.  run `sudo systemctl enable tlp.service` and
    `sudo systemctl start tlp.service`

### light

1.  install `light` for managing backlight

2.  add local user to `video` group by running
    `usermod -a -G video shankar`

### mesa-video-driver

1.  install `mesa` package and avoid `xf86-video-intel`

### udev-battery-rules

1.  copy `60-onbattery.rules` and `61-onpower.rules` to
    `/etc/udev/rules.d`

2.  reload rules `sudo udevadm control --reload`

### ufw-firewall

1.  install `ufw`

2.  retain default settings that deny incoming requests while allowing
    outgoing

3.  run `sudo systemctl enable ufw.service` and
    `sudo systemctl start ufw.service`

4.  run `sudo ufw enable` to enable it outside systemd

### openssh

1.  install `openssh`

2.  run `systemctl --user enable ssh-agent.service` and
    `systemctl --user start ssh-agent.service` on local file

3.  `SSH_AUTH_SOCK` environmental variable needs to be set in shellrc

4.  stow `~/.ssh/config` with instructions for adding keys to ssh agent

### gnupg

1.  install `gnupg`

2.  stow `~/.gnupg/gpg-agent` to get relevant agent functionalities and
    cached keys

### acpi-audio-jack

1.  install `acpid`

2.  copy `audio_jack` to `/etc/acpi/events`

3.  run `sudo sytemctl enable acpid.service` and
    `sudo sytemctl start acpid.service`

### i3-cycle

1.  run `pip install --user i3-cycle`

2.  move raw python script to `~/bin` because installed script gets
    slowed down due to path regexes

### pre-sleep-i3lock

1.  all i3lock scripts have `sleep 0.1` to prevent i3 mode red color
    from being captured in screenshot

2.  i3lock post-suspend requires `sleep 1` to prevent short real display

3.  i3lock uses no forking `-n` for simple lock to ensure it does not
    work in background; this allows dpms changes to persist until unlock

4.  i3lock was tested with concurrent lock and suspend, and there is a
    PID check to ensure no double i3locks are created

5.  copy `pre-sleep@.service` to `/etc/systemd/system`

6.  run `sudo systemctl enable pre-sleep@$USER.service`, remember to
    replace `$USER` with the actual user

7.  suspension after i3lock is delayed if less than or equal to 10
    seconds are left before dpms down -\> not sure about this but it is
    possible

8.  **buggy, needs more testing:** `xset -display :0 dpms force on` to
    ensure screen lights up after suspend, in case it was locked and
    dimmed earlier

### early-kms

1.  add `MODULES=(intel_agp i915)` to `/etc/mkinitcpio.conf`

2.  run `sudo mkinitcpio -P`

### timesync

1.  run `sudo systemctl enable systemd-timesyncd.service` in order to
    sync time

### fonts

1.  install `ttf-dejavu`, `ttf-font-awesome`, `otf-font-awesome` and AUR
    `nerd-fonts-bitstream-vera-mono` for terminal font

2.  update cache using `fc-cache -fv`

3.  i3 uses fc-match to find best font which mostly ends up defaulting
    to `DejaVu Sans`, which is why it appears as a default

### zsh

1.  install `zsh` and use as main shell with `chsh -s /usr/bin/zsh`

Completed
---------

**DONE** replace udev rules with local script location for
portability

**CLOSED:** *\[2020-11-12 Thu 14:12\]*
