# Arch-Linux-Steup
This is a setup for Arch Linux with linux-zen kernel pipewire, wayland, Nvidia, and KDE

## Partition the disks
Identify the disk to be partitioned.
```
fdisk -l
```
Use `fdisk` partitioning too to modify partition tables.
```
fdisk /dev/sda
```
Type `g` on the fdisk prompt to create a GPT partition table.

* To create the first partition (**Boot partition**:) type on the fdisk prompt:
    1. `n` *enter* (New Partition)
    2. *enter* (Default partition 1).
    3. *enter* (First sector with default 2048).
    4. `+512M` *enter* (Sector size. "This is the EFI partition").
    5. `t` *enter* (Set partition type).
    6. `1` *enter* (Partition type: EFI).

* To create the second partition (**Swap partition**:) type on the fdisk prompt:
    1. `n` *enter* (New Partition).
    2. *enter* (Default partition 2).
    3. *enter* (Second sector with default).
    4. +2000M (Sector size).
    5. `t` *enter* (Set partition type).
    6. *enter*
    7. `19` *enter* (Partition type: Swap).

* To create the third partition (**Root partition**:) type on the fdisk prompt:
    1. n *enter* (New Partition).
    2. *enter* (Default partition).
    3. *enter* (Default sector).
    4. *enter* (Default size).

Type `w` on the fdisk prompt to write the changes and exit.

Format the first partition with FAT32.
```
mkfs.fat -F32 /dev/sda1
```
Format the second partition with swap.
```
mkswap /dev/sda2
```
Turn on the swap.
```
swapon /dev/sda2
```
Format the root filesystem.
```
mkfs.ext4 /dev/sda3
```
Mount filesystem.
```
mount /dev/sda3 /mnt
```
Install all base packages.
```
pacstrap /mnt base
```
Generate an fstab.
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Change root into the new system.
```
arch-chroot /mnt
```
Install git to download the installation script
```
pacman -S git
```
