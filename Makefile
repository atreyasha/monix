PACMAN  ?= /etc/pacman.d
ACPI    ?= /etc/acpi/events
SYSTEMD ?= /etc/systemd/system
UDEV    ?= /etc/udev/rules.d
CONF    ?= ./conf
TARGETS =

.PHONY: yay
TARGETS += yay
yay:
	tmp="$$(mktemp -d)"; \
	git clone "https://aur.archlinux.org/yay.git" "$$tmp"; \
	cd "$$tmp/yay"; \
	makepkg -si --noconfirm

.PHONY: pacman_native_pkgs
TARGETS += pacman_native_pkgs
pacman_native_pkgs:
	pacman -S --needed --noconfirm - < pkg/pacman_native

.PHONY: pacman_foreign_pkgs
TARGETS += pacman_foreign_pkgs
pacman_foreign_pkgs:
	yay -S --needed --noconfirm - < pkg/pacman_foreign

.PHONY: downgrade_pkgs
TARGETS += downgrade_pkgs
downgrade_pkgs:
	echo y | downgrade --ala-only picom=7.5-3 -- --noconfirm

.PHONY: pip_pkgs
TARGETS += pip_pkgs
pip_pkgs:
	pip install --user -r pkg/requirements.txt

.PHONY: ufw
TARGETS += ufw
ufw:
	systemctl enable ufw.service
	systemctl start ufw.service
	ufw default deny incoming
	ufw default allow outgoing
	ufw enable

.PHONY: zsh
TARGETS += zsh
zsh:
	chsh -s /usr/bin/zsh

.PHONY: networkmanager
TARGETS += networkmanager
networkmanager:
	systemctl enable NetworkManager.service

.PHONY: timesync
TARGETS += timesync
timesync:
	systemctl enable systemd-timesyncd.service

.PHONY: disable_beep
TARGETS += disable_beep
disable_beep:
	echo "blacklist pcspkr" > "/etc/modprobe.d/nobeep.conf"

.PHONY: light
TARGETS += light
light:
	usermod -a -G "video" "$$USER"

.PHONY: tlp
TARGETS += tlp
tlp:
	install -m644 $(CONF)/tlp.conf /etc/tlp.conf
	systemctl enable tlp.service

.PHONY: udev
TARGETS += udev
udev:
	install -Dm644 $(CONF)/60-onbattery.rules $(UDEV)/60-onbattery.rules
	install -Dm644 $(CONF)/61-onpower.rules $(UDEV)/61-onpower.rules
	udevadm control --reload

.PHONY: acpi
TARGETS += acpi
acpi:
	install -Dm644 $(CONF)/audio_jack $(ACPI)/audio_jack
	sudo sytemctl enable acpid.service

.PHONY: systemd_pre_sleep
TARGETS += systemd_pre_sleep
systemd_pre_sleep:
	install -Dm644 $(CONF)/pre-sleep@.service $(SYSTEMD)/pre-sleep@.service
	systemctl enable "pre-sleep@$$USER.service"

.PHONY: pacman_hooks
TARGETS += pacman_hooks
pacman_hooks:
	install -Dm644 $(CONF)/pacdiff.hook $(PACMAN)/hooks/pacdiff.hook
	install -Dm644 $(CONF)/paccache.hook $(PACMAN)/hooks/paccache.hook

.PHONY: install
install: $(TARGETS)
