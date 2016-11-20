#!/bin/bash

# Get local Username
localuname=`id -u -n`
# Get PUID
PUID=`id -u $localuname`
# Get GUID
PGID=`id -g $localuname`
# Get Hostname
thishost=`hostname`
# Get IP Address
locip=`hostname -I | awk '{print $1}'`

# CIDR - this assumes a 255.255.255.0 netmask - If your config is different use the custom CIDR line
lannet=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
# Custom CIDR (comment out the line above if using this)
# Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lannet=

read -p "What is your PIA Username?: " piauname
read -s -p "What is you PIA Password? (Will not be echoed): " piapass
printf "\n\n"

###################
# TROUBLESHOOTING #
###################
# If you are having issues with any containers starting
# Or the .env file is not being populated with the correct values
# Uncomment the necessary line(s) below to see what values are being generated

# printf "### Collected VariableS are echoed below. ###\n"
# printf "\n"
# printf "The username is: $localuname\n"
# printf "The PUID is: $PUID\n"
# printf "The PGID is: $PGID\n"
# printf "The IP address is: $locip\n"
# printf "The CIDR address is: $lannet\n"
# printf "The PIA Username is: $piauname\n"
# printf "The PIA Password is: $piapass\n"
# printf "The Hostname is: $thishost\n"

# Create the .env file
echo "Creating the .env file with the values we have gathered"
printf "\n"
echo "LOCALUSER=$localuname" >> .env
echo "HOSTNAME=$thishost" >> .env
echo "IP_ADDRESS=$locip" >> .env
echo "PUID=$PUID" >> .env
echo "PGID=$PGID" >> .env
echo "PIAUNAME=$piauname" >> .env
echo "PIAPASS=$piapass" >> .env
echo "CIDR_ADDRESS=$lannet" >> .env
echo ".env file creation complete"
printf "\n\n"

# Download & Launch the containers
echo "The containers will now be pulled and launched"
echo "This may take a while depending on your download speed"
read -p "Press any key to continue... " -n1 -s
printf "\n\n"
`docker-compose up -d`
printf "\n\n"

# Echo the configuration
printf " Container URLs and Ports \n"
printf "\n"
printf "The Couchpotato container is available at: $locip:5050\n"
printf "The DelugeVPN container is available at: $locip:8112\n"
printf " # A PRIVOXY proxy service is available at: $locip:8118\n"
printf " # The Deluge deamon port available at: $locip:58846 - (For Couchpotato)\n"
printf "The PLEX container is available at: $locip:32400/web\n"
printf "The Sickrage container is available at: $locip:8081\n"
printf "To manage and monitor your containers - Portainer is available at: $locip:9000\n"
printf "\n\n"

# Access usernames & passwords
printf " Default Usernames & Passwords \n"
printf "\n"
printf "Deluge = The default password for the webui is - deluge\n"
printf "Deluge = The username for the deamon (needed in Couchpotato) is - cp\n"
printf "Deluge = The password for the deamon (needed in Couchpotato) is - deluge\n"

# Still working on how to fix this
#echo "cp:deluge:10" >> ./delugevpn/config/auth