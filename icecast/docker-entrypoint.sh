#!/bin/sh

ICECAST_CONFIG_FILE='./rr-icecast.xml'

ADMIN_PASSWORD_PLACEHOLDER="ADMIN_PASSWORD"
SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"
RELAY_PASSWORD_PLACEHOLDER="RELAY_PASSWORD"

# Check if environment variables are set
if [ -z "$ADMIN_PASSWORD" ]; then
  echo "Error: ADMIN_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e ADMIN_PASSWORD="password"\" ..."
  exit 1
fi

if [ -z "$SOURCE_PASSWORD" ]; then
  echo "Error: SOURCE_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e SOURCE_PASSWORD="password"\" ..."
  exit 1
fi

if [ -z "$RELAY_PASSWORD" ]; then
  echo "Error: RELAY_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e RELAY_PASSWORD="password"\" ..."
  exit 1
fi

# Replace placeholders in the Icecast config file
sed -i "s/${ADMIN_PASSWORD_PLACEHOLDER}/$ADMIN_PASSWORD/" ${ICECAST_CONFIG_FILE}
sed -i "s/${SOURCE_PASSWORD_PLACEHOLDER}/$SOURCE_PASSWORD/" ${ICECAST_CONFIG_FILE}
sed -i "s/${RELAY_PASSWORD_PLACEHOLDER}/$RELAY_PASSWORD/" ${ICECAST_CONFIG_FILE}

# Start Icecast
exec su -s /bin/sh -c "icecast -c ${ICECAST_CONFIG_FILE}" icecast