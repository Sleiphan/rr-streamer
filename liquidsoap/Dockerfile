# In short, this Dockerfile just adds a file server capability to the ready made Liquidsoap image.
# This makes it easy to edit the selection of audio files which Liquidsoap can choose from.

# Set a specific version of the Liquidsoap image as the base image. The version "9ab21ac" was released 16-oct-2024.
FROM savonet/liquidsoap:9ab21ac AS base

# Set the work directory to the home folder of the user 'liquidsoap'. The user 'liquidsoap' is generated by the base image.
WORKDIR /var/cache/liquidsoap

# Create folders for playback and promotion audio files.
# RUN mkdir -p /var/cache/liquidsoap/file-server/radio-promoer /var/cache/liquidsoap/file-server/radio-repriser

# Copy relevant files to their proper destinations
COPY rr-liquidsoap.liq /var/cache/liquidsoap/
COPY docker-entrypoint.sh /var/cache/liquidsoap/

# Change to user 'root' for the next steps.
USER root

# Make sure that the startup script is executable.
RUN chmod +x docker-entrypoint.sh

# Install file server software. In this case, we use 'samba' since it is a gold standard.
# RUN apt update && apt install -y samba

# Copy the file server configuration to the image
# COPY smb.conf /etc/samba/smb.conf

# Switch back to the user 'liquidsoap', as the base image originally intended.
USER liquidsoap

# -p 139:139 -p 445:445
# EXPOSE 139 445

# Make all containers generated from this image run the startup script.
ENTRYPOINT [ "./docker-entrypoint.sh" ]