# nixos-mobile

Welcome to my NixOS Mobile Configuration! This repository represents my personal NixOS configuration for my oneplus6, crafted to suit my needs and preferences. I have included the steps I took to get NixOS running on my phone. I hope you find this useful!

⭐ & ❤️ from: [0xKyran](https://github.com/0xKyran)

> note: The repo requires a lot of cleanup, but it works for now.

## Hardware

- [oneplus 6](https://www.oneplus.com/6) (non T)

## Requirements

- [nix](https://nixos.org/)
- aarch64 machine
- android-tools

### Recommended apps:

- tmux
- btop / htop
- vim / neovim

> note: if you dont have an AARCH machine see [aws-server](#aws-server)

## installation

1. setup your phone:

- enable developer options, USB debugging and OEM unlock on your oneplus6
- run `adb reboot bootloader` to reboot your phone into the bootloader
- run `fastboot oem unlock` to unlock your bootloader

> note: this will wipe and reset your phone and you will need to re-enable developer options and USB debugging

2. Setup partitions

- download [TWRP](https://eu.dl.twrp.me/enchilada/twrp-3.7.0_11-0-enchilada.img.html)
- run `adb reboot bootloader` to reboot your phone into the bootloader
- run `fastboot boot twrp-3.7.0_11-0-enchilada.img` to boot into TWRP
- download [copy-partitions-20220613-signed.zip](https://mirrorbits.lineageos.org/tools/copy-partitions-20220613-signed.zip)
- in TWRP go to Advanced -> ADB Sideload and swipe to start sideload
- run `adb sideload copy-partitions-20220613-signed.zip`
- return to the bootloader
- remove the following partitions: `dtbo_a` and `dtbo_b` with:
```zsh
fastboot erase dtbo_a
fastboot erase dtbo_b
```
2. building image

- clone this repo with `git clone git@github.com:0xKyran/nixos-mobile.git`
- Allow unfree and insecure packages with:
```zsh
export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_INSECURE=1
```
- build the images with `nix-build --argstr device oneplus-enchilada -A build.android-fastboot-images`
- cd into the `result` directory
- run `./flash-critical.sh` to flash the boot image
- run `fastboot flash userdata system.img` to flash the system image
- run `fastboot reboot` to reboot your phone into NixOS

## aws-server

If you dont have an AARCH64 machine you can use an AWS server to build the images.

1. create an AWS server with the following specs:
- t4g.[instance size]
- 80GB storage
- nixOS AARCH64 image, see amis in [Ami-list](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/amazon-ec2-amis.nix)
- SSH access, with a key you have access to (with port 22 open in your security group)

> This is the configuration I used: [configuration.nix](./configuration.nix)

2. ssh into your server
3. follow the [installation](#installation) steps

> note: You have to use a aarch64 instance, I used t4g.2xlarge but you can use a smaller instance if you want.

> note: You will need some storage, I used 80GB but you can use less if you want.

> note: Bigger instances will build faster but have a higher cost per hour.
