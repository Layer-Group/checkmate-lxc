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

msg_info "Installing Docker & Checkmate dependencies..."
lxc-attach -n "$CTID" -- bash -c "apt update && apt install -y docker.io docker-compose git locales curl"
lxc-attach -n "$CTID" -- bash -c "locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8"
lxc-attach -n "$CTID" -- systemctl enable docker
lxc-attach -n "$CTID" -- systemctl start docker
msg_ok "Docker & dependencies installed."

msg_info "Cloning Checkmate repository..."
lxc-attach -n "$CTID" -- bash -c "cd /root && git clone --depth=1 https://github.com/bluewave-labs/Checkmate.git"
msg_ok "Checkmate cloned successfully."

msg_info "Downloading docker-compose.yaml..."
lxc-attach -n "$CTID" -- bash -c "curl -fsSL https://raw.githubusercontent.com/bluewave-labs/Checkmate/refs/heads/master/Docker/dist/docker-compose.yaml -o /root/Checkmate/docker-compose.yaml"
msg_ok "docker-compose.yaml downloaded."

msg_info "Creating environment files..."

# Backend .env
lxc-attach -n "$CTID" -- bash -c "cat <<EOF > /root/Checkmate/backend/.env
ENVIRONMENT=development
PORT=5000
CHECKMATE_API_KEY=supersecurekey
EOF"

# Frontend .env
lxc-attach -n "$CTID" -- bash -c "cat <<EOF > /root/Checkmate/frontend/.env
VITE_API_BASE_URL=http://localhost:5000
EOF"

msg_ok ".env files created successfully."

msg_info "Starting Checkmate with Docker Compose..."
lxc-attach -n "$CTID" -- bash -c "cd /root/Checkmate && docker-compose up -d"
msg_ok "Checkmate is now running in the background."

msg_ok "Completed Successfully!"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Frontend should be accessible at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5173${CL}"
echo -e "${INFO}${YW} Backend API should be accessible at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:5000${CL}"
