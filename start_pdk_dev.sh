#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Start IHP-EDA-Tools container in PDK Development Mode
# This mounts a local PDK directory for editing and testing

set -e

# Default values
DOCKER_USER="${DOCKER_USER:-hpretl}"
DOCKER_IMAGE="${DOCKER_IMAGE:-ihp-eda-tools}"
DOCKER_TAG="${DOCKER_TAG:-latest}"
CONTAINER_NAME="ihp-eda-tools_pdk_dev_uid_$(id -u)"

# Parse arguments
PDK_SOURCE=""
EXTRA_ARGS=""

show_help() {
    echo "IHP-EDA-Tools PDK Development Mode"
    echo ""
    echo "Usage: $0 --pdk-source <path> [options]"
    echo ""
    echo "Required:"
    echo "  --pdk-source <path>  Path to local IHP PDK directory to mount"
    echo ""
    echo "Optional:"
    echo "  --image <name>       Docker image name (default: $DOCKER_IMAGE)"
    echo "  --tag <tag>          Docker image tag (default: $DOCKER_TAG)"
    echo "  --user <user>        Docker Hub user (default: $DOCKER_USER)"
    echo "  --name <name>        Container name (default: auto-generated)"
    echo "  --help               Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --pdk-source ~/IHP-Open-PDK"
    echo ""
    echo "Inside the container:"
    echo "  - PDK is mounted at /foss/pdks/ihp-sg13g2"
    echo "  - PDK dev tools are at /foss/pdk-dev"
    echo "  - Run validation scripts: /foss/pdk-dev/validate-*.sh"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --pdk-source)
            PDK_SOURCE="$2"
            shift 2
            ;;
        --image)
            DOCKER_IMAGE="$2"
            shift 2
            ;;
        --tag)
            DOCKER_TAG="$2"
            shift 2
            ;;
        --user)
            DOCKER_USER="$2"
            shift 2
            ;;
        --name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            EXTRA_ARGS="$EXTRA_ARGS $1"
            shift
            ;;
    esac
done

# Validate PDK source
if [ -z "$PDK_SOURCE" ]; then
    echo "[ERROR] --pdk-source is required"
    echo ""
    show_help
    exit 1
fi

if [ ! -d "$PDK_SOURCE" ]; then
    echo "[ERROR] PDK source directory not found: $PDK_SOURCE"
    exit 1
fi

# Convert to absolute path
PDK_SOURCE=$(cd "$PDK_SOURCE" && pwd)

# Check for expected PDK structure
if [ ! -d "$PDK_SOURCE/libs.tech" ]; then
    echo "[WARNING] Expected PDK structure not found in $PDK_SOURCE"
    echo "[INFO] Looking for libs.tech directory..."

    # Try common subdirectories
    if [ -d "$PDK_SOURCE/ihp-sg13g2/libs.tech" ]; then
        PDK_SOURCE="$PDK_SOURCE/ihp-sg13g2"
        echo "[INFO] Found PDK at: $PDK_SOURCE"
    else
        echo "[WARNING] Proceeding anyway, but PDK tools may not work correctly"
    fi
fi

FULL_IMAGE="${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"

echo "=== IHP-EDA-Tools PDK Development Mode ==="
echo ""
echo "Image: $FULL_IMAGE"
echo "PDK Source: $PDK_SOURCE"
echo "Container: $CONTAINER_NAME"
echo ""

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[INFO] Removing existing container: $CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1
fi

# Start container with PDK mounted
echo "[INFO] Starting container..."
docker run -it --rm \
    --name "$CONTAINER_NAME" \
    --user "$(id -u):$(id -g)" \
    -e DISPLAY="${DISPLAY:-:0}" \
    -e HOME=/headless \
    -v "$PDK_SOURCE":/foss/pdks/ihp-sg13g2:rw \
    -v "$PWD":/foss/designs:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    ${DOCKER_EXTRA_PARAMS:-} \
    "$FULL_IMAGE" \
    --skip bash -c "
        echo '=== PDK Development Mode Active ==='
        echo ''
        echo 'PDK mounted at: /foss/pdks/ihp-sg13g2'
        echo 'PDK dev tools: /foss/pdk-dev'
        echo ''
        echo 'Available commands:'
        echo '  /foss/pdk-dev/validate-drc.sh    - Validate DRC rules'
        echo '  /foss/pdk-dev/validate-lvs.sh    - Validate LVS setup'
        echo '  /foss/pdk-dev/compile-models.sh  - Compile Verilog-A models'
        echo '  /foss/pdk-dev/test-simulation.sh - Run simulation tests'
        echo '  /foss/pdk-dev/check-symbols.sh   - Validate xschem symbols'
        echo ''
        exec bash
    "
