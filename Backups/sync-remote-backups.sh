 #!/bin/bash

# Sync local backup folder with remote backup folder.
SyncDirectories()
{
    # arg1: Source directory.
    local sourceDirectory="$1"
    # arg2: Target directory.
    local targetDirectory="$2"
    
    echo "Syncing directory $sourceDirectory with $targetDirectory"
    # recursively sync remote directory with local directory
    # -a: archive mode
    # -v: verbose
    # -h: human readable
    rsync -avh --progress "$sourceDirectory"/ "$targetDirectory"/
    
    # Validation step
    echo "Validating backup..."

    # Compare the source and target directory contents
    # -q: quiet (only report differences)
    # -r: recursive
    if diff -qr "$sourceDirectory" "$targetDirectory"; then
        echo "Backup copied and verified successfully."
        return 0
    else
        echo "Error: backup validation failed. Differences found between source and target."
        return 1
    fi
    echo "Sync done"
}

### Main ###
echo "Remote Sync Started"
# Local directory containing backups.
local sourceDirectory="/home/minecraft/Backups"
# Remote directory [on samba share] containing backup copies.
local targetDirectory="/mnt/DataMirror/Minecraft/Backups"
SyncDirectories $sourceDirectory $targetDirectory
echo "Remote Sync Done"