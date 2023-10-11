# Telegram Docker

## Configuration

The [Telegram](https://telegram.org/) Docker container can be configured using environment variables and volumes.

### Environment Variables

- `DISPLAY`: X11 display server connection string (e.g., `unix$DISPLAY`).
- `PULSE_SERVER`: path to PulseAudio server (e.g. `unix:$XDG_RUNTIME_DIR/pulse/native`).

### Volumes

- `/tmp/.X11-unix:/tmp/.X11-unix:ro`: X11 socket for display forwarding.
- `$XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse:ro`: PulseAudio.
- `/etc/localtime:/etc/localtime:ro`: Timezone (optional).
- `telegram_cache:/cache`: cache directory (`$HOME/.cache`).
- `telegram_data:/data`: telegram data directory (`$HOME/.local/share/TelegramDesktop`).
- `$HOME/Downloads:/downloads`: Downloads directory.

## Usage

### Docker run

```bash
docker run -d \
  --name telegram \
  -e DISPLAY=unix${DISPLAY} \
  -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
  --device /dev/dri:/dev/dri \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -v telegram_cache:/cache \
  -v telegram_data:/data \
  -v ${HOME}/Downloads:/downloads \
  rshmyrev/telegram
```

### Docker compose

```bash
docker compose up -d
```
