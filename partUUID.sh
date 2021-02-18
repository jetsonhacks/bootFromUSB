#!/bin/bash
# Copyright (c) 2016-2021 Jetsonhacks 
# MIT License
# print out the PARTUUID of the given disk partition
# PARTUUID is a partition table level UUID for the partition, a feature of GPT partitioned disks
# UUID is a file system UUID which is retrieved from the filesystem metadata inside a partion

PARTITION_TARGET="/dev/sda1"
function usage
{
    echo "usage: ./partUUID.sh [partition [-p partition ]  | [-h]]"
    echo "-p | --partition ; default /dev/sda1"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -p | --partition )      shift
				PARTITION_TARGET=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                    
                               ;;
    esac
    shift
done

PARTUUID_STRING=$(sudo blkid -o value -s PARTUUID $PARTITION_TARGET)
echo PARTUUID of Partition: $PARTITION_TARGET
echo $PARTUUID_STRING
echo 
echo Sample snippet for /boot/extlinux/extlinux.conf entry:
echo 'APPEND ${cbootargs} root=PARTUUID='$PARTUUID_STRING rootwait rootfstype=ext4
