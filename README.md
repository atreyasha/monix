# monix

This repository documents workflows to *reproduce* a minimal Arch Linux build called `monix`. While this repository sets up root-level configurations for the OS, the [`dotfiles`](https://github.com/atreyasha/dotfiles) repository is used to set up user-level configurations. These are kept separate for modularity, but are designed to be used together. All setup workflows have been tested on both virtual machines and hardware.

<p align="center">
<img src="https://archlinux.org/static/logos/legacy/arch-legacy-noodle-box.eb6d7aaefe13.svg">
</p>

For automatically formatting the development log in this repository, initialize a local pre-commit hook:

```
$ make init
```

**Note:** This repository focuses on approximate reproducibility oriented towards functionality. This implies that final builds may not be bit-for-bit identical.

## Installation

<details><summary>Live medium</summary><p>

For this first step, follow the instructions from the Arch Linux installation [guide](https://wiki.archlinux.org/title/Installation_guide).

**Important:** During the `pacstrap` phase where basic packages are installed before `chroot`, use the command below instead. This ensures a text editor and an active internet connection will be available after `chroot` and the first reboot.

```
# pacman-key --init
# pacman-key --populate
# pacstrap -K /mnt base base-devel linux-lts linux-firmware vim git networkmanager
```

**Note:** Some common troubleshooting:

1. For system encryption, depending on how you encrypt Arch Linux, you may need to install additional packages such as `lvm2`. Take note of special instructions in this Arch Wiki [page](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system), especially for partitioning, `mkinitcpio` and `grub`.

2. For dual booting, follow this Arch Wiki [page](https://wiki.archlinux.org/title/Dual_boot_with_Windows) closely and enable [`os-prober`](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system) in `grub` for discovering additional OS's.

3. `nvidia` may not boot for Linux kernels 5.18 or greater, see issue [here](https://bbs.archlinux.org/viewtopic.php?id=283783) and [here](https://wiki.archlinux.org/title/NVIDIA). In this case, set the `ibt=off` kernel parameter in the boot loader.

</p></details>
<details><summary>Post reboot</summary>

1. Log in to the freshly installed Arch Linux system as `root`

2. Execute `EDITOR=vim visudo` to edit the `/etc/sudoers` file. Uncomment the following line to allow users from the `wheel` group to execute root-level commands with `sudo`:

    ```
    %wheel ALL=(ALL:ALL) ALL
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

7. Configure your internet connection using `nmtui`, which should work for most connection types. Verify that your internet connection works by executing `ping www.example.com` and checking for successful packet transmission and receipt.

    **Note:** `nmtui` could require `root` permissions at this point in time

8. Clone this repository in your `$HOME` directory and install:

    ```
    $ git -C $HOME clone https://github.com/atreyasha/monix.git
    $ cd $HOME/monix
    $ make init
    $ make install
    ```

9. Clone the [`dotfiles`](https://github.com/atreyasha/dotfiles) repository in your `$HOME` directory and install:

    ```
    $ git -C $HOME clone https://github.com/atreyasha/dotfiles.git
    $ cd $HOME/dotfiles
    $ make init
    $ make install
    ```

10. If you have any private dotfiles and data, deploy them now. In order to benefit from all the features of the `dotfiles` repository, rename your private dotfiles repository as `privates` and place it in your `$HOME` directory. This `privates` repository should contain a `Makefile` with a `test` target

11. Reboot and enjoy!

**Note:** Some common troubleshooting:

1. Decrease GRUB [resolution](https://wiki.archlinux.org/title/GRUB/Tips_and_tricks#Setting_the_framebuffer_resolution) in case it is hard to read or laggy.
2. Manually add [timeservers](https://wiki.archlinux.org/title/Systemd-timesyncd#Configuration) such as `time.google.com` in case the default timeservers do not work.

</p></details>

## Test

[`bats-core`](https://github.com/bats-core/bats-core) is a dependency for unit testing. To run tests, execute:

```
$ make test
```

## Development

Check out our development [log](./docs/develop.md) for details on upcoming developments.
