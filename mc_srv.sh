#!/bin/bash

# Welcome message
echo 
echo "Welcome to Boladi's Super-Easy Minecraft Server Install Script!"
echo "Hit ctrl-c to exit at any time"
echo "https://github.com/Boladi888/minecraft-bedrock-tools"
echo "web3boladi@gmail.com"
echo
read -n 1 -s -r -p "Press any key to continue..."
echo

# Check if the script is being run with sudo privileges.
if [ "$(id -u)" != "0" ]; then
    echo
    echo "This script must be run with sudo. Exiting."
    exit 1

# Check if is Ubuntu or Debian Linux
elif [ ! -f /etc/os-release ] || ( . /etc/os-release && [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]); then
    echo
    echo "This is unsupported OS. Minecraft Bedrock Edition is only suported on Ubuntu or Debian"
    exit 1
fi

# Prompt user to select mode
while true; do
    echo
    echo "Select Basic for only the most important options and this computer is the only Minecraft server on the network"
    echo "Advanced for all of the options"
    echo "Most of these options can be changed later"
    echo "1. Basic"
    echo "2. Advanced"
    read -p "Enter the number corresponding to the mode: " mode_choice
    case $mode_choice in
        1) mode="basic"; break ;;
        2) mode="advanced"; break ;;
        *) echo "Invalid option. Please select 1 or 2." ;;
    esac
done

# Basic mode options
# These will always be prompted regardless of the mode
while true; do
    echo
    echo "Enter the server name (no semicolons allowed):"
    read server_name
    if [[ "$server_name" != *";"* ]]; then
        break
    else
        echo "Invalid input. Semicolons are not allowed."
    fi
done

# Prompt for level-name
while true; do
    echo
    echo "Enter the level name (no semicolons allowed):"
    read level_name
    if [[ "$level_name" != *";"* && "$level_name" != "" ]]; then
        break
    else
        echo "Invalid input. Please enter a valid level name without semicolons."
    fi
done

# Prompt user for game mode
while true; do
	echo
    echo "Select the game mode:"
	echo "1. Survival"
	echo "2. Creative"
	echo "3. Adventure"
	read -p "Enter the number corresponding to the game mode: " gamemode
    case $gamemode in
        1) gamemode="survival"; break ;;
        2) gamemode="creative"; break ;;
        3) gamemode="adventure"; break ;;
        *) echo "Invalid option. Please select 1, 2, or 3." ;;
    esac
done

# Prompt user for difficulty
while true; do
	echo
    echo "Select the difficulty level:"
	echo "1. Peaceful"
	echo "2. Easy"
	echo "3. Normal"
	echo "4. Hard"
	read -p "Enter the number corresponding to the difficulty level: " difficulty
    case $difficulty in
        1) difficulty="peaceful"; break ;;
        2) difficulty="easy"; break ;;
        3) difficulty="normal"; break ;;
        4) difficulty="hard"; break ;;
        *) echo "Invalid option. Please select 1, 2, 3, or 4." ;;
    esac
done

# Code to prompt user for allow-cheats option
while true; do
    echo
    echo "Allow cheats:"
    echo "1. True"
    echo "2. False"
    read -p "Enter the number corresponding to allow cheats (true or false): " allow_cheats
    case $allow_cheats in
        1) allow_cheats="true"; break ;;
        2) allow_cheats="false"; break ;;
        *) echo "Invalid option. Please select 1 or 2." ;;
    esac
done

#Max players
while true; do
    echo
    echo "Enter the maximum number of players (must be an integer):"
    read max_players
    if [[ "$max_players" =~ ^[0-9]+$ ]]; then
        break
    else
        echo "Invalid input. Please enter an integer."
    fi
done

#Set some default variables
server=$server_name
user='minecraft_user'
installation_dir="/opt/$server"
force_gamemode="false"
server_port=19132
server_portv6=19133
enable_lan_visibility="true"
level_seed=""
online_mode="true"
allow_list="false"
view_distance=32
player_idle_timeout=30
max_threads=8
tick_distance=4
default_player_permission_level="member"
texturepack_required="false"
content_log_file_enabled="false"
compression_threshold=1
compression_algorithm="zlib"
server_authoritative_movement="server-auth"
player_position_acceptance_threshold=0.5
player_movement_action_direction_threshold=0.85
server_authoritative_block_breaking="false"
server_authoritative_block_breaking_pick_range_scalar=1.5
chat_restriction="None"
disable_player_interaction="false"
client_side_chunk_generation_enabled="true"
block_network_ids_are_hashes="true"
disable_persona="false"
disable_custom_skins="false"
server_build_radius_ratio="Disabled"



