#!/bin/bash

# This script is the entrypoint of the container that runs the Liquidsoap server,
# meaning that it is run in the foreground of the container when the container starts up.
# This script does three things:
#  - Performs a simple dialog with the user to make sure they submit the required parameters.
#  - Inserts the submitted parameters into the Liquidsoap configuration file, by replacing the placeholders inside it.
#  - Starts the Liquidsoap server with the edited script.

LIQUIDSOAP_CONFIG_FILE='./rr-liquidsoap.liq'

SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD_PLACEHOLDER"
ICECAST_HOSTNAME_PLACEHOLDER="ICECAST_HOSTNAME_PLACEHOLDER"
ICECAST_PORT_PLACEHOLDER="ICECAST_PORT_PLACEHOLDER"
MOUNTPOINT_PASSWORD_PLACEHOLDER="MOUNTPOINT_PASSWORD_PLACEHOLDER"

# Check if environment variables are set
if [ -z "$SOURCE_PASSWORD" ]; then
  echo "ERROR: SOURCE_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e SOURCE_PASSWORD="password"\" ..."
  echo "SOURCE_PASSWORD is the password that Liquidsoap uses to authenticate against the Icecast server."
  exit 1
fi

if [ -z "$MOUNTPOINT_PASSWORD" ]; then
  echo "ERROR: MOUNTPOINT_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e MOUNTPOINT_PASSWORD="password"\" ..."
  echo "MOUNTPOINT_PASSWORD is the password users must send to the Liquidsoap server to be able to send content to it."
  exit 1
fi

if [ -z "$ICECAST_HOSTNAME" ]; then
  echo "Warning: ICECAST_HOSTNAME is not set. Using default value \"localhost\". To set it, use the option -e, e.g. \"docker run -it ... -e ICECAST_HOSTNAME="password"\" ..."
  echo "ICECAST_HOSTNAME is the ip address or domain name of the icecast server that the Liquidsoap server sends content to."
  ICECAST_HOSTNAME="localhost"
fi

if [ -z "$ICECAST_PORT" ]; then
  echo "Warning: ICECAST_PORT is not set. Using default value 8000. To set it, use the option -e, e.g. \"docker run -it ... -e ICECAST_PORT="password"\" ..."
  echo "ICECAST_PORT is the port to use when connecting to the icecast server that the Liquidsoap server sends content to."
  ICECAST_PORT="8000"
fi

# Replace placeholders in the Liquidsoap config file
sed -i "s/${SOURCE_PASSWORD_PLACEHOLDER}/$SOURCE_PASSWORD/" ${LIQUIDSOAP_CONFIG_FILE}
sed -i "s/${ICECAST_HOSTNAME_PLACEHOLDER}/$ICECAST_HOSTNAME/" ${LIQUIDSOAP_CONFIG_FILE}
sed -i "s/${ICECAST_PORT_PLACEHOLDER}/$ICECAST_PORT/" ${LIQUIDSOAP_CONFIG_FILE}
sed -i "s/${MOUNTPOINT_PASSWORD_PLACEHOLDER}/$MOUNTPOINT_PASSWORD/" ${LIQUIDSOAP_CONFIG_FILE}

# Run Liquidsoap
liquidsoap rr-liquidsoap.liq