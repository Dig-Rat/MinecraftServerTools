#!/bin/bash

# https://minecraft.wiki/w/Tutorials/Setting_up_a_server#Java_options
run_server()
{
    # Run the server file without gui.
    java -jar server.jar --nogui
    #java -Xmx1024M -Xms1024M -jar minecraft_server.1.21.1.jar nogui
    #java -Xmx4G -Xms1G -XX:SoftMaxHeapSize=3G -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar server.jar --nogui
}

# Main
run_server