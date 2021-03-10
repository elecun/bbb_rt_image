#!/bin/bash

#Flash SD Card to eMMC (on your device)

wget https://raw.githubusercontent.com/RobertCNelson/boot-scripts/master/tools/eMMC/bbb-eMMC-flasher-eewiki-ext4.sh
chmod +x bbb-eMMC-flasher-eewiki-ext4.sh
sudo /bin/bash ./bbb-eMMC-flasher-eewiki-ext4.sh