#!/bin/sh

ICECAST_CONFIG_FILE_URL="https://raw.githubusercontent.com/Sleiphan/rr-streamer/refs/heads/main/icecast/rr-icecast.xml"
ICECAST_CONFIG_FILE="/etc/icecast.xml"
ICECAST_STARTUP_FILE="/etc/local.d/start_rr_icecast.start"

ADMIN_PASSWORD_PLACEHOLDER="ADMIN_PASSWORD"
SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"
RELAY_PASSWORD_PLACEHOLDER="RELAY_PASSWORD"

ICECAST_START_COMMAND="su -s /bin/sh -c \"nohup icecast -c ${ICECAST_CONFIG_FILE} > /dev/null 2>&1 &\" icecast"

# Let the user set the passwords used by the icecast server
echo -e "Please enter the Admin password:"
read ADMIN_PASSWORD

echo -e "Please enter the Source password:"
read SOURCE_PASSWORD

echo -e "Please enter the Relay password:"
read RELAY_PASSWORD

# Install dependencies
echo -e "Installing dependencies ..."
apk update > /dev/null
apk add curl icecast > /dev/null
echo -e "DONE\n"

# Download config file
curl -L -o ${ICECAST_CONFIG_FILE} ${ICECAST_CONFIG_FILE_URL} > /dev/null 2>&1

# Insert passwords into config file
sed -i "s|${SOURCE_PASSWORD_PLACEHOLDER}|${SOURCE_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${ADMIN_PASSWORD_PLACEHOLDER}|${ADMIN_PASSWORD}|g" ${ICECAST_CONFIG_FILE}
sed -i "s|${RELAY_PASSWORD_PLACEHOLDER}|${RELAY_PASSWORD}|g" ${ICECAST_CONFIG_FILE}

# Make icecast start on boot
echo -e "Making icecast start when the system boots up ..."
echo "${ICECAST_START_COMMAND}" > ${ICECAST_STARTUP_FILE}   # Create the startup file
chmod +x ${ICECAST_STARTUP_FILE}                            # Make the startup file executable
rc-update add local default                                 # This makes all scripts in /etc/local.d/ run at startup
echo -e "DONE\n"

# Setup symlinks to all relevant files
ln -s ${ICECAST_CONFIG_FILE} ./icecast.xml
ln -s ${ICECAST_STARTUP_FILE} ./start_rr_icecast.start

# Start icecast
echo -e "Starting icecast in the background..."
./start_rr_icecast.start
echo -e "DONE\n"

# Done!
echo -e "Successfully installed Radio Revolt's Icecast server!"