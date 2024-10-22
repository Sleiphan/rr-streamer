FROM alpine:latest AS base

# Copy relevant files
COPY ./* /

# Make the setup script executable
RUN chmod +x /setup-icecast.sh

# Install icecast
RUN apk update && apk add icecast

# Open the default icecast port
EXPOSE 8000

# Make the icecast server run as soon as the container starts
ENTRYPOINT [ "su", "-s", "/bin/sh", "-c", "icecast -c /rr-icecast.xml", "icecast" ]

# A copy of the entrypoint command:
# su -s /bin/sh -c 'icecast -c rr-icecast.xml' icecast