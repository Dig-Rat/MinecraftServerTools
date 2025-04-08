#!/bin/bash

# Minecraft: 25565
# Terraria: 7777

# Config firewall for port-forwarding using firewalld.
firewalld_port_forward()
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

# Main
firewalld_port_forward