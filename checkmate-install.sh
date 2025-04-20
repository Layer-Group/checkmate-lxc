#!/usr/bin/env bash
# source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://docs.checkmate.so/

APP="Checkmate"
var_tags="${var_tags:-docker,web}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
var_os="${var_os:-ubuntu}"
var_version="${var_version:-22.04}"
var_unprivileged="${var_unprivileged:-0}" # Needs privileged for nesting/docker

header_info "$APP"
variables
color
catch_errors

start
build_container
description

msg_info "Installing Docker & Checkmate..."
lxc-attach -n $CTID -- bash -c "apt update && apt install -y docker.io docker-compose git"
lxc-attach -n $CTID -- systemctl enable docker
lxc-attach -n $CTID -- systemctl start docker
lxc-attach -n $CTID -- bash -c "cd /root && git clone https://github.com/checkmateso/checkmate.git"
lxc-attach -n $CTID -- bash -c "cd /root/checkmate && cp .env.example .env"
lxc-attach -n $CTID -- bash -c "cd /root/checkmate && docker compose up -d"
msg_ok "Installed Docker & Checkmate"

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}" 
