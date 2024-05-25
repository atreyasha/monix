#!/usr/bin/env bats
# -*- mode: shell-script -*-
# vim: syntax=sh

# include function to check for group membership
check_group_membership() {
  local against="$1"
  groups=($(groups "$USER"))
  for group in "${groups[@]}"; do
    if [ "$group" = "$against" ]; then
      return 0
    fi
  done
  return 1
}

check_unit_is_masked(){
  local service="$1"
  systemctl status "$service" | \
    grep "Loaded: masked" &>/dev/null
}

# check for VM and assign variable
grep "hypervisor" "/proc/cpuinfo" &>/dev/null && VM="1" || VM="0"

@test "checking yay" {
  pacman -Qi yay
}

@test "checking pacman_hooks" {
  status="$(envsubst < conf/1-packages.hook | xargs)"
  compare="$(cat /etc/pacman.d/hooks/1-packages.hook | xargs)"
  [ "$status" = "$compare" ]
  cmp "conf/2-paccache.hook" "/etc/pacman.d/hooks/2-paccache.hook"
  cmp "conf/3-orphans.hook" "/etc/pacman.d/hooks/3-orphans.hook"
  cmp "conf/4-pacdiff.hook" "/etc/pacman.d/hooks/4-pacdiff.hook"
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

@test "checking downgrade_conf" {
  status="$(envsubst < conf/downgrade.conf | xargs)"
  compare="$(cat /etc/xdg/downgrade/downgrade.conf | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking pip_pkgs" {
  status="$(pip freeze --user | xargs)"
  compare="$(cat pkg/requirements.txt | xargs)"
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
  check_group_membership "video"
}

@test "checking tlp" {
  cmp "conf/tlp.conf" "/etc/tlp.conf"
  systemctl is-enabled tlp.service
  systemctl is-active tlp.service
  check_unit_is_masked systemd-rfkill.service
  check_unit_is_masked systemd-rfkill.socket
}

@test "checking base_dirs" {
  [ -d "$HOME/desktop" ]
  [ -d "$HOME/downloads" ]
}

@test "checking localectl" {
  status="$(localectl | xargs)"
  compare="$(cat test/fixtures/localectl | xargs)"
  [ "$status" = "$compare" ]
}

@test "checking vbox" {
  vboxmanage list systemproperties | grep -E '^Default machine folder:\s+'"$HOME"'/vbox$'
  check_group_membership "vboxusers"
}

@test "checking docker" {
  systemctl is-enabled docker.service
  systemctl is-active docker.service
  check_group_membership "docker"
}

@test "checking microcode updates" {
  sudo grep -E 'initrd\s+[a-z/]+-ucode.img' "/boot/grub/grub.cfg"
}