# Check if already installed
if [ -d "$installation_dir" ]; then
    echo "Directory $installation_dir already exists. Exiting."
    exit 1
fi

# Advanced mode options
if [ "$mode" = "advanced" ]; then
    # Prompt for force-gamemode
    while true; do
        echo
        echo "Force gamemode"
        echo "force-gamemode=false prevents the server from sending to the client gamemode values other than the gamemode value saved by the server during world creation even if those values are set in server.properties file after world creation."
        echo "force-gamemode=true forces the server to send to the client gamemode values other than the gamemode value saved by the server during world creation if those values are set in server.properties file after world creation."
        echo "1. True"
        echo "2. False (default)"
        read -p "Enter the number corresponding to force gamemode: " force_gamemode
        case $force_gamemode in
            1) force_gamemode="true"; break ;;
            2) force_gamemode="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done
    # Prompt for server-port
    while true; do
        echo
        echo "Enter the server port (integer between 1024 and 65535, default is 19132):"
        echo "Values below 1024 may be used, but are generally reserved for well-known applications."
        read server_port
        if [[ "$server_port" -ge 1024 && "$server_port" -le 65535 ]]; then
            break
        else
        echo "Invalid input. Please enter a value between 1024 and 65535."
        fi
    done

    # Prompt for server-portv6
    while true; do
        echo
        echo "Enter the server port (IPv6) (integer between 1024 and 65535, default is 19133):"
        echo "Values below 1024 may be used, but are generally reserved for well-known applications."
        read server_portv6
        if [[ "$server_portv6" -ge 1024 && "$server_portv6" -le 65535 ]]; then
            break
        else
            echo "Invalid input. Please enter a value between 1024 and 65535."
        fi
    done

    # Prompt for enable-lan-visibility
    while true; do
        echo
        echo "Enable LAN visibility"
        echo "Listen and respond to clients that are looking for servers on the LAN. This will cause the server to bind to the default ports (19132, 19133) even when 'server-port' and 'server-portv6' have non-default values. Consider turning this off if LAN discovery is not desirable, or when running multiple servers on the same host may lead to port conflicts."
        echo "1. True"
        echo "2. False"
        read -p "Enter the number corresponding to enable LAN visibility (default is true): " enable_lan_visibility
        case $enable_lan_visibility in
            1) enable_lan_visibility="true"; break ;;
            2) enable_lan_visibility="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done
    # Prompt for level-seed
    echo
    echo "Enter the level seed (optional):"
    echo "The seed to be used for randomizing the world. If left empty a seed will be chosen at random."
    echo "Press Enter for random"
    read level_seed

    # Prompt for online-mode
    while true; do
        echo
        echo "Online mode"
        echo "If true, all connected players must be authenticated with Xbox Live. Clients connecting to remote (non-LAN) servers will always require Xbox Live authentication regardless of this setting. If the server accepts connections from the Internet, then it is highly recommended to enable online-mode."
        echo "1. True"
        echo "2. False"
        read -p "Enter the number corresponding to online mode (default is true): " online_mode
        case $online_mode in
            1) online_mode="true"; break ;;
            2) online_mode="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for allow-list
    while true; do
        echo
        echo "Allow list"
        echo "If true then all connected players must be listed in the separate allowlist.json file. See the Allowlist section."
        echo "1. True"
        echo "2. False"
        read -p "Enter the number corresponding to allow list (default is false): " allow_list
        case $allow_list in
            1) allow_list="true"; break ;;
            2) allow_list="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for view-distance
    while true; do
        echo
        echo "Enter the view distance:"
        echo "The maximum allowed view distance. Higher values have performance impact."
        echo "must be an integer greater than 5, default is 32"
        read view_distance
        if [[ "$view_distance" -gt 5 ]]; then
            break
        else
            echo "Invalid input. Please enter an integer greater than 5."
        fi
    done

    # Prompt for player-idle-timeout
    while true; do
        echo
        echo "Enter the player idle timeout (must be a positive integer, including 0, default is 30):"
        echo "After a player has idled for this many minutes they will be kicked. If set to 0 then players can idle indefinitely."
        read player_idle_timeout
        if [[ "$player_idle_timeout" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Please enter a positive integer."
        fi
    done

    # Prompt for max-threads
    while true; do
        echo
        echo "Enter the maximum number of threads (must be an integer, default is 8):"
        echo "Maximum number of threads the server will try to use. If set to 0 or removed then it will use as many as possible."
        read max_threads
        if [[ "$max_threads" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Please enter an integer."
        fi
    done

    # Prompt for tick-distance
    while true; do
        echo
        echo "Enter the tick distance (integer in the range [4, 12], default is 4):"
        echo "The world will be ticked this many chunks away from any player. Higher values have performance impact."
        read tick_distance
        if [[ "$tick_distance" -ge 4 && "$tick_distance" -le 12 ]]; then
            break
        else
            echo "Invalid input. Please enter a value between 4 and 12."
        fi
    done

    # Prompt for default-player-permission-level
    while true; do
        echo
        echo "Select the default player permission level:"
        echo "Which permission level new players will have when they join for the first time."
        echo "1. Visitor"
        echo "2. Member"
        echo "3. Operator"
        read -p "Enter the number corresponding to the default player permission level (default is member): " default_player_permission_level
        case $default_player_permission_level in
            1) default_player_permission_level="visitor"; break ;;
            2) default_player_permission_level="member"; break ;;
            3) default_player_permission_level="operator"; break ;;
            *) echo "Invalid option. Please select 1, 2, or 3." ;;
        esac
    done

    # Prompt for texturepack-required
    while true; do
        echo
        echo "Texture pack required"
        echo "If the world uses any specific texture packs then this setting will force the client to use it."
        echo "1. True"
        echo "2. False"
        read -p "Enter the number corresponding to texture pack required (default is false): " texturepack_required
        case $texturepack_required in
            1) texturepack_required="true"; break ;;
            2) texturepack_required="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for content-log-file-enabled
    while true; do
        echo
        echo "Content log file enabled"
        echo "Enables logging content errors to a file."
        echo "1. True"
        echo "2. False"
        read -p "Enter the number corresponding to content log file enabled (default is false): " content_log_file_enabled
        case $content_log_file_enabled in
            1) content_log_file_enabled="true"; break ;;
            2) content_log_file_enabled="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for compression-threshold
    while true; do
        echo
        echo "Enter the compression threshold (integer in the range [0-65535], default is 1):"
        echo "Determines the smallest size of raw network payload to compress. Can be used to experiment with CPU-bandwidth tradeoffs."
        read compression_threshold
        if [[ "$compression_threshold" -ge 0 && "$compression_threshold" -le 65535 ]]; then
            break
        else
            echo "Invalid input. Please enter a value between 0 and 65535."
        fi
    done
    # Prompt for compression-algorithm
    while true; do
        echo
        echo "Select the compression algorithm"
        echo "Determines the compression algorithm to use for networking."
        echo "1. zlib (default)"
        echo "2. snappy"
        read -p "Enter the number corresponding to the compression algorithm (default is zlib): " compression_algorithm
        case $compression_algorithm in
            1) compression_algorithm="zlib"; break ;;
            2) compression_algorithm="snappy"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for server-authoritative-movement
    while true; do
        echo
        echo "Select the server authoritative movement"
        echo "Changes the server authority on movement:"
        echo "\"client-auth\": Server has no authority and accepts all positions from the client."
        echo "\"server-auth\": Server takes user input and simulates the Player movement but accepts the Client version if there is disagreement."
        echo "\"server-auth-with-rewind\": The server will replay local user input and will push it to the Client so it can correct the position if it does not match. The clients will rewind time back to the correction time, apply the correction, then replay all the player's inputs since then. This results in smoother and more frequent corrections."
        echo "1. client-auth"
        echo "2. server-auth (default)"
        echo "3. server-auth-with-rewind"
        read -p "Enter the number corresponding to the server authoritative movement (default is server-auth): " server_authoritative_movement
        case $server_authoritative_movement in
            1) server_authoritative_movement="client-auth"; break ;;
            2) server_authoritative_movement="server-auth"; break ;;
            3) server_authoritative_movement="server-auth-with-rewind"; break ;;
            *) echo "Invalid option. Please select 1, 2, or 3." ;;
        esac
    done

    # Prompt for player-position-acceptance-threshold
    while true; do
        echo
        echo "Enter the player position acceptance threshold (positive float)"
        echo "This is the tolerance of discrepancies between the Client and Server Player position. This helps in problematic scenarios. The higher the number, the more tolerant the server will be before asking for a correction. Passed value of 1.0, the chance of missing cheating increases."
        echo "Default is 0.5"
        read player_position_acceptance_threshold
        if [[ "$player_position_acceptance_threshold" =~ ^[0-9]*\.?[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Please enter a positive float."
        fi
    done

    
   # Prompt for player-movement-action-direction-threshold
    echo
    echo "Enter the player movement action direction threshold (default is 0.85):"
    echo "Range: [-1.00, 1.00]"
    echo "The amount that the direction the player is attacking can differ from the direction the player is looking as cos(x) where x is the angle between the two vectors. A value of 1 means the two vectors must be parallel, 0 means anything in front of the player, and -1 means any vector."
    echo "Default is 0.85"
    read player_movement_action_direction_threshold

    # Prompt for server-authoritative-block-breaking
    while true; do
        echo
        echo "Server authoritative block breaking"
        echo "If true, the server will compute block mining operations in sync with the client so it can verify that the client should be able to break blocks when it thinks it can. This setting cannot be combined with client authoritative movement and will be disabled if that setting is enabled."
        echo "1. True"
        echo "2. False (default)"
        read -p "Enter the number corresponding to server authoritative block breaking (default is false): " server_authoritative_block_breaking
        case $server_authoritative_block_breaking in
            1) server_authoritative_block_breaking="true"; break ;;
            2) server_authoritative_block_breaking="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    echo
    echo "Enter the server authoritative block breaking pick range scalar (default is 1.5):"
    echo "This increases the range of block breaking. This is squared and multiplied with the default range."
    read server_authoritative_block_breaking_pick_range_scalar

    # Prompt for chat-restriction
    while true; do
        echo
        echo "Select the chat restriction"
        echo "This represents the level of restriction applied to the chat for each player that joins the server. \"None\" is the default and represents regular free chat. \"Dropped\" means the chat messages are dropped and never sent to any client. Players receive a message to let them know the feature is disabled. \"Disabled\" means that unless the player is an operator, the chat UI does not even appear. No information is displayed to the player."
        echo "1. None (default)"
        echo "2. Dropped"
        echo "3. Disabled"
        read -p "Enter the number corresponding to the chat restriction (default is None): " chat_restriction
        case $chat_restriction in
            1) chat_restriction="None"; break ;;
            2) chat_restriction="Dropped"; break ;;
            3) chat_restriction="Disabled"; break ;;
            *) echo "Invalid option. Please select 1, 2, or 3." ;;
        esac
    done

    # Prompt for disable-player-interaction
    while true; do
        echo
        echo "Disable player interaction"
        echo "If true, the server will inform clients that they should ignore other players when interacting with the world. This is not server authoritative."
        echo "1. True"
        echo "2. False (default)"
        read -p "Enter the number corresponding to disable player interaction (default is false): " disable_player_interaction
        case $disable_player_interaction in
            1) disable_player_interaction="true"; break ;;
            2) disable_player_interaction="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for client-side-chunk-generation-enabled
    while true; do
        echo
        echo "Client-side chunk generation enabled"
        echo "If true, the server will inform clients that they have the ability to generate visual level chunks outside of player interaction distances."
        echo "1. True (default)"
        echo "2. False"
        read -p "Enter the number corresponding to client-side chunk generation enabled (default is true): " client_side_chunk_generation_enabled
        case $client_side_chunk_generation_enabled in
            1) client_side_chunk_generation_enabled="true"; break ;;
            2) client_side_chunk_generation_enabled="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    # Prompt for block-network-ids-are-hashes
    while true; do
        echo
        echo "Block network IDs are hashes"
        echo "If true, the server will send hashed block network ID's instead of id's that start from 0 and go up. These id's are stable and won't change regardless of other block changes."
        echo "1. True (default)"
        echo "2. False"
        read -p "Enter the number corresponding to block network IDs are hashes (default is true): " block_network_ids_are_hashes
        case $block_network_ids_are_hashes in
            1) block_network_ids_are_hashes="true"; break ;;
            2) block_network_ids_are_hashes="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done

    while true; do
        echo
        echo "Disable custom skins"
        echo "If true, disable players customized skins that were customized outside of the Minecraft store assets or in game assets. This is used to disable possibly offensive custom skins players make."
        echo "1. True"
        echo "2. False (default)"
        read -p "Enter the number corresponding to disable custom skins (default is false): " disable_custom_skins
        case $disable_custom_skins in
            1) disable_custom_skins="true"; break ;;
            2) disable_custom_skins="false"; break ;;
            *) echo "Invalid option. Please select 1 or 2." ;;
        esac
    done
    # Prompt for server-build-radius-ratio
    while true; do
        echo
        echo "Select edit the server build radius ratio:"
        echo "0. Disabled (default). If "Disabled" the server will dynamically calculate how much of the player's view it will generate, assigning the rest to the client to build. Otherwise from the overridden ratio tell the server how much of the player's view to generate, disregarding client hardware capability. Only valid if client-side-chunk-generation-enabled is enabled."
        echo "1. Enter a value between 0.0 and 1.0"
        read -p "Enter the number corresponding to edit server build radius ratio (default is Disabled): " server_build_radius_ratio
        if [[ "$server_build_radius_ratio" == "0" ]]; then
            server_build_radius_ratio="Disabled"
            break
        elif [[ "$server_build_radius_ratio" == "1" ]]; then
            read -p "Enter a value between 0.0 and 1.0: " server_build_radius_ratio
            break
        else
            echo "Invalid option. Please select 0 or 1."
        fi
    done
