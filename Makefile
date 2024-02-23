PACMAN    ?= /etc/pacman.d
ACPI      ?= /etc/acpi/events
SYSTEMD   ?= /etc/systemd/system
UDEV      ?= /etc/udev/rules.d
UFW       ?= /etc/ufw
DOWNGRADE ?= /etc/xdg/downgrade
MODPROBE  ?= /etc/modprobe.d
CONF      ?= ./conf
TARGETS   =

.PHONY: init
init:
	cp "./hooks/pre-commit" "./.git/hooks/"
	cp "./hooks/post-commit" "./.git/hooks/"

.PHONY: empty_pacman_hooks
TARGETS += empty_pacman_hooks
empty_pacman_hooks:
	sudo rm -rf "$(PACMAN)/hooks"

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

.PHONY: pacman_hooks
TARGETS += pacman_hooks
pacman_hooks:
	temp_file="$$(mktemp)"; \
	envsubst < "$(CONF)/1-packages.hook" | tee "$$temp_file"; \
	sudo install -Dm644 "$$temp_file" -T "$(PACMAN)/hooks/1-packages.hook"
	sudo install -Dm644 "$(CONF)/2-paccache.hook" -t "$(PACMAN)/hooks"
	sudo install -Dm644 "$(CONF)/3-orphans.hook" -t "$(PACMAN)/hooks"
	sudo install -Dm644 "$(CONF)/4-pacdiff.hook" -t "$(PACMAN)/hooks"

.PHONY: downgrade_conf
TARGETS += downgrade_conf
downgrade_conf:
	temp_file="$$(mktemp)"; \
	envsubst < "$(CONF)/downgrade.conf" | tee "$$temp_file"; \
	sudo install -Dm644 "$$temp_file" -T "$(DOWNGRADE)/downgrade.conf"

.PHONY: pip_pkgs
TARGETS += pip_pkgs
pip_pkgs:
	pip install --user --break-system-packages -r "pkg/requirements.txt"

.PHONY: ufw
TARGETS += ufw
ufw:
	sudo systemctl enable ufw.service
	sudo systemctl start ufw.service
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw enable || sudo install -Dm644 "$(CONF)/ufw.conf" -t "$(UFW)"

.PHONY: zsh
TARGETS += zsh
zsh:
	chsh -s "/usr/bin/zsh"

.PHONY: networkmanager
TARGETS += networkmanager
networkmanager:
	sudo systemctl enable NetworkManager.service
	sudo systemctl start NetworkManager.service

.PHONY: timesync
TARGETS += timesync
timesync:
	sudo systemctl enable systemd-timesyncd.service
	sudo systemctl start systemd-timesyncd.service
	sudo timedatectl set-ntp true

.PHONY: disable_beep
TARGETS += disable_beep
disable_beep:
	echo "blacklist pcspkr" | sudo tee "$(MODPROBE)/nobeep.conf"

.PHONY: light
TARGETS += light
light:
	sudo usermod -a -G "video" "$$USER"

.PHONY: tlp
TARGETS += tlp
tlp:
	sudo install -Dm644 "$(CONF)/tlp.conf" -t "/etc"
	sudo systemctl enable tlp.service
	sudo systemctl start tlp.service

.PHONY: udev
TARGETS += udev
udev:
	temp_file="$$(mktemp)"; \
	envsubst < "$(CONF)/60-onbattery.rules" | tee "$$temp_file"; \
	sudo install -Dm644 "$$temp_file" -T "$(UDEV)/60-onbattery.rules"
	temp_file="$$(mktemp)"; \
	envsubst < "$(CONF)/61-onpower.rules" | tee "$$temp_file"; \
	sudo install -Dm644 "$$temp_file" -T "$(UDEV)/61-onpower.rules"
	sudo udevadm control --reload

.PHONY: acpi
TARGETS += acpi
acpi:
	temp_file="$$(mktemp)"; \
	envsubst < "$(CONF)/audio_jack" | tee "$$temp_file"; \
	sudo install -Dm644 "$$temp_file" -T "$(ACPI)/audio_jack"
	sudo systemctl enable acpid.service
	sudo systemctl start acpid.service

.PHONY: systemd_pre_sleep
TARGETS += systemd_pre_sleep
systemd_pre_sleep:
	sudo install -Dm644 "$(CONF)/pre-sleep@.service" -t "$(SYSTEMD)"
	sudo systemctl enable "pre-sleep@$$USER.service"

.PHONY: base_dirs
TARGETS += base_dirs
base_dirs:
	mkdir -p "$$HOME/desktop"
	mkdir -p "$$HOME/downloads"

.PHONY: localectl
TARGETS += localectl
localectl:
	sudo localectl --no-convert set-x11-keymap us,de

.PHONY: vbox
TARGETS += vbox
vbox:
	vboxmanage setproperty machinefolder "$$HOME/vbox"
	sudo usermod -a -G "vboxusers" "$$USER"

.PHONY: docker
TARGETS += docker
docker:
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	sudo usermod -a -G "docker" "$$USER"

.PHONY: pulse_secure
TARGETS += pulse_secure
pulse_secure:
	sudo systemctl enable pulsesecure.service
	sudo systemctl start pulsesecure.service

.PHONY: install
install: $(TARGETS)

.PHONY: test
test:
	bats "test/monix.bats"
	! git grep -rI "$$USER" conf &>/dev/null
	! git grep -rI "$$HOME" conf &>/dev/null
	! git grep -rI "/bin/sh" conf &>/dev/null
