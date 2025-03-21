VERSION 0.8
FROM ghcr.io/bubylou/steamcmd:v1.5.1-wine
LABEL org.opencontainers.image.source="https://github.com/bubylou/moria"
LABEL org.opencontainers.image.authors="Nicholas Malcolm <bubylou@pm.me>"
LABEL org.opencontainers.image.licenses="MIT"
ARG --global name=bubylou/moria
ARG --global --required tag

build:
    ENV APP_ID=3349480
    ENV APP_NAME=moria
    ENV APP_DIR="/app/moria"
    ENV UPDATE_ON_START=true
    ENV RESET_SEED=true
    ENV STEAM_USERNAME=anonymous
    ENV LISTEN_PORT=9877

    COPY ./MoriaServerConfig.ini "$CONFIG_DIR/MoriaServerConfig.ini"
    RUN mkdir -p "$APP_DIR" \
        && steamcmd +login anonymous +quit \
        && xvfb-run winetricks -q vcrun2022

    VOLUME [ "$APP_DIR" ]

    COPY entrypoint.sh /entrypoint.sh
    ENTRYPOINT ["/entrypoint.sh"]

    FOR registry IN docker.io ghcr.io quay.io
        SAVE IMAGE --cache-from=$registry/$name:main --push \
            $registry/$name:$tag $registry/$name:latest
    END

full:
    FROM +build
    RUN steamcmd +force_install_dir "$APP_DIR" \
        +@sSteamCmdForcePlatformType windows \
        +login "$STEAM_USERNAME" "$STEAM_PASSWORD" "$STEAM_GUARD" \
        +app_update "$APP_ID" validate +quit

    FOR registry IN docker.io ghcr.io quay.io
        SAVE IMAGE --cache-from=$registry/$name:main-full --push \
            $registry/$name:$tag-full $registry/$name:latest-full
    END

all:
    BUILD +build
    BUILD +full
