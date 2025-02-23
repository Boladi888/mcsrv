# TLDR - How to use
Log on to your Ubuntu machine intended to be a server.

Download the ZIP from the "<> Code" dropdown.

Find the file, extract it, go into that folder.

Right click on mcsrv.sh, go to Properties and do 2 things:
1) Make mc_srv.sh "Executable as a Program"
2) Click Permissions -> Others -> Access -> Change to "Read and Write"

Then, inside the mcsrv-main folder, right click -> Open in Terminal

Enter the following to install your Minecraft server
```
  sudo ./mcsrv.sh
```

# mcsrv - Full Description
This script installs the latest Minecraft Bedrock server directly from minecraft.net on Ubuntu Linux & all Debian-based systems and sets up an updater to run everyday at 2am.  It has been tested on Ubuntu 24 and should work for all Debain-based Linux systems.  

The server is installed to /opt/YOUR_SERVER_NAME

The updater is installed to /usr/local/bin/mcupdater.sh

## Intaller Features

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

### Note that all of these options can be configured from within Minecraft as an Operator

## Usage

Run the script with sudo privileges on a Ubuntu or Debian system:
```
  sudo ./mcsrv.sh
```
The script will handle the entire setup process, and upon completion, your Minecraft Bedrock server will be up and running. You can interact with the server's command-line console using:
```
  sudo supervisorctl fg YOUR_SERVER_NAME
```
To manually run the updater
```
  sudo /usr/local/bin/mcupdater.sh
```

## Updater Features

- **Find Installations: Searches the file system for existing Minecraft Bedrock server installations.
- **User Selection: Prompts the user to select which installation to update if multiple installations are found.
- **Version Check: Compares the current server version with the latest available version to determine if an update is needed.
- **Backup and Update: Backs up the current server directory before applying the update to ensure data integrity.
- **Supervisor Control: Stops the server using Supervisor before updating and restarts it afterward.
