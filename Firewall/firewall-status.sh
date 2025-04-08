#!/bin/bash

# Function to check UFW status and rules
check_ufw() {
    if command -v ufw &> /dev/null; then
        echo "Checking UFW status:"
        sudo ufw status verbose
        
        echo "Checking UFW Port Forwarding Rules (if any):"
        # Check for UFW port forwarding rules in /etc/ufw/before.rules
        if grep -q "PREROUTING" /etc/ufw/before.rules; then
            sudo grep -A 5 "*nat" /etc/ufw/before.rules
        else
            echo "No port forwarding rules found in UFW."
        fi
    else
        echo "UFW is not installed."
    fi
}

# Function to check Firewalld status and rules
check_firewalld() {
    if command -v firewall-cmd &> /dev/null; then
        echo "Checking Firewalld status:"
        sudo firewall-cmd --state

        echo "Checking Firewalld Rules (including Port Forwarding):"
        sudo firewall-cmd --list-all
        
        # Checking for any port forwarding zones
        echo "Checking for Firewalld Port Forwarding rules:"
        if sudo firewall-cmd --list-forward-ports | grep -q 'port'; then
            sudo firewall-cmd --list-forward-ports
        else
            echo "No port forwarding rules found in Firewalld."
        fi
    else
        echo "Firewalld is not installed."
    fi
}

# Function to check Iptables status and rules (specifically port forwarding)
check_iptables() {
    if command -v iptables &> /dev/null; then
        echo "Checking Iptables status and rules:"

        echo "Current Iptables rules:"
        sudo iptables -L -v -n
        
        echo "Checking Iptables Port Forwarding Rules (NAT Table):"
        sudo iptables -t nat -L -v -n | grep -E 'DNAT|SNAT|PREROUTING|POSTROUTING'
        
        if [ $? -ne 0 ]; then
            echo "No port forwarding rules found in Iptables."
        fi
    else
        echo "Iptables is not installed."
    fi
}

# Main function
main() {
    echo "Firewall Status and Port Forwarding Rules Checker"
    echo "-------------------------------------------------"

    # Check for UFW, Firewalld, and Iptables
    check_ufw
    echo
    check_firewalld
    echo
    check_iptables
}

# Execute the main function
main
