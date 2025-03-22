#!/bin/bash

# Function to download the Minecraft server JAR file
download_minecraft_server()
{
    SERVER_FILE="server.jar"	
	# URL for the Minecraft server JAR file.
    SERVER_URL="https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar"
	# This is for 1.21.4
	
	# The latest link can be found here if needed.
	# https://www.minecraft.net/en-us/download/server
	
    echo "Downloading Minecraft server JAR file..."
    # Download the server JAR file using wget
    wget -O "$SERVER_FILE" "$SERVER_URL"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download complete: $SERVER_FILE"
    else
        echo "Download failed."
        exit 1
    fi
}

# Main
download_minecraft_server