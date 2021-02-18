#!/bin/bash
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License
# Copy the root directory to the given volume 

DESTINATION_TARGET=""
VOLUME_LABEL=""

function usage
{
    echo "usage: ./copyRootToUSB.sh [OPTION]"
    echo "-d | --directory <directory>	Directory path to parent of kernel)"
    echo "-p | --path <path>		e.g. /dev/sda1"
    echo "-v | --volume_label		Name of the volume label"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )      shift
				DESTINATION_TARGET=$1
                                ;;
        -v | --volume_label )   shift
                                VOLUME_LABEL=$1
                                ;;
        -p | --path )           shift
                                DEVICE_PATH=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit
                                ;;
    esac
   shift
done

if [ "$DEVICE_PATH" != "" ] ; then
   echo "Device Path: "$DEVICE_PATH
   DESTINATION_TARGET=$(findmnt -rno TARGET "$DEVICE_PATH")
   if [ "$DESTINATION_TARGET" = "" ] ; then
      echo "Unable to find the mount point of: ""$DEVICE_PATH"
      exit 1
   fi
else
   if [ "$DESTINATION_TARGET" = "" ] ; then
      if [ "$VOLUME_LABEL" = "" ] ; then
         # No destination path, no volume label
         usage
         exit 1
      else
         DEVICE_PATH=$(findfs LABEL="$VOLUME_LABEL")
         if [ "$DEVICE_PATH" = "" ] ; then
            echo "Unable to find mounted volume: ""$VOLUME_LABEL"
            exit 1
         else
            echo "Device Path: "$DEVICE_PATH
            DESTINATION_TARGET=$(findmnt -rno TARGET "$DEVICE_PATH")
            echo "Destination Target: "$DESTINATION_TARGET
            if [ "$DESTINATION_TARGET" = "" ] ; then
               echo "Unable to find the mount point of: ""$VOLUME_LABEL"
               exit 1
            fi
          fi
       fi
    fi
fi

echo "Target: "$DESTINATION_TARGET
# apt-get update should make rsync available on a new system
sudo apt-get update
sudo apt-get install rsync -y 
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / "$DESTINATION_TARGET"

