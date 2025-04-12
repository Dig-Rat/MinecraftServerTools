 #!/bin/bash

# Script for backing up minecraft server files.

# Checks if a screen exist.
ScreenExist()
{
    # arg1 = screen name
    
    # input validation, expecting only screen name.
    if [ "$#" -ne 1 ]; then
        echo "Usage: ScreenExist <screen_name>"
        return 1
    fi
    
    # check if screen is listed.
    if ! screen -ls | grep -q "$1"; then
        echo "Screen not found: $1"
        return 1
    fi
    return 0
}

# Send a command to a screen.
ScreenCommand()
{
    # arg1 = screen name
    # arg2+n = string to send
    
    # apply first arg as local var
    local sessionName="$1"
    
    # pop/remove the first arg.
    shift
    
    # check if screen exist. 
    # exit with failure if not.
    # (expecting it to already exist)
    if ! ScreenExist sessionName; then 
        # exit with failure status if screen DNE.
        return 1
    fi
    
    # if there's multiple commands chained, run each.
    for cmd in "$@"; do
        # reattach screen
        screen -r "$sessionName" -X stuff "$cmd$(printf '\r')"
        # small delay after sending command.
        sleep 2
    done
    
    return 0
}

# Send a countdown to the server.
ServerCountdown()
{
    # arg1: screen name
    local sessionName="$1"
    # arg2: seconds
    local seconds="$2"
    for ((i=0; i<5; i++))
    done
    for ((i=seconds; i>0; i--))
        ScreenCommand $sessionName "/say 'Server reboot in $i seconds'"
        sleep 1
    done
}

# Backup the server directory to another directory
BackupLocal()
{
    local sourceDirectory="$1"
    local localBackupDirectory="$2"
    #sourceDirectory="/home/minecraft/Server"
    #localBackupDirectory="/home/minecraft/Backups"

    # Create a timestamp for distinct file names.
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local backupFileName="$localBackupDirectory/Save$timestamp"

    # Full path to backup file.
    local localBackupPath="$localBackupDirectory/$backupFileName.tar.gz"
    local nasBackupFilePath="$nasBackupDirectory/$backupFileName.tar.gz"

    # Create folder for backup files.
    echo "Creating Directory $localBackupDirectory"
    mkdir -p "$localBackupDirectory"
    echo "Created Directory $localBackupDirectory"

    # Create local tarball.
    echo "Creating tarball - please wait..."
    tar --checkpoint=1000 -czf "$localBackupPath" -C "$sourceDirectory" .
    echo "tarball created: $localBackupPath"

    # Check if tarball was created successfully.
    if [ -f "$localBackupPath" ]; then
        echo "Backup success - Created: $localBackupPath"
        return 0
    else
        echo "Error: backup creation failure"
        return 1
    fi
}

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
    echo "Sync done."
}

# overall logic / plan (just invoke this in main for less clutter in main.
Run()
{    
    # make sure users & directories provided exist.
    # add hard copy to screen commands for debugging!

    local screenName="minecraft-server"

    # 5 min warning.
    ScreenCommand $screenName "/say 'Server reboot in 5 minutes'"
    sleep 300

    # Command server to create a save.
    ScreenCommand $screenName "/save-all"

    # 1 min warning.
    ScreenCommand $screenName "/say 'Server reboot in 60 seconds'"
    sleep 30

    # Countdown last 30 seconds.
    ServerCountdown $screenName 30

    # Stop the minecraft server.
    ScreenCommand $screenName "/stop"

    # Create a tarball backup of the server directory to the backup directory
    local sourceDirectory="/home/minecraft/Server"
    local localBackupDirectory="/home/minecraft/Backups"
    BackupLocal $sourceDirectory localBackupDirectory

    # Start Server back up.
    ScreenCommand $screenName "./start_server.sh"

    echo "done"
return 0
}

# Main
Run
# end