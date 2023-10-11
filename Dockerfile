FROM debian:bookworm-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      xz-utils \
 && update-ca-certificates \
 && wget https://updates.tdesktop.com/tlinux/tsetup."$(curl \
        -sXGET \
        --head https://telegram.org/dl/desktop/linux \
        | grep location \
        | cut -d '/' -f 5 \
        | cut -d '.' -f 2-4 \
    )".tar.xz \
    -O /tmp/tsetup.tar.xz \
 && tar xvfJ /tmp/tsetup.tar.xz

FROM debian:bookworm-slim
LABEL maintainer="rshmyrev <rshmyrev@gmail.com>"

# Copy Telegram
COPY --from=builder /Telegram/Telegram /usr/bin/telegram

# Install required deps
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libegl1 \
      libgl1 \
      libpulse0 \
 && rm -rf /var/lib/apt/lists/*

# Install Firefox
RUN apt-get update && apt-get install -y --no-install-recommends \
    firefox-esr \
 && rm -rf /var/lib/apt/lists/*

# Set XDG Base Directory
ENV XDG_CACHE_HOME=/home/user/.cache \
    XDG_CONFIG_HOME=/home/user/.config \
    XDG_DATA_HOME=/home/user/.local/share \
    XDG_STATE_HOME=/home/user/.local/state \
    XDG_RUNTIME_DIR=/run/user/1000

# Create a user and directories
RUN mkdir -p /cache /data /downloads /home/user $XDG_DATA_HOME \
 && ln -s /cache     $XDG_CACHE_HOME \
 && ln -s /data      $XDG_DATA_HOME/TelegramDesktop \
 && ln -s /downloads /home/user/Downloads \
 && useradd -d /home/user -G audio,video user \
 && chown -R user:user /cache /data /downloads /home/user

VOLUME ["/cache", "/data", "/downloads"]
WORKDIR /home/user
USER user
CMD ["/usr/bin/telegram"]
