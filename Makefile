ACPI    ?= /etc/acpi/events
SYSTEMD ?= /etc/systemd/system
UDEV    ?= /etc/udev/rules.d

.PHONY: yay
yay:
	tmp="$$(mktemp -d)"
	git clone "https://aur.archlinux.org/yay.git" "$$tmp"
	cd "$$tmp/yay"
	makepkg -si --noconfirm

.PHONY: pacman_native_pkgs
pacman_native_pkgs:
	pacman -S --needed --noconfirm - < pkg/pacman_native

.PHONY: pacman_foreign_pkgs
 pacman_foreign_pkgs:
	yay -S --needed --noconfirm - < pkg/pacman_foreign

.PHONY: downgrade_pkgs
downgrade_pkgs:
	echo y | downgrade --ala-only picom=7.5-3 -- --noconfirm

.PHONY: pip_pkgs
pip_pkgs:
	pip install --user -r pkg/requirements.txt

.PHONY: zsh
zsh:
	chsh -s /usr/bin/zsh

.PHONY: networkmanager
networkmanager:
	systemctl enable NetworkManager.service

.PHONY: timesync
timesync:
	systemctl enable systemd-timesyncd.service

.PHONY: disable_beep
disable_beep:
	echo "blacklist pcspkr" > "/etc/modprobe.d/nobeep.conf"

.PHONY: light
light:
	usermod -a -G "video" "$$USER"

.PHONY: tlp
tlp:
	install -m644 config/tlp.conf /etc/tlp.conf
	systemctl enable tlp.service

.PHONY: udev
udev:
	install -Dm644 config/60-onbattery.rules $(UDEV)/60-onbattery.rules
	install -Dm644 config/61-onpower.rules $(UDEV)/61-onpower.rules
	udevadm control --reload

.PHONY: acpi
acpi:
	install -Dm644 config/audio_jack $(ACPI)/audio_jack
	sudo sytemctl enable acpid.service

.PHONY: systemd_pre_sleep
systemd_pre_sleep:
	install -Dm644 config/pre-sleep@.service $(SYSTEMD)/pre-sleep@.service
	systemctl enable "pre-sleep@$$USER.service"
