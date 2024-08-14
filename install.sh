source install_variables.sh

echo ""
echo "Disk:     ${DISK}"
echo "Username: ${USERNAME}"
echo "Computer: ${COMPUTER}"
echo "Region:   ${REGION}"
echo "Country:  ${COUNTRY}"
echo "CPU:      ${CPU}"
echo "GPU:      ${GPU}"
echo ""

read -e -p "Does it looks ok? " CHOICE

if [[ ! ${CHOICE} == [Yy]* ]]; then
    echo "To set other parameters change variables in variable.sh"
else
    pacman -S linux-zen linux-zen-headers linux-firmware --noconfirm
    pacman -S base-devel --noconfirm

    mkinitcpio -p linux-zen

    cp /etc/locale.gen /tmp/locale.gen_bak
    sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen > /tmp/locale.gen_changed

    locale-gen

    echo "Root Password"
    passwd
    useradd -m ${USERNAME}

    echo "User Password"
    passwd ${USERNAME}
    usermod -aG wheel,video,audio ${USERNAME}
    which sudo

    cp /etc/sudoers /tmp/sudoers_bak
    sed 's/# %wheel ALL=(ALL:ALL) ALL/ %wheel ALL=(ALL:ALL) ALL/' /etc/sudoers > /tmp/sudoers_changed
    cp /tmp/sudoers_changed /etc/sudoers

    pacman -S grub efibootmgr dosfstools os-prober mtools --noconfirm
    mkdir /boot/EFI
    mount /dev/${DISK}1 /boot/EFI

    grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub
    grub-mkconfig -o /boot/grub/grub.cfg

    ln -sf /usr/share/zoneinfo/${REGION}/${COUNTRY} /etc/localtime
    hwclock --systohc

    echo "${COMPUTER}" > /etc/hostname
    echo "127.0.0.1        localhost" >> /etc/hosts
    echo "::1              localhost" >> /etc/hosts
    echo "127.0.1.1        ${COMPUTER}.localdomain        ${COMPUTER}" >> /etc/hosts

    case ${CPU} in
        # AMD CPU
        amd)
            pacman -S amd-ucode --noconfirm
        ;;
        # Intel CPU
        intel)
            pacman -S intel-ucode --noconfirm
        ;;
    esac
    case ${GPU} in
        # AMD or Intel GPU
        mesa)
            pacman -S mesa --noconfirm
        ;;
        # Nvidia GPU
        nvidia)
            pacman -S nvidia --noconfirm
        ;;
        both)
            pacman -S mesa --noconfirm
            pacman -S nvidia --noconfirm
        ;;
        # Virtual environment
        virtual)
            pacman -S xf86-video-vmware --noconfirm
        ;;
    esac
    # Audio environment
    pacman -S pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse --noconfirm

    # Graphical environment
    pacman -S sddm wayland xorg-xwayland wayland-utils glfw --noconfirm
    systemctl enable sddm

    # Desktop environment
    pacman -S plasma-meta --noconfirm

    # Networking
    pacman -S networkmanager wpa_supplicant wireless_tools netctl --noconfirm
    systemctl enable NetworkManager

    # Programs
    pacman -S konsole dolphin kate okular --noconfirm

    umount -f /mnt
    reboot
fi



