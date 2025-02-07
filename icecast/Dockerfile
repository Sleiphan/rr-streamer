FROM alpine:latest AS base

RUN mkdir /rr-icecast
WORKDIR /rr-icecast

# Copy relevant files
COPY ./docker-entrypoint.sh ./rr-icecast.xml /rr-icecast/

# Enforce unix line endings
RUN dos2unix ./*

# Make the setup script executable
RUN chmod +x ./docker-entrypoint.sh

# Install icecast
RUN apk update && apk add icecast

# Open the default icecast port
EXPOSE 8000

# Make the icecast server run as soon as the container starts
ENTRYPOINT [ "./docker-entrypoint.sh" ]
