#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Layer-Group/checkmate-lxc/main/misc/build.func)
# Copyright (c) 2025 Layer Group
# Author: Bryan Trappenberg
# License: MIT | https://github.com/Layer-Group/checkmate-lxc/blob/main/LICENSE
# Source: https://docs.checkmate.so/

APP="Checkmate"
var_tags="${var_tags:-ai,docker}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
var_os="${var_os:-ubuntu}"
var_version="${var_version:-22.04}"
var_unprivileged="${var_unprivileged:-0}"  # Docker requires privileged container

SPINNER_PID=""

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  msg_error "No update logic available yet for $APP."
  exit
}

start
build_container
description

msg_info "Installing Docker & Checkmate..."
lxc-attach -n $CTID -- bash -c "apt update && apt install -y docker.io docker-compose git locales"
lxc-attach -n $CTID -- bash -c "locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8"
lxc-attach -n $CTID -- systemctl enable docker
lxc-attach -n $CTID -- systemctl start docker

msg_info "Cloning Checkmate repository..."
lxc-attach -n $CTID -- bash -c "cd /root && git clone --depth=1 https://github.com/bluewave-labs/Checkmate.git"

# Remove or comment out:
# msg_info "Pulling Docker images for Checkmate..."
# lxc-attach -n $CTID -- bash -c "cd /root/Checkmate && docker-compose pull"

# Replace with post-clone instructions
msg_ok "Checkmate cloned. No docker-compose file present."
msg_info "Please follow manual instructions to run services:"
echo -e "${TAB}${INFO} Run: ${CL}cd /root/Checkmate && ./scripts/dev.sh"


msg_info "Setting up environment..."
lxc-attach -n $CTID -- bash -c "cd /root/Checkmate && cp .env.example .env"

msg_info "Starting Checkmate with Docker Compose..."
lxc-attach -n $CTID -- bash -c "cd /root/Checkmate && docker-compose up -d"

msg_ok "Docker & Checkmate installed successfully"

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"