fi

# Check if ports are available
if ss -nlup | grep -q ":$server_port"; then
    echo "Port $server_port is being used by another process."
    exit 1
fi

if ss -nlup | grep -q ":$server_portv6"; then
    echo "Port $server_portv6 is being used by another process."
    exit 1
fi

# Update package lists and install required dependencies
apt-get update -y
apt-get install -y wget unzip supervisor curl

# Download and install lateast Minecraft Bedrock Edition Server.
source=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock)

link=$(echo "$source" | grep -o '"https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-[^"]*"' | sed 's/"//g') 

zip_file=$(basename "$link")

wget --header="Referer: https://www.minecraft.net/en-us/download/server/bedrock" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" -P /tmp "$link"
if [ $? -ne 0 ]; then
    echo "Failed to download $zip_file. Exiting."
    exit 1
fi

useradd -M $user && usermod -L $user

unzip -o /tmp/"$zip_file" -d $installation_dir

# Update server options in server.properties
sed -i "s/server-name=.*/server-name=$server_name/" "$installation_dir/server.properties"
sed -i "s/server-port=.*/server-port=$server_port/" "$installation_dir/server.properties"
sed -i "s/server-portv6=.*/server-portv6=$server_portv6/" "$installation_dir/server.properties"
sed -i "s/gamemode=.*/gamemode=$gamemode/" "$installation_dir/server.properties"
sed -i "s/allow-cheats=.*/allow-cheats=$allow_cheats/" "$installation_dir/server.properties"
sed -i "s/force-gamemode=.*/force-gamemode=$force_gamemode/" "$installation_dir/server.properties"
sed -i "s/difficulty=.*/difficulty=$difficulty/" "$installation_dir/server.properties"
sed -i "s/max-players=.*/max-players=$max_players/" "$installation_dir/server.properties"
sed -i "s/enable-lan-visibility=.*/enable-lan-visibility=$enable_lan_visibility/" "$installation_dir/server.properties"
sed -i "s/level-name=.*/level-name=$level_name/" "$installation_dir/server.properties"
sed -i "s/level-seed=.*/level-seed=$level_seed/" "$installation_dir/server.properties"
sed -i "s/online-mode=.*/online-mode=$online_mode/" "$installation_dir/server.properties"
sed -i "s/allow-list=.*/allow-list=$allow_list/" "$installation_dir/server.properties"
sed -i "s/view-distance=.*/view-distance=$view_distance/" "$installation_dir/server.properties"
sed -i "s/player-idle-timeout=.*/player-idle-timeout=$player_idle_timeout/" "$installation_dir/server.properties"
sed -i "s/max-threads=.*/max-threads=$max_threads/" "$installation_dir/server.properties"
sed -i "s/tick-distance=.*/tick-distance=$tick_distance/" "$installation_dir/server.properties"
sed -i "s/default-player-permission-level=.*/default-player-permission-level=$default_player_permission_level/" "$installation_dir/server.properties"
sed -i "s/texturepack-required=.*/texturepack-required=$texturepack_required/" "$installation_dir/server.properties"
sed -i "s/content-log-file-enabled=.*/content-log-file-enabled=$content_log_file_enabled/" "$installation_dir/server.properties"
sed -i "s/compression-threshold=.*/compression-threshold=$compression_threshold/" "$installation_dir/server.properties"
sed -i "s/compression-algorithm=.*/compression-algorithm=$compression_algorithm/" "$installation_dir/server.properties"
sed -i "s/server-authoritative-movement=.*/server-authoritative-movement=$server_authoritative_movement/" "$installation_dir/server.properties"
sed -i "s/player-position-acceptance-threshold=.*/player-position-acceptance-threshold=$player_position_acceptance_threshold/" "$installation_dir/server.properties"
sed -i "s/player-movement-action-direction-threshold=.*/player-movement-action-direction-threshold=$player_movement_action_direction_threshold/" "$installation_dir/server.properties"
sed -i "s/server-authoritative-block-breaking=.*/server-authoritative-block-breaking=$server_authoritative_block_breaking/" "$installation_dir/server.properties"
sed -i "s/server-authoritative-block-breaking-pick-range-scalar=.*/server-authoritative-block-breaking-pick-range-scalar=$server_authoritative_block_breaking_pick_range_scalar/" "$installation_dir/server.properties"
sed -i "s/chat-restriction=.*/chat-restriction=$chat_restriction/" "$installation_dir/server.properties"
sed -i "s/disable-player-interaction=.*/disable-player-interaction=$disable_player_interaction/" "$installation_dir/server.properties"
sed -i "s/client-side-chunk-generation-enabled=.*/client-side-chunk-generation-enabled=$client_side_chunk_generation_enabled/" "$installation_dir/server.properties"
sed -i "s/block-network-ids-are-hashes=.*/block-network-ids-are-hashes=$block_network_ids_are_hashes/" "$installation_dir/server.properties"
sed -i "s/disable-persona=.*/disable-persona=$disable_persona/" "$installation_dir/server.properties"
sed -i "s/disable-custom-skins=.*/disable-custom-skins=$disable_custom_skins/" "$installation_dir/server.properties"
sed -i "s/server-build-radius-ratio=.*/server-build-radius-ratio=$server_build_radius_ratio/" "$installation_dir/server.properties"

