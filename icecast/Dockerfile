FROM alpine:latest AS base

RUN mkdir /rr-icecast
WORKDIR /rr-icecast

# Copy relevant files
COPY ./* /rr-icecast

# Make the setup script executable
RUN chmod +x ./setup-icecast.sh
RUN chmod +x ./docker-entrypoint.sh

# Install icecast
RUN apk update && apk add icecast

# Open the default icecast port
EXPOSE 8000

# Make the icecast server run as soon as the container starts
ENTRYPOINT [ "./docker-entrypoint.sh" ]
