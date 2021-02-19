# bootFromUSB
Boot NVIDIA Jetson Nano Developer Kit from a mass storage USB device. This includes Jetson Nano 2GB, and may also work with the TX1. This setup is done from the Jetson Development Kit itself.

<h1>Work In Progress</h1>

<em><b>WARNING: </b>This is a low level system change. You may have issues which are not easily solved. You should do this working on a freshly flashed micro SD card, and certainly do not attempt this with valuable data on the card itself. A serial debug console is useful if things go wrong. </em>

A new feature of JetPack 4.5 (L4T 32.5) is the ability to boot from a USB device with mass storage class and bulk only protocol. This includes devices such as a USB HDD, USB SSD and flash drives.

Under JetPack 4.5 (L4T 32.5) there is an issue on Jetson Nano that it was not able to load kernel, kernel-dtb and initrd from USB or NVME. There is fix for this issue, a script is provided here for the fix.

In order to setup a Jetson to boot from a USB device, there are several steps.


## Step 1: Boot the Jetson
During the initial setup of L4T 32.5, the firmware for all Jetson Nano developer kits relocate the boot firmware from the micro SD card to the Jetson module integrated QSPI-NOR flash memory. This also changes the layout of the SD card.

## Step 2: Prepare the USB Drive
Plug in the USB drive.

Prepare the USB drive (preferably USB 3.0+, SSD, HDD, or SATA->USB) by formatting the disk as ext4, gpt with a partition. It is easier if you only plug in one USB drive during this procedure. When finished, the disk should show as /dev/sda1 or similar. Note: Make sure that the partition is ext4, as NTSF will appear to copy correctly but cause issues later on. Typically it is easiest to set the volume label for later use during this process.

Mount the disk. If you are using a desktop, you can do this by clicking on the disks icon.

## Step 3: For Jetson Nano Developer Kits (include 2GB) Only

Install the payload updater to fix a loading issue.

```
$ ./installNanoPayloadUpdater.sh
```

<em>Note: that this updates the file /usr/sbin/l4t_payload_updater_t210 on the SD card.</em>

## Step 4
Copy the application area of the micro SD card to the USB drive. copyRootToUSB.sh copies the contents of the entire system micro SD card to the USB drive. Naturally, the USB drive storage should be larger than the micro SD card. Note: Make sure that the USB drive is mounted before running the script. In order to copyRootToUSB:

```
usage: ./copyRootToUSB.sh [OPTIONS]

  -d | --directory     Directory path to parent of kernel

  -v | --volume_label  Label of Volume to lookup

  -p | --path          Device Path to USB drive (e.g. /dev/sda1)

  -h | --help  This message
  ```

## Step 5
Modify the /boot/extlinux/extlinux.conf file located on the USB drive. This is in a system protected area, so you will need privileges to change the file, ie 'sudo gedit'. One way to do this is to use the file browser to navigate to the USB drive, find the boot/extlinux directory, and then open a terminal from the context menu. 

Before editing the extlinux.conf file make a copy of it. 

An entry should be added to point to the new root (typically this is /dev/sda1). There is a sample configuration file: sample-extlinux.conf in the bootFromUSB repository. 

It can be a good idea to use the PARTUUID of the disk to identify the disk location. This is the UUID of the disk in the GPT partition table, thus PARTUUID. There is another UUID identifier, referred to as UUID, which is the UUID given by the file system. Use the PARTUUID for this application. 

There is a convenience file: partUUID.sh which will determine the PARTUUID of a given device. This is useful in determining the PARTUUID of the USB drive. Note: If the PARTUUID returned is not similar in length to the sample-extlinux.conf example, then it is likely that the device is not formatted as ext4.

```
$ ./partUUID.sh
```

While this defaults to sda1 (/dev/sda1), you can also determine other drive PARTUUIDs. The /dev/ is assumed, use the -d flag. For example:

```
$ ./partUUID.sh -d sdb1
```

The reason to be more specific is that sometimes people use more than one USB drive on a system. Because USB does not have a guaranteed enumeration sequence, it may be possible that a specific address such as /dev/sda1 does not end up pointing to the boot drive.

## Step 6

Remove the micro SD card if applicable, and boot the system.


<h2>Release Notes</h2>
<h3>February, 2021</h3>

* JetPack 4.5
* L4T 32.5
* Initial Release
* Tested on Jetson Nano





