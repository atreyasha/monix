#!/usr/bin/env bats
# -*- mode: shell-script -*-
# vim: syntax=sh

# check for VM and assign variable
grep "hypervisor" "/proc/cpuinfo" &>/dev/null && VM="1" || VM="0"

@test "checking yay" {
  pacman -Qi yay
}

@test "checking pacman_native_pkgs" {
  status="$(pacman -Qqen | xargs)"
  compare="$(cat pkg/pacman_native | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking pacman_foreign_pkgs" {
  status="$(pacman -Qqem | xargs)"
  compare="$(cat pkg/pacman_foreign | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking pip_pkgs" {
  status="$(pip freeze --user | xargs)"
  compare="$(cat pkg/requirements.txt | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking ufw" {
  systemctl is-enabled ufw.service
  systemctl is-active ufw.service
  status="$(sudo ufw status verbose | xargs)"
  compare="$(cat test/fixtures/ufw_status | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking zsh" {
  shell="$(getent passwd $USER | cut -d: -f7)"
  [ "$shell" = "/usr/bin/zsh" ]
}

@test "checking networkmanager" {
  systemctl is-enabled NetworkManager.service
  systemctl is-active NetworkManager.service
}

@test "checking timesync" {
  systemctl is-enabled systemd-timesyncd.service
  systemctl is-active systemd-timesyncd.service
  status="$(timedatectl show -p NTP)"
  compare="$(cat test/fixtures/timedatectl_ntp | xargs)"
  if ((!VM)); then
    [ "$status" = "$compare" ]
  fi
}

@test "checking disable_beep" {
  [ "blacklist pcspkr" = "$(cat /etc/modprobe.d/nobeep.conf)" ]
}

@test "checking light" {
  groups=($(groups $USER))
  for group in "${groups[@]}"; do
    if [ "$group" = "video" ]; then
      return 0
    fi
  done
  return 1
}

@test "checking tlp" {
  systemctl is-enabled tlp.service
  systemctl is-active tlp.service
  cmp "conf/tlp.conf" "/etc/tlp.conf"
}

@test "checking udev" {
  cmp "conf/60-onbattery.rules" "/etc/udev/rules.d/60-onbattery.rules"
  cmp "conf/61-onpower.rules" "/etc/udev/rules.d/61-onpower.rules"
}

@test "checking acpi" {
  systemctl is-enabled acpid.service
  systemctl is-active acpid.service
  cmp "conf/audio_jack" "/etc/acpi/events/audio_jack"
}

@test "checking systemd_pre_sleep" {
  systemctl is-enabled "pre-sleep@$USER.service"
  cmp "conf/pre-sleep@.service" "/etc/systemd/system/pre-sleep@.service"
}

@test "checking pacman_hooks" {
  status="$(envsubst < conf/1-packages.hook | xargs)"
  compare="$(cat /etc/pacman.d/hooks/1-packages.hook | xargs)"
  [ "$status" = "$compare" ]
  cmp "conf/2-paccache.hook" "/etc/pacman.d/hooks/2-paccache.hook"
  cmp "conf/3-orphans.hook" "/etc/pacman.d/hooks/3-orphans.hook"
  cmp "conf/4-pacdiff.hook" "/etc/pacman.d/hooks/4-pacdiff.hook"
}

@test "checking downgrade_conf" {
  status="$(envsubst < conf/downgrade.conf | xargs)"
  compare="$(cat /etc/xdg/downgrade/downgrade.conf | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking base_dirs" {
  [ -d "$HOME/desktop/personal" ]
  [ -d "$HOME/downloads" ]
}

@test "checking localectl" {
  status="$(localectl | xargs)"
  compare="$(cat test/fixtures/localectl | xargs)"
  [ "$status" = "$compare" ]
}
