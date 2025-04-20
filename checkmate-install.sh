#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/Layer-Group/checkmate-lxc/main/misc/build.func)

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

msg_ok "Checkmate cloned successfully."
msg_info "Note: No docker-compose.yml found. You may need to start the dev server manually."

msg_info "Suggested next steps (inside LXC):"
echo -e "${TAB}${INFO} Run:${CL} cd /root/Checkmate && ./scripts/dev.sh"

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL (after dev server starts):${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"
