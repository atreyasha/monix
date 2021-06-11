#!/usr/bin/env bats
# -*- mode: shell-script -*-
# vim: syntax=sh

# check for VM and assign variable
grep "hypervisor" /proc/cpuinfo &>/dev/null && VM="1" || VM="0"

@test "checking yay" {
  pacman -Qi yay
}

@test "checking native pacman packages" {
  installed="$(pacman -Qqn | xargs)"
  compare="$(cat pkg/pacman_native | xargs)"
  [ "$installed" = "$compare" ]
}

@test "checking AUR packages" {
  installed="$(pacman -Qqm | xargs)"
  compare="$(cat pkg/pacman_foreign | xargs)"
  [ "$installed" = "$compare" ]
}

@test "checking pypi packages" {
  installed="$(pip freeze --user | xargs)"
  compare="$(cat pkg/requirements.txt | xargs)"
  [ "$installed" = "$compare" ]
}

@test "checking ufw status" {
  systemctl is-enabled ufw.service
  status="$(sudo ufw status verbose | xargs)"
  compare="$(cat test/fixtures/ufw_status | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking zsh default shell" {
  shell="$(getent passwd $USER | cut -d: -f7)"
  [ "$shell" = "/usr/bin/zsh" ]
}

@test "checking networkmanager" {
  systemctl is-enabled NetworkManager.service
}

@test "checking timesync" {
  systemctl is-enabled systemd-timesyncd.service
  status="$(timedatectl show -p NTP)"
  compare="$(cat test/fixtures/timedatectl_ntp | xargs)"
  if ((!VM)); then
    [ "$status" = "$compare" ]
  fi
}

@test "checking disabled beeping" {
  [ "blacklist pcspkr" = "$(cat /etc/modprobe.d/nobeep.conf)" ]
}

@test "checking user's video group" {
  groups=($(groups $USER))
  for group in "${groups[@]}"; do
    if [ "$group" = "video" ]; then
      return 0
    fi
  done
  return 1
}

@test "checking TLP configuration" {
  cmp conf/tlp.conf /etc/tlp.conf
}

@test "checking UDEV rules" {
  cmp conf/60-onbattery.rules /etc/udev/rules.d/60-onbattery.rules
  cmp conf/61-onpower.rules /etc/udev/rules.d/61-onpower.rules
}

@test "checking ACPI audio jack" {
  cmp conf/audio_jack /etc/acpi/events/audio_jack
}

@test "checking systemd pre-sleep hook" {
  cmp conf/pre-sleep@.service /etc/systemd/system/pre-sleep@.service
  systemctl is-enabled "pre-sleep@$USER.service"
}

@test "checking pacman hooks" {
  cmp conf/pacdiff.hook /etc/pacman.d/hooks/pacdiff.hook
  cmp conf/paccache.hook /etc/pacman.d/hooks/paccache.hook
}
