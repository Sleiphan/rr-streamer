#!/bin/bash

# Start the web server if its not already running
if ! pidof nginx > /dev/null; then
  nginx
fi

# Setting constants
BUFFER_SIZE=$((2 * 31 * 24 * 60))  # 2 months in minutes
OVERLAP=120
CHUNCK_SIZE=3600
STREAM_URL='http://direkte.radiorevolt.no/revolt.aac'
CONTENT_PATH='/recordings'

while :
do
    # Wait for the next time to start a new recording.
    sleep_time=$(( $CHUNCK_SIZE - $(date +%s) % $CHUNCK_SIZE - $OVERLAP))
    if [ "$sleep_time" -lt 1 ]; then
        sleep_time=$(($sleep_time + $CHUNCK_SIZE))
    fi

    # Wait for next recording
    sleep "$sleep_time"

    # Define filename
    FILE_NAME="$(date -d 'next hour' '+%Y %b %d %H:00').mp3"

    # Start a recording now
    nohup ffmpeg -i $STREAM_URL -t $(($CHUNCK_SIZE + $OVERLAP * 2)) -f mp3 -ab 128k "$CONTENT_PATH/$FILE_NAME" > /dev/null 2>&1 &

    # Completely detach the recording process from this process
    disown

    # Delete all records older than the defined buffer size
    find "$CONTENT_PATH" -type f -mmin +$BUFFER_SIZE -delete
done
