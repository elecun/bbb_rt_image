# bbb_rt_image
Script to create bootable microSD image for Preempt RT Linux on BeagleBone Black

1. Connect microSD Card to your Host(ex. Ubuntu) PC.
2. Find disk name (ex. sdc)
   ```
   $ lsblk
   ```
3. Run build.sh
> Dependent libraries might be installed before you start.
   ```
    $ apt-get install lzop fakeroot lzma gettext bison flex libmpc-dev u-boot-tools libncurses5-dev libssl-dev
   ```
    
> Download and build all related source code.
   ```
    $ ./build.sh
   ```
   
  
4. Run Flash.sh
> If the microSD card has device name 'sdc', type below
```
    $ sudo ./flash.sh sdc
```
