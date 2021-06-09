# monix

This repository documents workflows to reproduce a minimal Arch Linux build called `monix`. While this repository sets up root-level configurations for the OS, the [`dotfiles`](https://github.com/atreyasha/dotfiles) repository can be used to set up user-level configurations. These are kept separate for modularity. All setup workflows have been tested on virtual machines and actual hardware.

<p align="center">
<img src="https://archlinux.org/static/logos/legacy/arch-legacy-noodle-box.eb6d7aaefe13.svg">
</p>

## Installation from live medium

For this first step, follow the instructions from the Arch Linux installation [guide](https://wiki.archlinux.org/title/Installation_guide).

**Important:** During the `pacstrap` phase where basic packages are installed before `chroot`, use the command below instead. This ensures a text editor and an active internet connection will be available after `chroot` and the first reboot.

```
# pacstrap /mnt base base-devel linux-lts linux-firmware vim git networkmanager
```

## Post initial-reboot

1. Log in to the freshly installed Arch Linux system as `root`

2. Execute `EDITOR=vim visudo` to edit the `/etc/sudoers` file. Uncomment the following line to allow users from the `wheel` group to execute root-level commands with `sudo`:

    ```
    %wheel      ALL=(ALL) ALL
    ```

3. Create a new user and add this user to the `wheel` group:

    ```
    # useradd -m -G wheel <username>
    ```
    
4. Set a password for this user:

    ```
    # passwd <username>
    ```

5. Execute `logout` and log in using your new user's details

6. Start `NetworkManager.service` to ease the internet connection setup:

    ```
    $ sudo systemctl start NetworkManager.service
    ```

7. Configure your internet connection using `nmtui`, which should work for most connection types. Verify that your internet connection works by executing `ping www.example.com` and checking for successful packet transmission and receipt

8. Clone this repository and install:

    ```
    $ git clone https://github.com/atreyasha/monix.git
    $ cd monix
    $ sudo make install
    ```

9. Clone the `dotfiles` repository and install:

    ```
    $ git clone https://github.com/atreyasha/dotfiles.git
    $ cd dotfiles
    $ make install.local
    ```

10. If you have any private dotfiles and data, deploy them now

11. Reboot and enjoy!

## Test

Run test script to check everything works:

```
$ make test
```
