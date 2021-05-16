# bootFromUSB
Boot NVIDIA Jetson Nano Developer Kit from a mass storage USB device. This includes Jetson Nano 2GB, and may also work with the TX1. This setup is done from the Jetson Development Kit itself.

<em><b>WARNING: </b>This is a low level system change. You may have issues which are not easily solved. You should do this working on a freshly flashed micro SD card, and certainly do not attempt this with valuable data on the card itself. A serial debug console is useful if things go wrong. </em>

A new feature of JetPack 4.5 (L4T 32.5) is the ability to boot from a USB device with mass storage class and bulk only protocol. This includes devices such as a USB HDD, USB SSD and flash drives.

In order to setup a Jetson to boot from a USB device, there are several steps.


## Step 1: Setup and Boot the Jetson
You will need to do an initial setup of the Jetson with JetPack 4.5+ in order to load updated firmware into the Jetson Module QSPI-NOR flash memory. Follow the 'Getting Started' instructions on the JetPack site: https://developer.nvidia.com/embedded/jetpack

The JetPack archives are located here: https://developer.nvidia.com/embedded/jetpack-archive

During the initial setup of L4T 32.5+, the firmware for the Jetson Nano developer kits relocates the boot firmware from the micro SD card to the Jetson module integrated QSPI-NOR flash memory. This also changes the layout of the SD card. This layout is now analagous to the BIOS in a PC.

## Step 2: Prepare the USB Drive
Plug in the USB drive.

Prepare the USB drive (USB 3.0+, SSD, HDD, or flash drive) by formatting the disk as GPT with an Ext4 partition. Formatting the disk will erase any data that is on that disk. When finished, the disk should show as /dev/sda1 or similar. Note: Make sure that the partition is Ext4, as other formats will appear to copy correctly but cause issues later on. You may set the volume label during this process.

You can prepare the USB drive by using the Disks app. Formatting the disk using Format and creating a partition are two different tasks. Format the disk as GPT, then add a partition formatted as Ext4. Name the newly created partition APP so that Jetson system apps recognize it correctly.

Once the disk is ready, mount the disk. If you are using a desktop, you can do this by clicking on the USB disk icon and opening a file browser on its contents.

## Step 3 Copy the rootfs to the USB drive
Copy the application area of the micro SD card to the USB drive. copyRootToUSB.sh copies the contents of the entire system micro SD card to the USB drive. Naturally, the USB drive storage should be larger than the micro SD card. <b>Note:</b> Make sure that the USB drive is mounted before running the script, the script will complain if you do not. 


In order to copyRootToUSB:

```
usage: ./copyRootToUSB.sh [OPTIONS]

  -d | --directory     Directory path to parent of kernel

  -v | --volume_label  Label of Volume to lookup

  -p | --path          Device Path to USB drive (e.g. /dev/sda1)

  -h | --help  This message
  ```
For example:

```
$ ./copyRootToUSB.sh -p /dev/sda1
```

<h3>Note</h3>

The most likely device address of the USB drive will be /dev/sda1 Please note that if you do not find a version ending with a number, you probably do not have a partition allocated on that drive. For example,

```
$ ls /dev/sd*
```

assuming that there is a partition, should respond as:

```
$ /dev/sda /dev/sda1
```

sda1 is where you want to copy the rootfs from the SD card. If you only see /dev/sda, it means that there is no partition.


## Step 4 Modify extlinux.conf for the boot sequence
Use the file browser to navigate to the USB drive, find the boot/extlinux directory, and then open a terminal from the context menu.

Before editing the extlinux.conf file make a copy of it for backup purposes. This is in a system protected area so you will need privileges to change the file, ie 'sudo'.

Modify the /boot/extlinux/extlinux.conf file located on the USB drive. This is in a system protected area, so you will need privileges to change the file, ie 'sudo gedit'. Make a copy of the 'PRIMARY' entry and rename it sdcard.

In the PRIMARY entry change the location of the root to point to the USB drive, ie change 'root=/dev/mmcblk0p1' which is the address of the SD card. Provided in this repository is a sample configuration file: sample-extlinux.conf as an example.

While using root=/dev/sda1 in the extlinux.conf works, it can be a good idea to use the PARTUUID of the disk to identify the disk location. Because USB devices are not guaranteed to enumerate in the same order every time, it is possible that that /dev/sda1 points to a different device. This may happen if an extra flash drive is plugged into the Jetson along with the USB boot drive, for example.

The UUID of the disk in the GPT partition table is called the PARTUUID. This is a low level descriptor. Note that there is another identifier, referred to as UUID, which is given by the Linux file system. Use the PARTUUID for this application, as UUID has been reported to cause issues at the present time in this use case. 

There is a convenience file: partUUID.sh which will determine the PARTUUID of a given device. This is useful in determining the PARTUUID of the USB drive. Note: If the PARTUUID returned is not similar in length to the sample-extlinux.conf example (32a76e0a-9aa7-4744-9954-dfe6f353c6a7), then it is likely that the device is not formatted correctly.

```
$ ./partUUID.sh
```

While this defaults to sda1 (/dev/sda1), you can also determine other drive PARTUUIDs. The /dev/ is assumed, use the -d flag. For example:

```
$ ./partUUID.sh -d sdb1
```

## Step 5 Try It Out!

Remove the micro SD card, and boot the system.


<h2>Release Notes</h2>
<h3>March, 2021</h3>

* JetPack 4.5.1
* L4T 32.5.1
* Remove payload updater, the JetPack update addresses this issue
* Slightly more generous readme
* Tested on Jetson Nano


<h3>February, 2021</h3>

* JetPack 4.5
* L4T 32.5
* Initial Release
* Tested on Jetson Nano





