PACMAN  ?= /etc/pacman.d
ACPI    ?= /etc/acpi/events
SYSTEMD ?= /etc/systemd/system
UDEV    ?= /etc/udev/rules.d
UFW     ?= /etc/ufw
CONF    ?= ./conf
TARGETS =

.PHONY: init
init:
	cp "./hooks/pre-commit" "./.git/hooks/"

.PHONY: yay
TARGETS += yay
yay:
	tmp="$$(mktemp -d)"; \
	git clone "https://aur.archlinux.org/yay-bin.git" "$$tmp"; \
	cd "$$tmp"; \
	makepkg -si

.PHONY: pacman_native_pkgs
TARGETS += pacman_native_pkgs
pacman_native_pkgs:
	sudo pacman -Syy
	sudo pacman -S --needed - < "pkg/pacman_native"

.PHONY: pacman_foreign_pkgs
TARGETS += pacman_foreign_pkgs
pacman_foreign_pkgs:
	yay -S --needed - < "pkg/pacman_foreign"

.PHONY: downgrade_pkgs
TARGETS += downgrade_pkgs
downgrade_pkgs:
	yes | sudo downgrade --ala-only picom=7.5-3

.PHONY: pip_pkgs
TARGETS += pip_pkgs
pip_pkgs:
	pip install --user -r "pkg/requirements.txt"

.PHONY: ufw
TARGETS += ufw
ufw:
	sudo systemctl enable ufw.service
	sudo systemctl start ufw.service
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo install -Dm644 "$(CONF)/ufw.conf" -t "$(UFW)"

.PHONY: zsh
TARGETS += zsh
zsh:
	chsh -s "/usr/bin/zsh"

.PHONY: networkmanager
TARGETS += networkmanager
networkmanager:
	sudo systemctl enable NetworkManager.service

.PHONY: timesync
TARGETS += timesync
timesync:
	sudo systemctl enable systemd-timesyncd.service
	sudo timedatectl set-ntp true

.PHONY: disable_beep
TARGETS += disable_beep
disable_beep:
	echo "blacklist pcspkr" | sudo tee "/etc/modprobe.d/nobeep.conf"

.PHONY: light
TARGETS += light
light:
	sudo usermod -a -G "video" "$$USER"

.PHONY: tlp
TARGETS += tlp
tlp:
	sudo install -Dm644 "$(CONF)/tlp.conf" -t "/etc"
	sudo systemctl enable tlp.service

.PHONY: udev
TARGETS += udev
udev:
	sudo install -Dm644 "$(CONF)/60-onbattery.rules" -t "$(UDEV)"
	sudo install -Dm644 "$(CONF)/61-onpower.rules" -t "$(UDEV)"
	sudo udevadm control --reload

.PHONY: acpi
TARGETS += acpi
acpi:
	sudo install -Dm644 "$(CONF)/audio_jack" -t "$(ACPI)"
	sudo systemctl enable acpid.service

.PHONY: systemd_pre_sleep
TARGETS += systemd_pre_sleep
systemd_pre_sleep:
	sudo install -Dm644 "$(CONF)/pre-sleep@.service" -t "$(SYSTEMD)"
	sudo systemctl enable "pre-sleep@$$USER.service"

.PHONY: pacman_hooks
TARGETS += pacman_hooks
pacman_hooks:
	sudo install -Dm644 "$(CONF)/pacdiff.hook" -t "$(PACMAN)/hooks"
	sudo install -Dm644 "$(CONF)/paccache.hook" -t "$(PACMAN)/hooks"

.PHONY: base_dirs
TARGETS += base_dirs
base_dirs:
	mkdir -p "$$HOME/desktop/personal"
	mkdir -p "$$HOME/downloads"

.PHONY: install
install: $(TARGETS)

.PHONY: test
test:
	bats "test/monix.bats"
