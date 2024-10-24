#!/bin/sh

ICECAST_CONFIG_FILE_URL="https://raw.githubusercontent.com/Sleiphan/rr-streamer/refs/heads/main/icecast/rr-icecast.xml"
ICECAST_CONFIG_FILE="$(pwd)/rr-icecast.xml"

ICECAST_START_COMMAND='su -s /bin/sh -c "nohup icecast -c ${ICECAST_CONFIG_FILE} > /dev/null 2>&1 &" icecast'

ENV_ICECAST_CONFIG_NAME="RR_ICECAST_CONFIG_FILE"
ADMIN_PASSWORD_PLACEHOLDER="ADMIN_PASSWORD"
SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"
RELAY_PASSWORD_PLACEHOLDER="RELAY_PASSWORD"

# echo -e "\n\n### Welcome to Radio Revolt's setup script for Icecast! ###\n\
# This script will install, configure, and get the icecast server running for you!\n\n\
# Since storing passwords in a git repository is something that only knobheads do,\n\
# I will need you to give me three passwords:\n\n\
#   # Admin password: A password that the admins (Teknisk) will use to login to the server with administrator privileges.\n\
#   # Source password: Password that listener software (like radiorevolt.no) will use to access the audio streams.\n\
#   # Relay password: A password that relay Icecast servers will use to relay the streams from this server. If you are not using any Icecast relays, just enter some gibberish.\n\n\
# Happy broadcasting!\n"

apk update && apk add wget
wget ${ICECAST_CONFIG_FILE_URL}

if [ ! -f "${ICECAST_CONFIG_FILE}" ]; then
  echo -e "Icecast config file not found. \nPlease provide the full file path of the Icecast configuration file you want to use:"
  read ICECAST_CONFIG_FILE
  echo -e "\n"
fi

echo -e "Setting environment variable ${ENV_ICECAST_CONFIG_NAME}=${ICECAST_CONFIG_FILE}"
echo "export ${ENV_ICECAST_CONFIG_NAME}=${ICECAST_CONFIG_FILE}" >> /etc/profile
source /etc/profile
echo -e "DONE\n"

echo -e "Please enter the Admin password:"
read ADMIN_PASSWORD

echo -e "Please enter the Source password:"
read SOURCE_PASSWORD

echo -e "Please enter the Relay password:"
read RELAY_PASSWORD

sed -i "s|${SOURCE_PASSWORD_PLACEHOLDER}|${SOURCE_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${ADMIN_PASSWORD_PLACEHOLDER}|${ADMIN_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${RELAY_PASSWORD_PLACEHOLDER}|${RELAY_PASSWORD}|g" ${ICECAST_CONFIG_FILE}

echo -e "Installing Icecast..."
apk update && apk add icecast > /dev/null 2>&1
echo -e "DONE\n"

echo -e "Starting icecast in the background..."
${ICECAST_START_COMMAND}
echo -e "DONE\n"

echo -e "Making icecast start when the system boots up ..."
echo "${ICECAST_START_COMMAND}" > /etc/local.d/start_rr_icecast.start
echo -e "DONE\n"

echo -e "Successfully installed Radio Revolt's Icecast server!"