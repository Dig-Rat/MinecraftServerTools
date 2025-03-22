#!/bin/bash

# reference material
# https://minecraft.wiki/w/Tutorials/Setting_up_a_server
# https://www.linode.com/docs/guides/how-to-set-up-minecraft-server-on-ubuntu-or-debian/


# Function to check if Java is installed
check_java_installed() 
{
    if command -v java &> /dev/null; then
        echo "Java is already installed."
        return 0
    else
        echo "Java is not installed."
        return 1
    fi
}

# Function to install the latest openjdk
install_openjdk()
{
    echo "Updating package list..."
    sudo apt update
    echo "Installing the latest Java version..."
    sudo apt install -y openjdk-17-jdk
    echo "Java installation complete."
}

# Function to download the Minecraft server JAR file
download_minecraft_server() {
    # URL for the Minecraft server JAR file
    SERVER_URL="https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar"
    SERVER_FILE="minecraft_server.jar"

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

# Create the user to host the server on - TODO
add_user()
{
    # Add user for hosting minecraft
    adduser minecraft
    # assign password for the new user.
    passwd minecraft
}

# Config firewall for port-forwarding.
config_firewall()
{
    # Static IP of device.
    INTERNAL_IP="192.168.1.23"
    # Minecraft port
    PORT="25565"
    # Step 1: Install firewalld if not already installed
    echo "Installing firewalld..."
    sudo apt update
    sudo apt install -y firewalld
    # Step 2: Start and enable firewalld service
    echo "Starting and enabling firewalld..."
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    # Step 3: Enable IP forwarding
    echo "Enabling IP forwarding..."
    sudo firewall-cmd --permanent --add-masquerade
    # Step 4: Add port forwarding rule
    echo "Adding port forwarding rule for port $PORT..."
    sudo firewall-cmd --permanent --add-forward-port=port=$PORT:proto=tcp:toaddr=$INTERNAL_IP:toport=$PORT
    # Step 5: Reload firewalld to apply changes
    echo "Reloading firewalld..."
    sudo firewall-cmd --reload
    # Verify configuration
    echo "Current firewalld settings:"
    sudo firewall-cmd --list-all
    echo "Port forwarding on port $PORT has been configured with firewalld."
}

# Run server - TODO
run_server()
{
    # Run the server file without gui.
    java -Xmx1024M -Xms1024M -jar minecraft_server.1.21.1.jar nogui 
}

# Main script logic.
# update packages.
sudo apt update && sudo apt upgrade
#
if check_java_installed; then
    echo "Proceeding with Minecraft server download..."
else
    install_java
fi

download_minecraft_server

#end