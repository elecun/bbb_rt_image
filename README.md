# bbb_rt_image
Script to create bootable microSD image for Preempt RT Linux on BeagleBone Black

1. Connect microSD Card to your Host(ex. Ubuntu) PC.
2. Find disk name (ex. sdc)
   ```
   $ lsblk
   ```
3. Run build.sh
> Download and build all related source code.
    ```
    $ ./build.sh
    ```
    ```
    lzop might be installed before start.
    $ apt-get install lzop
    ```
4. Run Flash.sh
> If the microSD card has device name 'sdc', type below
    ```
    $ sudo ./flash.sh sdc
    ```
