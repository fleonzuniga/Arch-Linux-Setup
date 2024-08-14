#!/bin/bash

# To get the USB path
#sudo fdisk -l

ISO=$(ls ./ISO/*.iso)
USB=/dev/sda

sudo dd bs=4M if=${ISO} of=${USB} status=progress oflag=sync
