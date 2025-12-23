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

REPO_ROOT=$(git rev-parse --show-toplevel)

echo ""
echo "┌──────────────────────┐"
echo "│ Installing CLI tools │"
echo "└──────────────────────┘"
echo ""

if ! command -v docker &> /dev/null; then
    echo "docker not found - installing..."
    curl -sL https://get.docker.com | sudo bash
fi
sudo chmod 666 /var/run/docker.sock

PACKAGES=""
if ! command -v python &> /dev/null; then PACKAGES="python3 python-is-python3 python3-venv"; fi
if ! command -v pip &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }python3-pip"; fi
if ! command -v jq &> /dev/null; then PACKAGES="${PACKAGES:+$PACKAGES }jq"; fi
if ! dpkg -l | grep -q libpq-dev; then PACKAGES="${PACKAGES:+$PACKAGES }libpq-dev"; fi
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

[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$PATH:$HOME/.local/bin"

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