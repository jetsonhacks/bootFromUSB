#!/bin/bash
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

# The updater script fixes an issue on L4T 32.5 on Jetson Nano where it is unable to load kernel, kernel-dtb and initrd from USB or NVME. 

# Download the payload updater script
wget -N https://developer.nvidia.com/l4t-payload-updater-t210 -O l4t_payload_updater_t210
# Make sure we downloaded it
if [ -f "l4t_payload_updater_t210" ]; then
   # Make the script executable
   sudo chmod a+x l4t_payload_updater_t210
   # Copy it over to the correct place in /usr/sbin
   sudo cp l4t_payload_updater_t210 /usr/sbin
else
   echo "Unable to download update file: l4t-payload-updater-t210 "
   echo "You will need to fix this before you can boot from USB on the Jetson Nano"
fi


