FROM debian:latest AS base

# Install dependencies
RUN apt update && apt install -y nginx ffmpeg



# Enforce UNIX line endings
FROM debian:latest AS format
COPY nginx.conf docker-entrypoint.sh ./
RUN apt update && apt install -y dos2unix
RUN dos2unix ./*



FROM base AS final

# Copy relevant files from the conversion stage
COPY --from=format ./nginx.conf ./docker-entrypoint.sh ./

# Move nginx configuration to it's right location
RUN mv ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /recordings

# Make entrypoint executable
RUN chmod +x ./docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT [ "./docker-entrypoint.sh" ]