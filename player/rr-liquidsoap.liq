
# Konstanter
ICECAST_HOST = "ICECAST_HOSTNAME_PLACEHOLDER"
ICECAST_MOUNT_POINT = "ICECAST_MOUNT_POINT_PLACEHOLDER"
ICECAST_PORT = ICECAST_PORT_PLACEHOLDER
ICECAST_PASSWORD_SOURCE = "SOURCE_PASSWORD_PLACEHOLDER"
PATH_PROMOER = "/mnt/liquidsoap/promoer"
PATH_REPRISER = "/mnt/liquidsoap/repriser"
PATH_NATTMUSIKK = "/mnt/liquidsoap/nattmusikk"

# Skriv loggen ut til stdout, så den havner i SystemD sin journal
set("log.file", false)
set("log.stdout", true)



# Dette er hvor promoene kommer fra.
promoer_playlist = playlist(PATH_PROMOER, mode="random")

# Dette er hvor reprisene kommer fra.
repriser_playlist = playlist(PATH_REPRISER, mode="random")

# Dette er hvor nattmusikken kommer fra.
nattmusikk_playlist = playlist(PATH_NATTMUSIKK, mode="random")



stream = switch([
    ({0h-7h}, nattmusikk_playlist),
    ({29m-30m}, promoer_playlist),
    ({true}, repriser_playlist)
], track_sensitive=false)

# Normalize to -14 LUFS
stream = normalize(target=-14.0, lufs=true, up=6.0, down=0.1, stream)

# Common parameters for all streams
icecast_common_source = stream                                              # The audio that is streamed to icecast
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
    mount = ICECAST_MOUNT_POINT,

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