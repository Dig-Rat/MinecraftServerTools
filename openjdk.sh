#!/bin/bash

# purpose: download & install java openjdk21

# everything except the profile configs should be done as root/sudo.

# install the system's default latest openjdk.
install_default()
{
    sudo apt update
    sudo apt install -y default-jdk
    #sudo apt install -y default-jde
}

# download openjdk 21
install_openjdk21()
{
    download_openjdk21
    move_jdk
    config_bashrc
    config_profile
    echo "OpenJDK 21 installation is complete!"
}

# Download the OpenJDK 21 binaries and extract the tarball
download_openjdk21()
{
    echo "Downloading..."
    wget https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz
    echo "Extracting..."
    tar -xzf openjdk-21_linux-x64_bin.tar.gz
}

# Move the extracted folder to /opt
move_jdk()
{
    echo "Moving JDK to /opt/..."
    sudo mv jdk-21 /opt/
}

# Set environment variables to use OpenJDK 21 via .bashrc
config_bashrc()
{
    # export JAVA_HOME=/opt/jdk-21
    # export PATH=$JAVA_HOME/bin:$PATH
    echo "Setting up environment variables..."
    echo 'export JAVA_HOME=/opt/jdk-21' >> ~/.bashrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc    

    # Apply the changes by sourcing .bashrc
    echo "Applying changes..."
    source ~/.bashrc
}

# Set environment variables to use OpenJDK 21 via .profile:
config_profile()
{
    # export JAVA_HOME=/opt/jdk-21
    # export PATH=$JAVA_HOME/bin:$PATH
    echo "Setting up environment variables..."    
    echo 'export JAVA_HOME=/opt/jdk-21' >> ~/.profile
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.profile

    # Apply the changes by sourcing .bashrc
    echo "Applying changes..."
    source ~/.profile
}

# Change default JDK if needed. -- TO DO
change_default()
{
    sudo update-java-alternatives --set openjdk-21
}

# check java version.
java_version()
{
    java -version
}

# Main
install_default
install_openjdk21
java_version