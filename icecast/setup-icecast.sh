#!/bin/sh

ICECAST_CONFIG_FILE_URL="https://raw.githubusercontent.com/Sleiphan/rr-streamer/refs/heads/main/icecast/rr-icecast.xml"
ICECAST_CONFIG_FILE="/etc/icecast.xml"

ENV_ICECAST_CONFIG_NAME="RR_ICECAST_CONFIG_FILE"
ADMIN_PASSWORD_PLACEHOLDER="ADMIN_PASSWORD"
SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"
RELAY_PASSWORD_PLACEHOLDER="RELAY_PASSWORD"

ICECAST_START_COMMAND="su -s /bin/sh -c \"nohup icecast -c \$${ENV_ICECAST_CONFIG_NAME} > /dev/null 2>&1 &\" icecast"

apk update && apk add wget icecast
wget -O ${ICECAST_CONFIG_FILE} ${ICECAST_CONFIG_FILE_URL}

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

echo -e "Starting icecast in the background..."
${ICECAST_START_COMMAND}
echo -e "DONE\n"

echo -e "Making icecast start when the system boots up ..."
# mkdir /etc/local.d
echo "${ICECAST_START_COMMAND}" > /etc/local.d/start_rr_icecast.start
chmod +x /etc/local.d/start_rr_icecast.start
# echo "::sysinit:/etc/init.d/local start" >> /etc/inittab
echo -e "DONE\n"

echo -e "Successfully installed Radio Revolt's Icecast server!"