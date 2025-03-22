#!/bin/bash

# Script for backing up minecraft server files.

# TO DO:
# Make local rync backup of files.
# backup locally too but only keep latest n versions.

############

# Define backup source and destination.
MINECRAFT_DIR="/home/minecraft/Server"
BACKUP_DIR="/mnt/DataMirror/Minecraft/Backups"

# Create a timestamped name for the backup folder.
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="$BACKUP_DIR/Save$TIMESTAMP"

# Create folder for backup files.
mkdir -p "$BACKUP_PATH"

# Copy Minecraft server files (worlds, configurations, etc.)
cp -r "$MINECRAFT_DIR" "$BACKUP_PATH"

# Compress the backup to a tarball.
tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "Save$TIMESTAMP"

# Remove the uncompressed backup folder after compression.
rm -rf "$BACKUP_PATH"
