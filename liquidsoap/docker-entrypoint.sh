#!/bin/bash

LIQUIDSOAP_CONFIG_FILE='./rr-liquidsoap.liq'

SOURCE_PASSWORD_PLACEHOLDER="SOURCE_PASSWORD"

# Check if environment variables are set
if [ -z "$SOURCE_PASSWORD" ]; then
  echo "Error: SOURCE_PASSWORD is not set. Set it using the option -e, e.g. \"docker run -it ... -e SOURCE_PASSWORD="password"\" ..."
  exit 1
fi

# Replace placeholders in the Icecast config file
sed -i "s/${SOURCE_PASSWORD_PLACEHOLDER}/$SOURCE_PASSWORD/" ${LIQUIDSOAP_CONFIG_FILE}

# Start Samba services in the background
smbd -F &

# Run Liquidsoap
liquidsoap rr-liquidsoap.liq