# TLDR - How to use
Log on to your Ubuntu machine intended to be a server.

Download the latest release .zip on the right.

Find the file, extract it, go into that folder.

Right click on mcsrv.sh, go to Properties and do 2 things:
1) Make mcsrv.sh "Executable as a Program"
2) Click Permissions -> Others -> Access -> Change to "Read and Write"

Then, inside the mcsrv-x.x.x folder, right click -> Open in Terminal

Enter the following to run the install your Minecraft server
```
sudo ./mcsrv.sh
```

# mcsrv - Full Description
This script installs the latest Minecraft Bedrock server directly from minecraft.net on Ubuntu Linux & all Debian-based systems and sets up an updater to run everyday at 2am.  It has been tested on Ubuntu 24 and should work for all Debain-based Linux systems.  The server is installed to /opt/YOUR_SERVER_NAME and the updater is installed to /usr/local/bin/mcupdater.sh

## Features

- **Environment Checks**: Ensures the script is run with sudo privileges and checks for a supported operating system (Ubuntu or Debian).
- **Port Availability**: Verifies that the default ports (`19132` for IPv4 and `19133` for IPv6) are not in use by other processes.
- **Dependency Installation**: Updates package lists and installs `wget`, `unzip`, and `supervisor`.
- **Server Download and Setup**: Downloads the latest Minecraft Bedrock Edition server, extracts it to the specified directory, and configures server properties.
- **User Management**: Creates a dedicated user for running the Minecraft server.
- **Supervisor Configuration**: Sets up a supervisor configuration to manage the Minecraft server process, ensuring it starts automatically and restarts on failure.
- **Firewall Rules**: Checks if `iptables` is installed and configures it to allow UDP traffic on the specified port.
- **Verification**: Confirms the server is running and listening on the specified port.

## Basic Install Options

- Server name
- Level name
- Gamemode
- Difficulty
- Allow cheats
- Number of players

## Advanced Install Options
Advanced is really only needed if installing a 2nd Minecraft server on the same LAN

- Force gamemode
- Server port
- Server portv6
- Lan Visability
- Online mode
- Allow list
- View distance
- Player idle timeout
- Max threads
- Tick distance
- Default player permission level
- Texture pack required
- Content log file
- Compression threshold
- Compression algorithm
- Server authoritative movement
- Player position acceptance threshold
- Movement action directionthreshold
- Server authoritative block breaking
- Chat restriction
- Disable Player interation
- Client side chunk generation
- Block network IDs as hashes
- Custom skins
- Server build radius ratio


## Usage

Run the script with sudo privileges on a Ubuntu or Debian system:
```
  sudo ./mcsrv.sh
```
The script will handle the entire setup process, and upon completion, your Minecraft Bedrock server will be up and running. You can interact with the server's command-line console using:
```
  sudo supervisorctl fg YOUR_SERVER_NAME
```





## Features

- **Find Installations: Searches the file system for existing Minecraft Bedrock server installations.
- **User Selection: Prompts the user to select which installation to update if multiple installations are found.
- **Version Check: Compares the current server version with the latest available version to determine if an update is needed.
- **Backup and Update: Backs up the current server directory before applying the update to ensure data integrity.
- **Supervisor Control: Stops the server using Supervisor before updating and restarts it afterward.

## Usage

Run the script with sudo privileges on a Linux system:
```
  sudo ./update-bedrock-server.sh
```
The script will guide you through selecting an installation to update and handle the update process if a newer version is available.

## Cleanup

This script does not automatically delete the backup or the latest downloaded zip file. You will need to manage these files manually to ensure your system does not run out of storage space.

## Consideration

If you want to automate the update process, you can add this script to cron and run it periodically. For example, to run the script daily at midnight, add the following line to your crontab file (crontab -e):
```
  0 0 * * * /bin/echo "u" | /bin/bash /path/to/update-bedrock-server.sh
```
Ensure the script has the necessary permissions and is executable:
