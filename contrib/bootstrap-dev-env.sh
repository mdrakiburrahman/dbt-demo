#!/bin/bash
#
#
#       Sets up a dev env with all pre-reqs. This script is idempotent, it will
#       only attempt to install dependencies, if not exists.   
#
# ---------------------------------------------------------------------------------------
#

set -e
set -m

export REPO_ROOT=$(git rev-parse --show-toplevel)
export DOCKER_VERSION="5:27.5.1-1~ubuntu.24.04~noble"
export ACCEPT_EULA=Y
export DEBIAN_FRONTEND=noninteractive
export OS_DISTRIBUTION=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)

curl -sSL -O "https://packages.microsoft.com/config/ubuntu/${OS_DISTRIBUTION}/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb >/dev/null
rm -f packages-microsoft-prod.deb

echo ""
echo "┌──────────────────────┐"
echo "│ Installing CLI tools │"
echo "└──────────────────────┘"
echo ""

if ! [ -x "$(command -v docker)" ]; then
  echo "docker is not installed on your devbox, installing..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update -q
  sudo apt-get install -y apt-transport-https ca-certificates curl
  sudo apt-get install -y --allow-downgrades docker-ce="$DOCKER_VERSION" docker-ce-cli="$DOCKER_VERSION" containerd.io
else
  echo "docker is already installed."
fi

PACKAGES=""
if ! command -v python &> /dev/null; then PACKAGES="python3 python-is-python3 python3-venv"; fi
if ! command -v pip &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }python3-pip"; fi
if ! command -v jq &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }jq"; fi
if ! command -v 7z &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }p7zip-full"; fi
if ! command -v docker-compose &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }docker-compose"; fi
if ! dpkg -l | grep -q libpq-dev; then PACKAGES="${PACKAGES:+$PACKAGES }libpq-dev"; fi
if ! dpkg -l | grep -q unixodbc-dev; then PACKAGES="${PACKAGES:+$PACKAGES }unixodbc-dev"; fi
if ! dpkg -l | grep -q "^ii  unixodbc "; then PACKAGES="${PACKAGES:+$PACKAGES }unixodbc"; fi
if [ -n "$PACKAGES" ]; then
  echo "Installing packages: $PACKAGES"
  sudo apt-get update > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $PACKAGES > /dev/null 2>&1
fi
command -v uv &> /dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
if ! command -v duckdb &> /dev/null; then
    echo "duckdb not found - installing..."
    curl https://install.duckdb.org | sh
    export PATH="$HOME/.duckdb/cli/latest:$PATH"
fi

if ! dpkg -l | grep -q msodbcsql18; then
    echo "Installing Microsoft ODBC Driver 18 for SQL Server..."
    sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18 > /dev/null 2>&1
else
    echo "Microsoft ODBC Driver 18 is already installed."
fi

[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$PATH:$HOME/.local/bin"
sudo chmod 666 /var/run/docker.sock

echo ""
echo "┌──────────┐"
echo "│ Versions │"
echo "└──────────┘"
echo ""

echo "Docker: $(docker --version)"
echo "UV: $(uv --version)"
echo "Python: $(python --version)"
echo "Pip: $(pip --version)"
echo "DuckDB: $(duckdb --version)"