chown -R $user:$user $installation_dir

echo "Cleaning up..."

rm /tmp/"$zip_file"

# Configure Supervisor to monitor and control Minecraft Server.

tee "/etc/supervisor/conf.d/${server}-process.conf" > /dev/null << EOF
[program:$server]
command=$installation_dir/bedrock_server                                  
environment=LD_LIBRARY_PATH=$installation_dir
directory=$installation_dir
user=$user
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=$installation_dir/$server.out.log
EOF

supervisorctl update
sleep 3
supervisorctl status
sleep 3
supervisorctl restart $server
sleep 3


# Check if iptables is installed
if command -v iptables &>/dev/null; then
    # Allow traffic on the specified port if not already allowed
    if ! iptables -C INPUT -p udp --dport $server_port -j ACCEPT &>/dev/null 2>&1; then
        echo "Opening port $server_port..."
        iptables -I INPUT -p udp --dport $server_port -j ACCEPT
        
        # Ensure the directory exists before saving rules
        mkdir -p /etc/iptables
        iptables-save > /etc/iptables/rules.v4
    else
        echo "Port $server_port is already open."
    fi
else
    echo "iptables is not installed."
fi


sleep 5

if ss -nlup | grep -q ":$server_port"; then
    echo
    echo "Installation completed. Your server is running and listening on UDP port $server_port."
    echo
    echo "Please ensure that UDP port $server_port is also open in your security list/group/router/firewall etc."
    echo
    echo "To interact with Minecraft Server command-line console run: \"sudo supervisorctl fg $server\""
    echo
