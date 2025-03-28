#!/bin/bash

# Script for backing up minecraft server files.

# TO DO:
# ALERT SERVER 30,15,5,1 min before backup.
#/server "Server will reboot in $Minutes for daily backup."
# screen -S MinecraftServer -X stuff "/say 'Server backup in 30 minutes...'"

# wait for server to run.
# while
#if no ps  | grep java

# start screen session if not already active.
StartScreen()
{
    screen -r MinecraftServer
}

# Start the server via screen.
StartServer()
{
    screen -S MinecraftServer -X stuff "./start_server.sh"
}

# Save server
SaveServer()
{
    screen -S MinecraftServer -X stuff "/save-all"
}

# Stop server
StopServer()
{
    screen -S MinecraftServer -X stuff "/stop"
}

# Send a command to a screen.
ScreenCommand()
{
    # arg1 = screen name
    # arg2 = string to send
    if [ "$#" -gt 1 ]; then
	screen -S "$1" -X stuff "$2$(printf '\r')"
    fi
}

# Creates a backup folder
# Creates a tarball of the server directory.
# Copies tarball file to nas via rsync.
BackupServerDir()
{

# Define backup source and destination.
SOURCE_DIR="/home/minecraft/Server"
LOCAL_BACKUP_DIR="/home/minecraft/Backups"
NAS_BACKUP_DIR="/mnt/DataMirror/Minecraft/Backups"

# Create a timestamp for distinct file names.
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="$BACKUP_DIR_LOCAL/Save$TIMESTAMP"

# Full path to backup file.
LOCAL_BACKUP_PATH="$LOCAL_BACKUP_DIR/$BACKUP_NAME.tar.gz"
NAS_BACKUP_PATH="$NAS_BACKUP_DIR/$BACKUP_NAME.tar.gz"

# Create folder for backup files.
echo "Creating Directory $LOCAL_BACKUP_DIR"
mkdir -p "$LOCAL_BACKUP_DIR"
echo "Created Directory $LOCAL_BACKUP_DIR"

# Create local tarball.
echo "Creating tarball - please wait..."
tar --checkpoint=10000 -czf "$LOCAL_BACKUP_PATH" -C "$SOURCE_DIR" .
echo "tarball created: $LOCAL_BACKUP_PATH"

# Check if tarball was created successfully.
if [ -f "$LOCAL_BACKUP_PATH" ]; then
    echo "Backup success - Created: $LOCAL_BACKUP_PATH"
    # Copy tarball file to samba share/nas.
    echo "Copying tarball: $LOCAL_BACKUP_PATH"
    echo "to: $NAS_BACKUP_PATH"
    rsync -av --progress "$LOCAL_BACKUP_PATH" "$NAS_BACKUP_DIR/"
    # Verify if the copy was sucessful.
    if [ -f "$NAS_BACKUP_PATH" ]; then
    echo "Backup copied to NAS: $NAS_BACKUP_PATH"
    #rm "$LOCAL_BACKUP_PATH"
    #echo "local backup removed"
    else
    echo "Error: copy failure"
    fi
else
echo "Error: backup creation failure"
fi

echo "done!"
}

# overall logic / plan (just invoke this in main for less clutter in main.
Run()
{    
    ScreenName="MinecraftServer"
    # 5 min warning.
    ScreenCommand $ScreenName "/say 'Server reboot in 5 minutes.'"
    sleep 300
    # Command server to create a save.
    ScreenCommand $ScreenName "/save-all"
    # 1 min warning.
    # --
    # countdown last 30 sec for fun :)
    # --
    # turn off the server.
    ScreenCommand $ScreenName "/stop"
    # Run backup
    BackupServerDir
    # Start Server
    ScreenCommand $ScreenName "./start_server.sh"
    echo "done"
# add hard copy to screen commands for debugging! :D

   
}

# Main

# --30 minutes warning
# --10 minute warning
# --5 minute warning
# --Save server
# --1 minute warning
# --per second countdown.
# --stop server
BackupServerDir
# --start server

# end
