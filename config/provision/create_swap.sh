#!/bin/bash

if [ -f '/swapfile' ]
then
	echo "swap file already exists"
	exit 0
fi
echo "creating swap file"
sudo fallocate -l 1024M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# !root olmak gerekiyor
echo '/swapfile   none    swap    sw    0   0' > /etc/fstab

