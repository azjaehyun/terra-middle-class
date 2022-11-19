#!/bin/bash

DISK="$1"

sudo parted --script $DISK \
  mklabel gpt \
  mkpart docker ext4 0% 20GiB \
  mkpart data ext4 20GiB 100%

sudo mkfs.ext4 ${DISK}p1
sudo mkfs.ext4 ${DISK}p2

sudo mkdir /data
sudo mkdir /var/lib/docker

sudo mount ${DISK}p1 /data
sudo mount ${DISK}p2 /var/lib/docker

echo UUID=`sudo blkid -s UUID -o value ${DISK}p1` /var/lib/docker    ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab
echo UUID=`sudo blkid -s UUID -o value ${DISK}p2` /data              ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab