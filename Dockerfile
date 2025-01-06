ARG STEAMCMD_VERSION=v1.4.0-wine
FROM ghcr.io/bubylou/steamcmd:$STEAMCMD_VERSION

LABEL org.opencontainers.image.authors="Nicholas Malcolm"
LABEL org.opencontainers.image.source="https://github.com/bubylou/moria-docker"

ENV APP_ID=3349480 \
	APP_NAME=moria \
	APP_DIR="/app/moria" \
	CONFIG_DIR="/config/moria" \
	DATA_DIR="/data/moria" \
	UPDATE_ON_START=false \
	RESET_SEED=false \
	STEAM_USERNAME=anonymous \
	GAME_PORT=7777 \
	LISTEN_PORT=7777 \
	USER=steam \
	UID=1000 \
	GID=1000

USER $USER
COPY ./MoriaServerConfig.ini $CONFIG_DIR/MoriaServerConfig.ini

# Update SteamCMD and install wine dependencies
RUN mkdir -p "$APP_DIR" "$CONFIG_DIR" "$DATA_DIR" \
	&& steamcmd +login anonymous +quit \
	&& xvfb-run winetricks -q vcrun2019

VOLUME [ "$APP_DIR", "$CONFIG_DIR", "$DATA_DIR" ]

# Check UDP connection on GAME_PORT
HEALTHCHECK --interval=30s --start-period=30s --timeout=10s \
	CMD ncat -uz 127.0.0.1 $GAME_PORT

EXPOSE $GAME_PORT/udp $LISTEN_PORT/tcp
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
