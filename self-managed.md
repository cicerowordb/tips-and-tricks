## File Browser

- Create directories:
```bash
mkdir -p /home/$USER/file-browser/config
mkdir -p /home/$USER/file-browser/database
mkdir -p /home/$USER/file-browser/users
mkdir -p /mnt/d/file-browser/shared-files
```

- Change directories permissions:
```bash
chown $USER:$USER -R ~/file-browser/
ls -la /home/$USER/file-browser 
```

- Run application:
```bash
docker run -d \
    --name file-browser \
    -v /mnt/d/file-browser/shared-files:/srv \
    -v /home/$USER/file-browser/database:/database \
    -v /home/$USER/file-browser/config:/config \
    -v /home/$USER/file-browser/users:/users \
    -p 0.0.0.0:9080:80 \
    filebrowser/filebrowser
```

- Check logs and copy initial password:
```bash
docker logs file-browser
```

- Access Localhost and start initial setup:
    - User = admin / Password copied from logs
    - Settings > Profile Settings > Change Password > > Update

- Native editors for:
    - Common simple text files: .txt, .csv, .log
    - Common code files: .py, .sh, .js, .go, .html, .css, .sql, .php
    - Markdown

- Native preview:
    - Image: .jpg, .jpeg, .png, .gif, .svg, .webp
    - Video: .mp4, .webm, .ogg, .mp3, .wav

- References:
    - [https://hub.docker.com/r/filebrowser/filebrowser](https://hub.docker.com/r/filebrowser/filebrowser)
    - [https://github.com/filebrowser/filebrowser?tab=readme-ov-file](https://github.com/filebrowser/filebrowser?tab=readme-ov-file)
    - [https://filebrowser.org/](https://filebrowser.org/)
    - [https://filebrowser.org/installation.html](https://filebrowser.org/installation.html)

- Create a CloudFlare tunnel.
- Use container IP and port 80.

## Jellyfin Media Server

```bash
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -p 0.0.0.0:8096:8096 \
  -v /mnt/d/file-browser/jellyfin-config:/config \
  -v /mnt/d/file-browser/shared-files/tv:/data/tvshows \
  -v /mnt/d/file-browser/shared-files/movies:/data/movies \
  --restart unless-stopped \
  lscr.io/linuxserver/jellyfin:latest
```

- Other parameters not included:
  - `-p 0.0.0.0:8920:8920`: for HTTPS support (create your own certificate)
  - `-p 0.0.0.0:7359:7359/udp`: Jellyfin Discover.
  - `-p 0.0.0.0:1900:1900/udp`: DNLA Discover.

- To forward from WSL to Windows IP:
  - Use an Administrator PowerShell.
  - `netsh interface portproxy set v4tov4 listenport=8096 connectport=8096 connectaddress=172.22.185.230`
  - `netsh interface portproxy show v4tov4`

- After installation create libraries pointing to `/data` volume folders.

- References:
  - [https://docs.linuxserver.io/images/docker-jellyfin/#docker-compose-recommended-click-here-for-more-info](https://docs.linuxserver.io/images/docker-jellyfin/#docker-compose-recommended-click-here-for-more-info)

## Excalidraw Local

```bash
docker run -d --name excalidraw \
        -p 5000:80 \
        excalidraw/excalidraw:latest
```

- Reference: [https://hub.docker.com/r/excalidraw/excalidraw](https://hub.docker.com/r/excalidraw/excalidraw)
