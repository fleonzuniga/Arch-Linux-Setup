#!/bin/bash

# https://www.baeldung.com/linux/qemu-from-terminal
# https://www.qemu.org/docs/master/index.html

# Variables
DISK_NAME=archlinux.qcow2
DISK_TYPE=qcow2
DISK_SIZE=32G
RAM=8G
CPUs=4

ISO=$(ls ./ISO/*.iso)
V_FOLDER=virtualization
SHARED_FOLDER=${V_FOLDER}/shared_folder
DISK_PATH=${V_FOLDER}/${DISK_NAME}

if [ ! -d ${V_FOLDER} ]; then
    if [ -f ${ISO} ]; then
        if [ ! -d ${V_FOLDER} ]; then
            mkdir ${V_FOLDER}
        fi
        if [ ! -f ${DISK_NAME} ]; then
            # Create virtual disk of 32 Gb type qcow2
            qemu-img create -f ${DISK_TYPE} ${DISK_PATH} ${DISK_SIZE}
        fi
        if [ ! -d ${SHARED_FOLDER} ]; then
            mkdir ${SHARED_FOLDER}
        fi
        # First Start
        qemu-system-x86_64 \
            -enable-kvm \
            -bios /usr/share/ovmf/x64/OVMF.fd \
            -cpu qemu64,+ssse3,+sse4.1,+sse4.2 \
            -m ${RAM} \
            -smp ${CPUs} \
            -hda ${DISK_PATH} \
            -netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 \
            -device virtio-net-pci,netdev=net0 \
            -vga qxl \
            -device AC97 \
            -device virtio-serial-pci \
            -spice port=5930,disable-ticketing=on \
            -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
            -chardev spicevmc,id=spicechannel0,name=vdagent \
            -display spice-app \
            -virtfs local,path=${SHARED_FOLDER},mount_tag=host0,security_model=mapped,id=host0 \
            -monitor stdio \
            -boot d \
            -cdrom ${ISO}
    fi
else
    # Run
    qemu-system-x86_64 \
        -enable-kvm \
        -bios /usr/share/ovmf/x64/OVMF.fd \
        -cpu qemu64,+ssse3,+sse4.1,+sse4.2 \
        -m ${RAM} \
        -smp ${CPUs} \
        -hda ${DISK_PATH} \
        -netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 \
        -device virtio-net-pci,netdev=net0 \
        -vga qxl \
        -device AC97 \
        -device virtio-serial-pci \
        -spice port=5930,disable-ticketing=on \
        -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
        -chardev spicevmc,id=spicechannel0,name=vdagent \
        -display spice-app \
        -virtfs local,path=${SHARED_FOLDER},mount_tag=host0,security_model=mapped,id=host0 \
        -monitor stdio
fi

# (qemu) info snapshots
# (qemu) savevm snapshot1
# (qemu) loadvm snapshot1
# (qemu) delvm snapshot1
