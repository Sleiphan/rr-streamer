# Denne liquidsoap-konfigurasjonen gjør 3 ting:
#   1. Setter opp nettverks-endepunkter man kan sende lyd til (f.eks fra Broadcast Using This Tool).
#   2. Mikser alle endepunktene sammen.
#   3. Sender resultatet til en icecast-server.
# Sørg for å fylle inn alle parametrene før du bruker denne filen.


# Here are all parameters you have to set before running liquidsoap with this config file.
# Replace everything named *_PLACEHOLDER. Do do not remove the quote-marks (").

ICECAST_HOST = "ICECAST_HOSTNAME_PLACEHOLDER"
ICECAST_PORT = ICECAST_PORT_PLACEHOLDER
ICECAST_PASSWORD_SOURCE = "SOURCE_PASSWORD_PLACEHOLDER"
MOUNTPOINT_PASSWORD = "MOUNTPOINT_PASSWORD_PLACEHOLDER"



# Write the log to stdout and to the log file
set("log.file", true)
set("log.stdout", true)



# First, setup all the endpoints that we can send audio to.

live_0 = input.harbor("liquidsoap_0", port=8080, password=MOUNTPOINT_PASSWORD)
live_1 = input.harbor("liquidsoap_1", port=8081, password=MOUNTPOINT_PASSWORD)
live_2 = input.harbor("liquidsoap_2", port=8082, password=MOUNTPOINT_PASSWORD)
live_3 = input.harbor("liquidsoap_3", port=8083, password=MOUNTPOINT_PASSWORD)
live_4 = input.harbor("liquidsoap_4", port=8084, password=MOUNTPOINT_PASSWORD)
live_5 = input.harbor("liquidsoap_5", port=8085, password=MOUNTPOINT_PASSWORD)



# Second, mix all these endpoints together

live = add([
    live_0,
    live_1,
    live_2,
    live_3,
    live_4,
    live_5
], normalize=false)



# Lastly, send the streams to the icecast server. It might look like a lot of code, but it really is not.
# It is just:
#   - Defining parameters that are common for all the streams.
#   - 4 code blocks that are almost identical, representing the different streams sent to icecast.

# Common parameters for all streams sent to icecast.
icecast_common_source = live                                                # The audio that is streamed to icecast
icecast_common_host = ICECAST_HOST                                          # Icecast server host
icecast_common_port = ICECAST_PORT                                          # Icecast server port
icecast_common_password = ICECAST_PASSWORD_SOURCE                           # Icecast mount point password
icecast_common_name = "Radio Revolt"                                        # Name of the stream
icecast_common_description = "Radio Revolt - Studentradioen i Trondheim"    # Stream description
icecast_common_genre = "Radio"                                              # Genre of the stream
icecast_common_url = "https://radiorevolt.no"


# These are the different streams that our Liquidsoap server sends to the Icecast server.

output.icecast(
    id="revolt_aac_ice",
    public = true,
    %fdkaac(samplerate=44100, channels=2, bitrate=128, afterburner=true, transmux="adts"),
    # %ffmpeg(format="mpegts", ar=44100, codec="libfdk_aac", b="a 128k", afterburner=1, profile="aac_he_v2"),
    # %ffmpeg(encoder="aac", b="a 128k", afterburner=true),
    mount = "revolt.aac",

    # Common parameters for all streams
    host = icecast_common_host,
    port = icecast_common_port,
    password = icecast_common_password,
    name = icecast_common_name,
    description = icecast_common_description,
    genre = icecast_common_genre,
    url = icecast_common_url,

    mksafe(id="revolt_aac_mksafe", buffer(id="revolt_aac_buffer", icecast_common_source))
)

output.icecast(
    id="revolt_dab_vorbis_ice",
    public = false,
    %vorbis(samplerate=44100, channels=2, quality=0.9),
    mount = "revolt_dab.vorbis.ogg", format = "audio/ogg",

    # Common parameters for all streams
    host = icecast_common_host,
    port = icecast_common_port,
    password = icecast_common_password,
    name = icecast_common_name,
    description = icecast_common_description,
    genre = icecast_common_genre,
    url = icecast_common_url,

    mksafe(id="revolt_dab_vorbis_mksafe", buffer(id="revolt_dab_vorbis_buffer", icecast_common_source))
)

output.icecast(
    id="revolt_ogg_ice",
    public = true,
    %vorbis(samplerate=44100, channels=2, quality=0.5),
    mount = "revolt.ogg", format = "audio/ogg",

    # Common parameters for all streams
    host = icecast_common_host,
    port = icecast_common_port,
    password = icecast_common_password,
    name = icecast_common_name,
    description = icecast_common_description,
    genre = icecast_common_genre,
    url = icecast_common_url,

    mksafe(id="revolt_ogg_mksafe", buffer(id="revolt_ogg_buffer", icecast_common_source))
)

# mp3 320 kbit/s constant bitrate stream for midlertidig oppsett for FM i desember 2021
output.icecast(
    id="revolt_mp3_ice",
    public = true,
    %mp3.cbr(bitrate=320, stereo=true, id3v2=true),
    mount = "revolt.mp3",

    # Common parameters for all streams
    host = icecast_common_host,
    port = icecast_common_port,
    password = icecast_common_password,
    name = icecast_common_name,
    description = icecast_common_description,
    genre = icecast_common_genre,
    url = icecast_common_url,

    mksafe(id="revolt_mp3_mksafe", buffer(id="revolt_mp3_buffer", icecast_common_source))
)