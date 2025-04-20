# 🧩 Checkmate LXC Installer for Proxmox VE

![License](https://img.shields.io/github/license/Layer-Group/checkmate-lxc)
![Proxmox VE](https://img.shields.io/badge/platform-Proxmox%20VE-blue)
![Status](https://img.shields.io/badge/status-active-brightgreen)

This script installs [Checkmate](https://docs.checkmate.so/) in a **privileged LXC container** on Proxmox VE.  
It automatically installs **Docker**, **Docker Compose**, and the Checkmate stack — making it easy to self-host.

> ✅ Inspired by the [ProxmoxVE Community Scripts](https://github.com/community-scripts/ProxmoxVE) by [tteck](https://github.com/tteck)

---

## ⚡️ Quick Install

Run this on your Proxmox VE host:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Layer-Group/checkmate-lxc/main/checkmate-install.sh)
This will:

Prompt you to configure resources (CPU, RAM, Disk, etc.)

Create a privileged Ubuntu 22.04 LXC container

Install Docker, Docker Compose

Clone and start the Checkmate app

🔍 What is Checkmate?
Checkmate is an open-source framework for building secure AI agents.
It helps you manage credentials, secrets, policies, and access controls when working with large language models (LLMs) in production.

📚 Official docs: https://docs.checkmate.so

🚀 Features
✅ One-liner LXC installer
🐳 Docker + Docker Compose included
🌐 Web UI available at http://<container-ip>:3000
🔐 Installs in a secure, privileged container
⚙️ Customizable via CLI prompts (CPU, RAM, storage, VLAN, etc.)

🧠 Requirements
Proxmox VE 7 or 8
Ubuntu 22.04 LXC template available (pveam update && pveam download local ubuntu-22.04-standard)
Internet connection

🛠 Configuration
The script will prompt you for:
Container ID
Hostname
Network config (DHCP/static IP)
Optional VLAN tag
CPU / RAM / Disk settings

🌐 Accessing Checkmate
After installation, Checkmate will be accessible from your browser:

http://<container-ip>:3000
Use pct list and pct exec <CTID> ip a if you're unsure of the container's IP.

🧩 What's Included in the Container?

Component	Version	Installed?
OS	Ubuntu 22.04	✅
Docker	latest	✅
Docker Compose	latest	✅
Checkmate	latest (from GitHub)	✅
🤝 Contributing
Pull requests are welcome! If you’d like to:

Add reverse proxy (NGINX/Caddy) options

Improve .env automation

Add update/uninstall scripts

Feel free to fork and submit a PR.

📄 License
MIT License. See LICENSE file.

🙌 Credits
Checkmate

Tteck's ProxmoxVE scripts

Maintained by Layer Group.

Let me know if you'd like a matching `checkmate-update.sh` or a badge-friendly GitHub banner!
