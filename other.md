## Download from Google Drive

- Get the original URL and check the file id:
  - https://drive.google.com/file/d/**1Jq7JayVJeXwIYlynFo6laZGZ_od3Dn3x**/view?usp=sharing
- Replace file in the *uc* endpoint:
  https://drive.google.com/uc?export=download&id=**1Jq7JayVJeXwIYlynFo6laZGZ_od3Dn3x**
- Now you can download using wget (given example):
  - wget https://drive.google.com/uc?export=download&id=1Jq7JayVJeXwIYlynFo6laZGZ_od3Dn3x -O test.docx


## Visual Studio Code Shortcuts

| Action                             | Linux Shortcut         | Windows Shortcut |
|------------------------------------|------------------------|------------------|
| Show/hide lateral panel            | `Ctrl+B`               |                  |
| Search inside file                 | `Ctrl+F`               |                  |
| Replace inside file                | `Ctrl+H`               |                  |
| Search all                         | `Ctrl+Shift+F`         |                  |
| Search file                        | `Ctrl+P`               |                  |
| Command Palette                    | `Ctrl+Shift+P`         |                  |
| Move line/block up                 | `Alt+Up Arrow`         |                  |
| Move line/block down               | `Alt+Down Arrow`       |                  |
| Split window in lateral panel      | `Ctrl+\`               | `Ctrl+]`         |
| Split window in bottom panel       | `Ctrl+K Ctrl+\`        | NA               |
| Navigate between panels            | `Ctrl+1`, `Ctrl+2`, ...|                  |
| Show terminal panel                | `Ctrl+'`               |                  |
| Include/remove a comment line      | `Ctrl+/`               | `Ctrl+K Ctrl+C`  |
| Compare active file with clipboard | `Ctrl+K C`             |                  |
| Compare active file with saved     | `Ctrl+K D`             |                  |
| Focus files tree panel             | `Ctrl+Shift+E`         |                  |
| Return to opened file content      | `Ctrl+1`               |                  |

\* {} = Windows only

## Visual Studio Code as a Container

