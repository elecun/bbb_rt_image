#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument"
    echo "Usage : ./flash.sh sdc"
    exit 1
fi

export DISK=/dev/"$1"
export ROOT_DIR=$(pwd)
export KERNEL_VERSION=4.19.106-bone-rt-r49
export NONRT_KERNEL_VERSION=4.19.106-bone49
export TOOLCHAIN=gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf
export ARCHITECTURE=arm-linux-gnueabihf
export FILESYSTEM=debian-10.3-minimal-armhf-2020-02-10

echo "****************************************"
echo " RT Linux flash on microSD Card for TI AM335x(BBB)"
echo " Kernel Version : ${KERNEL_VERSION}"
echo " Root File System : ${FILESYSTEM}"
echo " Toolchain : ${TOOLCHAIN}"
echo " Architecture : ${ARCHITECTURE}"
echo " Note : It will take several hours for downloading and building the all required sources."
echo "****************************************"


cd ${ROOT_DIR}
echo "****************************************"
echo "1/11. Erase partition table/labels on microSD card"
echo "****************************************"
sudo dd if=/dev/zero of=${DISK} bs=1M count=10

echo "****************************************"
echo "2/11. Write Bootloader on ${DISK}"
echo "****************************************"
sudo dd if=./u-boot/MLO of=${DISK} count=1 seek=1 bs=128k
sudo dd if=./u-boot/u-boot.img of=${DISK} count=2 seek=1 bs=384k

echo "****************************************"
echo "3/11. Create Partition Layout and format"
echo "****************************************"
sudo sfdisk ${DISK} <<-__EOF__
4M,,L,*
__EOF__
sudo mkfs.ext4 -L rootfs -O ^metadata_csum,^64bit ${DISK}1


echo "****************************************"
echo "4/11. mount partition"
echo "****************************************"
sudo mkdir -p /media/rootfs/
sudo mount ${DISK}1 /media/rootfs/

echo "****************************************"
echo "5/11. Bootloader backup"
echo "****************************************"
cd ${ROOT_DIR}
sudo mkdir -p /media/rootfs/opt/backup/uboot/
sudo cp -v ./u-boot/MLO /media/rootfs/opt/backup/uboot/
sudo cp -v ./u-boot/u-boot.img /media/rootfs/opt/backup/uboot/


echo "****************************************"
echo "6/11. Copy Root File System"
echo "****************************************"
sudo tar xfp ./${FILESYSTEM}/armhf-rootfs-*.tar -C /media/rootfs/
sync
sudo chown root:root /media/rootfs/
sudo chmod 755 /media/rootfs/

echo "****************************************"
echo "7/11. Set uname_r in /boot/uEnv.txt"
echo "****************************************"
sudo sh -c "echo 'uname_r=${KERNEL_VERSION}' >> /media/rootfs/boot/uEnv.txt"

echo "****************************************"
echo "8/11. Copy Kernel image..."
echo "****************************************"
sudo cp -v ./bb-kernel-${KERNEL_VERSION}/deploy/${KERNEL_VERSION}.zImage /media/rootfs/boot/vmlinuz-${KERNEL_VERSION}

echo "****************************************"
echo "9/11. Copy Kernel Device Tree Binaries"
echo "****************************************"
sudo mkdir -p /media/rootfs/boot/dtbs/${KERNEL_VERSION}/
sudo tar xf ./bb-kernel-${KERNEL_VERSION}/deploy/${KERNEL_VERSION}-dtbs.tar.gz -C /media/rootfs/boot/dtbs/${KERNEL_VERSION}/

echo "****************************************"
echo "10/11. Copy Kernel Modules"
echo "****************************************"
sudo tar xf ./bb-kernel-${KERNEL_VERSION}/deploy/${KERNEL_VERSION}-modules.tar.gz -C /media/rootfs/

echo "****************************************"
echo "11/11. File System Table"
echo "****************************************"
sudo sh -c "echo '/dev/mmcblk0p1  /  auto  errors=remount-ro  0  1' >> /media/rootfs/etc/fstab"
sync
sudo umount /media/rootfs

echo "****************************************"
echo "Finally End. You can remove the microSD Card."
echo "****************************************"
