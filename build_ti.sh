#!/bin/bash

export ROOT_DIR=$(pwd)
export KERNEL_VERSION=4.19.94-ti-rt-r45
export TOOLCHAIN=gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf
export ARCHITECTURE=arm-linux-gnueabihf
export FILESYSTEM=debian-10.4-minimal-armhf-2020-05-10

echo "****************************************"
echo " RT Linux Build for TI AM335x(BBB Compatible OSD3358)"
echo " Kernel Version : ${KERNEL_VERSION}"
echo " Root File System : ${FILESYSTEM}"
echo " Toolchain : ${TOOLCHAIN}"
echo " Architecture : ${ARCHITECTURE}"
echo " Note : It will take several hours for downloading and building the all required sources."
echo "****************************************"



echo "****************************************"
echo "1/4. Setup Tool Chain : ${TOOLCHAIN}"
echo "****************************************"
cd ${ROOT_DIR}
wget -c https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/${ARCHITECTURE}/${TOOLCHAIN}.tar.xz
tar xf ${TOOLCHAIN}.tar.xz
export CC=`pwd`/${TOOLCHAIN}/bin/${ARCHITECTURE}-

echo "****************************************"
echo "2/4. Setup Bootloader..."
echo "****************************************"
git clone https://github.com/u-boot/u-boot
cd ./u-boot
git checkout v2019.04 -b tmp

wget -c https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch
wget -c https://github.com/eewiki/u-boot-patches/raw/master/v2019.04/0002-U-Boot-BeagleBone-Cape-Manager.patch
patch -p1 < 0001-am335x_evm-uEnv.txt-bootz-n-fixes.patch
patch -p1 < 0002-U-Boot-BeagleBone-Cape-Manager.patch

make ARCH=arm CROSS_COMPILE=${CC} distclean
make ARCH=arm CROSS_COMPILE=${CC} am335x_evm_defconfig
make ARCH=arm CROSS_COMPILE=${CC}

echo "****************************************"
echo "3/4. Setup Kernel"
echo "****************************************"
cd ${ROOT_DIR}
wget https://github.com/RobertCNelson/ti-linux-kernel-dev/archive/${KERNEL_VERSION}.tar.gz
tar xf ${KERNEL_VERSION}.tar.gz
cd ti-linux-kernel-dev-${KERNEL_VERSION}
./build_kernel.sh

echo "****************************************"
echo "4/4. Setup Root File System... ${FILESYSTEM}"
echo "****************************************"
cd ${ROOT_DIR}
wget -c https://rcn-ee.com/rootfs/eewiki/minfs/${FILESYSTEM}.tar.xz
tar xf ${FILESYSTEM}.tar.xz


echo "****************************************"
echo "End"
echo "****************************************"



