# MinecraftServerTools
Scripts and such to get a minecraft server downloaded, up and running on a local device. 
Some of these will require sudo privledge (for the inital setups/configs)
Tools:

User
- Create 'minecraft' user to host the server.
>Partition out from setup - TODO
- Create any needed folders in user home - TODO

Server file 
- Download server.jar
- Server startup script

Java 
- Check version
- Download JDK 21
- Assign java path

Firewall
- Forward port in firewall to allow public access to server.
- Different setups for array of popular firewall options
>firewalld
>iptables - TO DO
>ufw - TO DO

Service
- systemd service for starting a detached screen session when the machine starts.

Backups
- Communicate with the screen session started by the service to perform a backup.
- TO DO - cron job for backup

