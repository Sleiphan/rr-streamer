
# Konstanter
ICECAST_HOST = "localhost"
ICECAST_PORT = 8000
ICECAST_PASSWORD_SOURCE = "SOURCE_PASSWORD"
PATH_PROMOER = "/var/cache/liquidsoap/file-server/radio-promoer"
PATH_REPRISER = "/var/cache/liquidsoap/file-server/radio-repriser"

# Skriv loggen ut til stdout, så den havner i SystemD sin journal
set("log.file", false)
set("log.stdout", true)



# Dette er hvor promoene kommer fra. De velges tilfeldig fra den følgende mappen.
promoer_playlist = playlist(PATH_PROMOER, mode="random")

# Dette er hvor reprisene kommer fra. De velges tilfeldig fra den følgende mappen.
repriser_playlist = playlist(PATH_REPRISER, mode="random")

# Switch to filler clips at the 29th minute of every hour and return to playback after 1 minute
playback = switch(track_sensitive=false, [({0h29m}, promoer_playlist), ({0h30m}, repriser_playlist)])

# For some odd reason, we have to wrap 'playback' in an extra make-safe call before being able to send it to an output.
# playback = audio_to_stereo(playback)
# playback = mksafe(playback)



# Common parameters for all streams
icecast_common_source = playback                                            # The audio that is streamed to icecast
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

    # Common parameters
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

    # Common parameters
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

    # Common parameters
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

    # Common parameters
    host = icecast_common_host,
    port = icecast_common_port,
    password = icecast_common_password,
    name = icecast_common_name,
    description = icecast_common_description,
    genre = icecast_common_genre,
    url = icecast_common_url,

    mksafe(id="revolt_mp3_mksafe", buffer(id="revolt_mp3_buffer", icecast_common_source))
)