else
    echo "Port $server_port UDP is not listening. Installation may have failed or the server is not running."
fi

#!/bin/bash

# Paths
UPDATE_SCRIPT_PATH="/usr/local/bin/mcupdater.sh"
SERVICE_NAME="mc-daily-update"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"
TIMER_PATH="/etc/systemd/system/${SERVICE_NAME}.timer"

# Step 1: Create mcupdater.sh with the script logic directly
cat << 'EOF' > "$UPDATE_SCRIPT_PATH"
#!/bin/bash

today=$(date +"%Y-%m-%d")

# Find if Minecraft Bedrock exist on the file system. If multiple installations exsist choose which one to update.

find_installations() {
    find / -type d -name "*.bak" -prune -o -type f -executable -execdir test -e server.properties \; -printf "%h\n" 2>/dev/null
}

installations=$(find_installations)

if [ -z "$installations" ]; then
    echo "No Minecraft Bedrock server installations found."
    exit 1
fi

readarray -t installations_array <<< "$installations"

# Loop through each installation directory and update it
for installation_dir in "${installations_array[@]}"; do
    echo "Updating Minecraft Bedrock server installation at: $installation_dir"

    # Check the latest Minecraft Bedrock Edition Server available.
    source=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock)

    link=$(echo "$source" | grep -o '"https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-[^"]*"' | sed 's/"//g') 

    zip_file=$(basename "$link")

    # Check the version of the installed Minecraft Bedrock Edition Server.

    cd $installation_dir
    output=$(sudo $installation_dir/bedrock_server 2>&1 &)

    version=$(echo "$output" | grep -o 'Version: [0-9.]\+' | awk '{print $2}')

    if [ -z "$version" ]; then
        echo "Failed to extract version from server output. Exiting."
        exit 1
    fi

    echo "Minecraft Bedrock server version is: $version"

    if [[ $zip_file == *$version* ]]; then
        echo "Minecraft Server is up to date, nothing to do!"
        continue
    else
        echo "Downloading $link... "
        wget --header="Referer: https://www.minecraft.net/en-us/download/server/bedrock" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" -P /tmp "$link"
    fi

    sudo supervisorctl stop bedrock-server

    # Make a backup of current Minecraft home directory.
    read user group <<< $(stat -c '%U %G' "$installation_dir")

    backup_dir="$installation_dir-$today.bak"

    cp -a $installation_dir $backup_dir
    echo "Backing up $installation_dir to $backup_dir..."

    # Extract latest Minecraft Bedrock Edition Server & Remove Zip File.
    unzip -o /tmp/$zip_file -d $installation_dir
    rm /tmp/$zip_file

    echo "Updating Minecraft... "
    cp -a $backup_dir/server.properties $installation_dir
    cp -a $backup_dir/allowlist.json $installation_dir
    cp -a $backup_dir/permissions.json $installation_dir

    chown -R $user:$group $installation_dir

    # Start updated server
    sudo supervisorctl reload
done
EOF

# Make mcupdater.sh executable
chmod +x "$UPDATE_SCRIPT_PATH"

# Step 2: Create the systemd service file
cat << EOF > "$SERVICE_PATH"
[Unit]
Description=Run Daily Maintenance Script

[Service]
Type=oneshot
ExecStart=$UPDATE_SCRIPT_PATH
EOF

# Step 3: Create the systemd timer file
cat << EOF > "$TIMER_PATH"
[Unit]
Description=Run Daily Maintenance Script Timer

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Step 4: Reload systemd and enable the timer
systemctl daemon-reload
systemctl enable --now "${SERVICE_NAME}.timer"

echo
echo "Setup complete! The daily maintenance script will run daily at 2 AM."
echo
