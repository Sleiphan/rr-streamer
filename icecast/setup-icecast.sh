#!/bin/sh

ADMIN_PASSWORD_PLACEHOLDER="ADMIN_PASSWORD"
SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"
RELAY_PASSWORD_PLACEHOLDER="RELAY_PASSWORD"

ICECAST_CONFIG_FILE="./rr-icecast.xml"

echo -e "\n\n### Welcome to Radio Revolt's setup script for Icecast! ###\n\
This script will install, configure, and get the icecast server running for you!\n\n\
Since storing passwords in a git repository is something that only knobheads do,\n\
I will need you to give me three passwords:\n\n\
  # Admin password: A password that the admins (Teknisk) will use to login to the server with administrator privileges.\n\
  # Source password: Password that listener software (like radiorevolt.no) will use to access the audio streams.\n\
  # Relay password: A password that relay Icecast servers will use to relay the streams from this server. If you are not using any Icecast relays, just enter some gibberish.\n\n\
Happy broadcasting!\n"

if [ ! -f "${ICECAST_CONFIG_FILE}" ]; then
  echo -e "Icecast config file not found in the current folder. \nPlease provide the location of the Icecast configuration file you want to use:"
  read ICECAST_CONFIG_FILE
  echo -e "\n"
fi

if ! grep -q "${SOURCE_PASSWORD_PLACEHOLDER}" ${ICECAST_CONFIG_FILE}; then
  echo -e "It seems like the passwords have already been set in \"${ICECAST_CONFIG_FILE}\".\nExiting...\n"
  exit 0
fi

echo -e "Please enter the Admin password:"
read ADMIN_PASSWORD

echo -e "Please enter the Source password:"
read SOURCE_PASSWORD

echo -e "Please enter the Relay password:"
read RELAY_PASSWORD

sed -i "s|${SOURCE_PASSWORD_PLACEHOLDER}|${SOURCE_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${ADMIN_PASSWORD_PLACEHOLDER}|${ADMIN_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${RELAY_PASSWORD_PLACEHOLDER}|${RELAY_PASSWORD}|g" ${ICECAST_CONFIG_FILE}

echo -e "All passwords set successsfully.\n"

echo -e "Installing Icecast..."
apk update && apk add icecast
echo -e "DONE\n"

echo -e "Starting icecast in the background..."
su -s /bin/sh -c "nohup icecast -c ${ICECAST_CONFIG_FILE} > /dev/null 2>&1 &" icecast
echo -e "DONE\n"
