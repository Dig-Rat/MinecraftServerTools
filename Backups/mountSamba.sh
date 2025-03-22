#!/bin/bash

# instructions for mounting a samba share to save the files to.
# assuming samba share server already setup.

# Create mount point for samba.
sambaShareName = "DataMirror";
mountPath = "/mnt/$sambaShareName"
sudo mkdir -p /mnt/

# Mount the samba share.
sambaIp = "192.168.1.131"
sambaUser = "rat"
sambaPass = "****"
sudo mount -t cifs //$sambaIp/$sambaShareName /mnt/minecraft_backup -o username=$sambaUser,password=$sambaPass
#sudo mount -t cifs //NAS_IP_ADDRESS/share_name /mnt/minecraft_backup -o username=your_username,password=your_password


# for automatic mounting, add this line to /etc/fstab
#//NAS_IP_ADDRESS/share_name /mnt/minecraft_backup cifs username=your_username,password=your_password 0 0

#echo "//NAS_IP_ADDRESS/share_name /mnt/minecraft_backup cifs username=your_username,password=your_password 0 0" >> /etc/fstab

#echo "//NAS_IP_ADDRESS/share_name /mnt/minecraft_backup cifs username=your_username,password=your_password 0 0" >> mountfile
#cat mountfile >> /etc/fstab
#rm mountfile