Reference: [https://docs.linuxserver.io/images/docker-code-server/#docker-cli-click-here-for-more-info](https://docs.linuxserver.io/images/docker-code-server/#docker-cli-click-here-for-more-info)

```bash
mkdir -p /home/$USER/code-server/config
```

```bash
docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/Sao_Paulo \
  -e PASSWORD=<STRONG_PASSWORD> \
  -e SUDO_PASSWORD=<STRONG_PASSWORD> \
  -e DEFAULT_WORKSPACE=/config/workspace \
  -e PWA_APPNAME=code-server \
  -p 8443:8443 \
  -v /home/$USER/code-server/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/code-server:latest
```

## VSCode extensions

### Code/General
- **indent-rainbow** by _oderwat_: vertical colored lines to show indentation.
- **YAML** by _Red Hat_: makes easy track paths.
- **HashiCorp Terraform** by _Hashicorp_: syntax highlighting and autocompletion for Terraform.
- **HashiCorp HCL** by _Hashicorp_: syntax highlighting and autocompletion for Terragrunt.

### Git
- **GitLens** by _GitKraken_: Git metadata inside code editor and operation panel.

### Markdown
- **vscode-pandoc** by _Chris Chinchilla_: convert markdown files to PDF, DOCX, HTML, ePub, RST.
    - Install/copy pandoc binary first: [https://github.com/jgm/pandoc/releases/](https://github.com/jgm/pandoc/releases/)
    - Press `Ctrl+Shift+P` > Pandoc Render > choose correct extension.

### Access
- **Remote - SSH** by _Microsoft_: Allows to open files in remote servers via SSH.


## Diff to generate patch files as Git and apply

Create files. The file1.yaml represents an outdated content and file2.yaml the last version.

```bash
echo '### My example file
apiVersion: v1
kind: Pod
metadata:
  name: exemplo-pod
  labels:
    app: exemplo
spec:
  containers:
  - name: nginx-container
    image: nginx:latest
    ports:
    - containerPort: 80
' > file1.yaml

echo '### My example file2
apiVersion: v1
kind: Pod
metadata:
  name: exemplo-pod
  labels:
    app: exemplo
spec:
  containers:
  - name: nginx-container
    image: nginx:1.25
    ports:
    - containerPort: 80
' > file2.yaml

```

Run the diff and create a patch file.

```bash
diff -u file1.yaml file2.yaml --color
diff -u1 file1.yaml file2.yaml --color
diff file1.yaml file2.yaml > file.yaml.patch
cat file.yaml.patch
```

Apply the patch.

```bash
patch file1.yaml file.yaml.patch
```

## HTML and UTF8 icons

✅ ☑️ ❎ ⛔ ✔️ ✖️ ❌ ❗ ❕ ❓ ❔ ‼️ ⁉️ 📛 🚨 🚫 🚧 ⚠️ 🚥 🚦 ©️ ®️ ™️ ➕ ➖ ➗ 
💻 📞 💾 💿 🔋 🎥 📷 📁 📂 📃 📄 📅 📋 📒 📤 📥 📦 📧 📨 📩 📰
🔌 🔍 🔎 🔏 🔐 🔑 🔒 🔓 🔇 🔈 🔉 🔊 📢 📣 🔔 🔕 🔖 🔗 ⚡  
📈 📉 📊 📍 📱 📳 📵 ✂️ 🎯 🎲 🥇 🥈 🥉 🏆 🔥 🔦 🔧 🔨 🔩 🔪 🔫 🔬 🔭 
🏠 🏡 🏫 🏭 🏬 🏰 👑 
🌎 🌍 🌏 🌐 🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘 🌙 🌚 🌛 🌜 🌝 🌞 🌟 ⭐ ✨ 🌠 🎇 
✋ 👋 🖖 👆 👇 👈 👉 🤛 🤜 ✌️ 👌 🤏 🤞 👏 🤝 ☝️ 🎁 🎀 🎂 💲 💵 💰 🚀 ☀️ ☁️ ♨️ ♻️ 
😀 😁 😂 😃 😇 😉 😌 😍 😎 😏 😐 😑 😒 😓 😔 😕 😡 😤 😥 😦 😩 😭 😷
🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧 ⏰ ⌚
⏩ ⏪ ⏫ ⏬ ▶️ ◀️ 🔼 🔽 🎦 🔂 🔁 🔀 📴 📶 
ℹ️ ↔️ ↕️ ↖️ ↗️ ↘️ ↙️ ↩️ ↪️ ⤴️ ⤵️ 🔃 🔄 🔙 🔚 🔛 🔜 🔝 🔞 🔟 🔠 🔡 🔢 🔣 🔤 
♠️ ♣️ ♥️ ♦️ ⏳ ⛅ ⭐ ✳️ ✴️ ❇️ 💥 💢 💤 🔅 🔆 
🔴 🔵 🔶 🔷 🛑 🔸 🔹 🔺 🔻 🔼 🔽 

* [Best list](https://gist.github.com/suntong/3d411a7e7e737efb2502a17d4ce01d62)			
* [Numbers](https://www.w3schools.com/charsets/ref_utf_number_forms.asp)
* [Arrows](https://www.w3schools.com/charsets/ref_utf_arrows.asp)
* [Math](https://www.w3schools.com/charsets/ref_utf_math.asp)
* [Miscelaneous](https://www.w3schools.com/charsets/ref_utf_technical.asp)
* [ASCII Boxes](https://www.w3schools.com/charsets/ref_utf_box.asp)
* [Shapes](https://www.w3schools.com/charsets/ref_utf_geometric.asp)
* [Symbols](https://www.w3schools.com/charsets/ref_utf_symbols.asp)
* [Cards](https://www.w3schools.com/charsets/ref_utf_cards.asp)
* [Collored](https://www.w3schools.com/charsets/ref_emoji.asp)

## Browsh - Command line browser to simulate a graphic environment

[Browsh](brow.sh) is a fully-modern text-based browser. It renders anything that a modern browser can; HTML5, CSS3, JS, video and even WebGL. Its main purpose is to be run on a remote server and accessed via SSH/Mosh or the in-browser HTML service in order to significantly reduce bandwidth and thus both increase browsing speeds and decrease bandwidth costs.

It can be used inside a Pod or Container in a remote environment without prot-forward ou SSH connections, just terminal access. It uses Firefox to render everything.

```bash
kubectl run brownsh --image=alpine:3.20.2 -- sleep infinity
kubectl exec -it brownsh -- sh

apk update
apk add wget firefox file

wget https://github.com/browsh-org/browsh/releases/download/v1.8.0/browsh_1.8.0_linux_amd64
file browsh_1.8.0_linux_amd64
mv browsh_1.8.0_linux_amd64 /usr/local/bin/browsh
chmod +x /usr/local/bin/browsh
browsh http://www.google.com
```

Use mouse to click and select as any other browser.

| Key                  | Action                    |
|----------------------|---------------------------|
|F1                    | Opens the documentation   |
|ARROW KEYS, PGUP, PGDN| Scrolling                 |
|CTRL+q                | Exit app                  |
|CTRL+l                | Focus the URL bar         |
|BACKSPACE             | Go back in history        |
|CTRL+r                | Reload page               |
|CTRL+t                | New tab                   |
|CTRL+w                | Close tab                 |
|CTRL+\                | Cycle to next tab         |

## Forward a TCP port from Windows to WSL

Prerequisites:
- Allow conection on Windows firewall
  - Windows Defender Firewall > Input rules > New Rule > TCP 22 all networks
- Check your WSL IP addess (ip add show eth0 | 172.22.185.230)
- Check your Windows IP address (ipconfig | 192.168.1.14)

1. Create a portproxy rule:
    ```powershell
    netsh interface portproxy set v4tov4 listenport=22 listenaddress=192.168.1.14 connectport=22 connectaddress=172.22.185.230
    ```
1. List portproxy rules:
    ```powershell
    netsh interface portproxy show v4tov4
    ```
1. Erase rules after use:
    ```powershell
    netsh interface portproxy delete v4tov4 listenport=22 listenaddress=0.0.0.0
    ```   

## Include images as Base64 code inside a Markdown file

First, use convert to resize your image. There are many ways to resize the image in Markdown, but it is best to use the smallest size to minimize the amount of Base64 code inside your markdown. Execute the best option for your context as shown in the following examples:

```bash
convert image.png -resize 10%     image-small.png
convert image.pnt -resize 100x    image-100width.png
convert image.png -resize x80     image-80height.png
convert image.png -resize 100x50! image-distorced.png
```

The next step is to convert the image to a Base64 code. The option `-w0` is needed because the code has to be written in 1 line only. The `xclip` command is only to copy the code to clipboard. It is the simplest step:

```bash
base64 -w0 image-small.png|xclip -sel copy
```

We can insert the image by using one line only or by using a reference. First, one line for cases where the image is needed one time only.

```markdown
![image](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAMAAABVlYYBA...)
```
This is an example: ![image](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAMAAABVlYYBAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACLlBMVEUAAAAxbOUybOUya+Uya+QxbOQxa+UybOQxa+QybOUybOUybOUxbOUybOUybOUybOUxa+QxbOUybOUybOUybOUxa+QybOUybOUybOUybOUybOUybOQybOUybOUybOUxa+UxbOUybOUybOUybOUxbOUybOUybOUybOUybOUybOUybOUybOUybOUybOUybOUxa+UybOQybOUybOUybOUxa+UybOUybOUybOUybOUya+UybOUybOUxa+UybOUybOUybOUybOQybOQybOUybOUwauQybOUxa+Q0buVKfegwa+Q/deaowPQvauQ1buVVhem3y/VUhOk0beVjj+tbieppk+y5zfbb5fr09/1mketciupkj+thjuutxPSqwvSbt/J9ou7g6ft+ou6cuPKpwfSsxPRgjeotaOR7oO7+/v7S3/lOgOjj6/tPgejU4Pn9/v55n+6xx/W6zfbY4/qyx/X3+f6yyPXZ5Pq4zPa1yvVFeufX4vlijus9dObE1Pf19/3C0/fD1Pc8c+ZFeecuaeTe5/qYtfLn7fva5Prn7vysw/SatvJPgOg5ceWFp++owPPx9P3d5vqvxfTx9f3r8fymv/Pc5fqowfSGqO84cOXA0vc2b+Vsluzp7/xtluy+0fZThOlnkusvaeTT4PmivPO+0Parw/Sgu/LV4fldiurR3vn8/f6wxvR+o+78/P5fjOqQr/CzyfWzyPW0yfWRsPFEeedEeOdJfehJfOc3cOX///8SQG9iAAAARHRSTlMAAAAAAAAAAAAed7keInbP+wIrhNoCAZHi45IBEMAz8O9h/mABlA/DL+b6m7dP504CZvVlAgaI/KkQIcYhN9xQvMXFu17Oa5oAAAABYktHRLk6uBZgAAAAB3RJTUUH6QcDESoCwYv3VwAAAadJREFUGNNjYAABRiZmTi5uLh5mJkYGKGBmZGLh5eMXcBHg5+NlYmJlAwkyMQkKCYu4url7uLu5iggLiTKxA0XFhMQlXF1dPb28vTyBtKSUkDRQVEbW1cXFzcfXzz8g0MfNxcVVVgYoKifvGRTsFhIaFh7mH+EWGeWpIAe0XlHJJTomNiwuPiExKSw5JdVFSZmRQUXV1TUtPSMzyy/bLyc3Lz/N1VVVhUFN3dXN17+gsKi4pLSsvLQC6BB1NQYNTVfPyqrqmtq6+rqGxqCqJk9XTQ0GZS235qyW1ti2suj2js6ulu5mNy1lBm23nt6+/gkT+yZNnjQlZuqkadN73LQZdNxmhAR4z5w1e473nLm+85LnL5jhpsOgq+e2sDlr0eIlS11jlyxbntO80E1Pn8HA0MjV1WXFylWr10xcu2idi6urkbEJA5Opmbmr28L1G4obNm7a7OPmam5mCgw1JhkLV88tS7e4zXLbunSLp6uFJRM4KK2s3WZsc3Vzc3PdvsPN2oYJEupMtnZuLm7AUASSdrZMHJDIYGGyd3B0dHQCAmd7VhagCAAAAHZebST05wAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyNS0wNy0wM1QxNzozNjowMCswMDowMFBjX+MAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjUtMDctMDNUMTc6MzU6MzQrMDA6MDCwyX+sAAAAAElFTkSuQmCC)

By using references, we can include the Base64 code in one place (at the end of the file, for example) and reference it in other places. Check the following example:

```markdown
The image: ![image][img001]
(...)
[img001]: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAMAAABVlYYBA...
```

This is another example: ![image][img001]

[img001]: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAMAAABVlYYBAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAACLlBMVEUAAAAxbOUybOUya+Uya+QxbOQxa+UybOQxa+QybOUybOUybOUxbOUybOUybOUybOUxa+QxbOUybOUybOUybOUxa+QybOUybOUybOUybOUybOUybOQybOUybOUybOUxa+UxbOUybOUybOUybOUxbOUybOUybOUybOUybOUybOUybOUybOUybOUybOUybOUxa+UybOQybOUybOUybOUxa+UybOUybOUybOUybOUya+UybOUybOUxa+UybOUybOUybOUybOQybOQybOUybOUwauQybOUxa+Q0buVKfegwa+Q/deaowPQvauQ1buVVhem3y/VUhOk0beVjj+tbieppk+y5zfbb5fr09/1mketciupkj+thjuutxPSqwvSbt/J9ou7g6ft+ou6cuPKpwfSsxPRgjeotaOR7oO7+/v7S3/lOgOjj6/tPgejU4Pn9/v55n+6xx/W6zfbY4/qyx/X3+f6yyPXZ5Pq4zPa1yvVFeufX4vlijus9dObE1Pf19/3C0/fD1Pc8c+ZFeecuaeTe5/qYtfLn7fva5Prn7vysw/SatvJPgOg5ceWFp++owPPx9P3d5vqvxfTx9f3r8fymv/Pc5fqowfSGqO84cOXA0vc2b+Vsluzp7/xtluy+0fZThOlnkusvaeTT4PmivPO+0Parw/Sgu/LV4fldiurR3vn8/f6wxvR+o+78/P5fjOqQr/CzyfWzyPW0yfWRsPFEeedEeOdJfehJfOc3cOX///8SQG9iAAAARHRSTlMAAAAAAAAAAAAed7keInbP+wIrhNoCAZHi45IBEMAz8O9h/mABlA/DL+b6m7dP504CZvVlAgaI/KkQIcYhN9xQvMXFu17Oa5oAAAABYktHRLk6uBZgAAAAB3RJTUUH6QcDESoCwYv3VwAAAadJREFUGNNjYAABRiZmTi5uLh5mJkYGKGBmZGLh5eMXcBHg5+NlYmJlAwkyMQkKCYu4url7uLu5iggLiTKxA0XFhMQlXF1dPb28vTyBtKSUkDRQVEbW1cXFzcfXzz8g0MfNxcVVVgYoKifvGRTsFhIaFh7mH+EWGeWpIAe0XlHJJTomNiwuPiExKSw5JdVFSZmRQUXV1TUtPSMzyy/bLyc3Lz/N1VVVhUFN3dXN17+gsKi4pLSsvLQC6BB1NQYNTVfPyqrqmtq6+rqGxqCqJk9XTQ0GZS235qyW1ti2suj2js6ulu5mNy1lBm23nt6+/gkT+yZNnjQlZuqkadN73LQZdNxmhAR4z5w1e473nLm+85LnL5jhpsOgq+e2sDlr0eIlS11jlyxbntO80E1Pn8HA0MjV1WXFylWr10xcu2idi6urkbEJA5Opmbmr28L1G4obNm7a7OPmam5mCgw1JhkLV88tS7e4zXLbunSLp6uFJRM4KK2s3WZsc3Vzc3PdvsPN2oYJEupMtnZuLm7AUASSdrZMHJDIYGGyd3B0dHQCAmd7VhagCAAAAHZebST05wAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyNS0wNy0wM1QxNzozNjowMCswMDowMFBjX+MAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjUtMDctMDNUMTc6MzU6MzQrMDA6MDCwyX+sAAAAAElFTkSuQmCC

## Pandoc - Markdown Convert

Command used to convert markdown files to PDF, DOCX, HTML, ePub, RST.

Install/copy pandoc binary first: [https://github.com/jgm/pandoc/releases/](https://github.com/jgm/pandoc/releases/)

```bash
pandoc file.md -o file.docx
```

Use a `reference.docx` to copy text format to the generated file.

```bash
pandoc file.md --reference-doc=reference.docx -o file.docx
```

## Tailscale

Tailscale is a VPN client to connect computing devices (notebooks, cellphones, cloud servers, etc.) and other devices (Amazon Fire, IoT, containers, etc.). It is free for personal use and supports 6 users and 100 devices. It is simple to deploy and operate; no knowledge of networks is required.

#### Windows Installation

- Login in your browser. I am using the Google account to login.
- Access [https://tailscale.com/download/windows](https://tailscale.com/download/windows) and download the Windows version.
- Run the installer and install.
- Open the Tailscale application > Get Started > Sign in to your network > In your browser, sign in again > Connect > back to the Tailscale application.

> Notes:
>   - From now on, Tailscale will appear in the system tray to perform local operations.
>   - The admin console is [https://login.tailscale.com/admin](https://login.tailscale.com/admin/welcome).
>   - TCP ports open in WSL are not accessible from other clients. You can use [Forward a TCP port from Windows to WSL](other.md#forward-a-tcp-port-from-windows-to-wsl) to solve this.
>   - It does not create any virtual interface visible by Windows configurations. But it appears in `ipconfig` command list.

#### Android Installation

- Play Store > Search Tailscale > Install > Open.
- Give Android permission when requested (create VPN connection).
- Sign in with Google (same account) > Connect.

Both devices and IP addresses will be listed on the Android app and admin panel. 

#### Configuring Windows RDP Access

- Configuration > Remote Desktop > Enable.
- On Android I am using aRDP. It does not support multiple monitors.
  - Name: Choose a name: ideapad
  - Address: Tailscale Name or IP: ideapad or 100.X.Y.Z
  - Port: 3389
  - User: My Hotmail user (same used to log in)
  - Domain: .
  - Password: Same as Hotmail account

#### WSL installation

- Run `curl -fsSL https://tailscale.com/install.sh | sh`
- Run `sudo tailscale up` > Copy URL > Paste on browser > Log in > Connect.
- It will get the same Windows name. Change it from the admin panel.

#### Debian based distros

> Follow these instructions if the script shows any problems. It not worked in my Deepin 25.

- Download public key (using other directory because my distro mounts `/usr` as read only):
```bash
sudo mkdir /home/apt-keyrings/
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /home/apt-keyrings/tailscale-archive-keyring.gpg > /dev/null
sudo apt-key add /home/apt-keyrings/tailscale-archive-keyring.gpg
ls -l /home/apt-keyrings/tailscale-archive-keyring.gpg
```

- Configure apt repository:
```bash
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee -a /etc/apt/sources.list
cat /etc/apt/sources.list
sudo sed -i 's/\/usr\/share\/keyrings\//\/home\/apt-keyrings\//' /etc/apt/sources.list
cat /etc/apt/sources.list
```

- Install:
```bash
sudo apt update
sudo apt install -y tailscale tailscale-archive-keyring
sudo systemctl enable --now tailscaled
sudo systemctl start tailscaled
```

- Initial configuration:
```bash
sudo tailscale up
```
- Copy URL > Paste on browser > Login > Connect

#### Expose files and connections from Linux

Expose an HTTPS server with the content of `/home/user/dir` to the internet.
```bash
sudo tailscale serve /home/user/dir
```

Expose an HTTP (not HTTPS) server running at 127.0.0.1:3000:
```bash
    $ tailscale serve 3000
```

Check the access URL from command line.

## CloudFlare Tunnel

> You can use a CloudFlare domain or a external domain. I am describing a domain from Registro.BR to show a complete process. If you want to use a CloudFlare domain, jump to 4.

1. CloudFlare (to use an external domain):
    - Domains > Onboard a Doman > [insert your domain] > Continue > Free > Continue to activation
    - On the next page apears the DNS server list (`kyrie.ns.cloudflare.com` and `mallory.ns.cloudflare.com`). Copy them to update your extenal domain configuration.

2. Registro.BR (to use an external domain):
    - Domains (Domínios) > [Your Domain] > Change DNS servers > [change the DNS servers to CloudFlare servers]
    - Save changes (Salvar alterações) > Confirm (Confirmar)

3. Registro.BR replicate DNS registers on 2 hours. Wait until finish. To check it, run following commands. When all the answers are the same, we can finish the process.

```bash
host -t SOA amicomcariri.com.br kyrie.ns.cloudflare.com
host -t SOA amicomcariri.com.br mallory.ns.cloudflare.com
host -t SOA amicomcariri.com.br 1.1.1.1
host -t SOA amicomcariri.com.br 8.8.8.8
host -t SOA amicomcariri.com.br 208.67.222.222
host -t SOA amicomcariri.com.br
```

4. CloudFlare:
    - At the first access on Zero Trust is necessary setup:
        - Team name = [type a new name]
        - Plan = Zero Trust Free > Select plan
        - Confirm payment method > Review and purchase
    - Zero Trust > Network > Connectors > Add a tunnel > Select CloudFlared 
        - Name = [type a name according to your DNS]
        - Environment = Docker [or other according to your environment]

5. Install the connector using the instructions presented according to your environment

6. CloudFlare:
    - Back to CloudFlare the connector IP will be shown if everything is correct.
    - Next to finish the assitant > Router Traffic:
        - Hostname:
            - Subdomain = www
            - Domain = [include your domain]
            - Path = [empty or a path inside your web server]
        - Service:
            - Type = HTTP [no security problems, just the communication between the connector and your service is unencrypted]
            - URL = [IP or name to access the destinations service from the connector]
                - If the connector is a container, do not use `localhost` because, in this case, `localhost` is the connector itself.
        - Complete setup
    - Check if the tunnel is **HEALTHY**.
    - Access using the DNS name.

# Audio transcript

1. Check CUDA version. 
```bash
nvidia-smi
```

2. Install torch. For CUDA Version: 13.0 use:
```bash
pip install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu130
```

3. Install whisper:
```bash
pip install openai-whisper
```

4. Transcribe with GPU support:
```bash
export s2t_file="2026-03-24 15-33-37.mp3" 
whisper "$s2t_file" \
  --language Portuguese \
  --task transcribe \
  --model small \
  --output_format txt
```

5. If you have problems, use CPU instead GPU:
```bash
export s2t_file="2026-03-24 15-33-37.mp3" 
  whisper "$s2t_file" \
  --language Portuguese \
  --task transcribe \
  --model small \
  --device cpu \
  --output_format txt
```

6. If you have problems with FP16 (Float Point Numbers), common in old NVIDIA GPUs:
```bash
export s2t_file="2026-03-24 15-33-37.mp3" 
whisper "$s2t_file" \
  --language Portuguese \
  --task transcribe \
  --model small \
  --device cuda \
  --fp16 False \
  --output_format txt
```

7. Use `--model medium` (~5GB) or `--model large` (~10GB) for more precise detection if you GPU supports.

