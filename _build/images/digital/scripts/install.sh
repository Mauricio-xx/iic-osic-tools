#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Install Digital - Logic Designer and Circuit Simulator
# https://github.com/hneemann/Digital

set -e
cd /tmp || exit 1

# Extract version number from tag (e.g., v0.31 -> 0.31)
VERSION="${DIGITAL_REPO_COMMIT#v}"

# Download release ZIP
DOWNLOAD_URL="${DIGITAL_REPO_URL}/releases/download/${DIGITAL_REPO_COMMIT}/Digital.zip"
echo "[INFO] Downloading Digital ${DIGITAL_REPO_COMMIT} from ${DOWNLOAD_URL}"
curl -L -o Digital.zip "${DOWNLOAD_URL}"

# Create installation directory
mkdir -p "${TOOLS}/${DIGITAL_NAME}"

# Extract
unzip -q Digital.zip -d "${TOOLS}/${DIGITAL_NAME}"

# Create launcher script
cat > "${TOOLS}/${DIGITAL_NAME}/bin/digital" << 'EOF'
#!/bin/bash
# Digital - Logic Designer and Circuit Simulator
DIGITAL_HOME="$(dirname "$(dirname "$(readlink -f "$0")")")"
java -jar "${DIGITAL_HOME}/Digital.jar" "$@"
EOF

mkdir -p "${TOOLS}/${DIGITAL_NAME}/bin"
mv "${TOOLS}/${DIGITAL_NAME}/digital" "${TOOLS}/${DIGITAL_NAME}/bin/" 2>/dev/null || true
chmod +x "${TOOLS}/${DIGITAL_NAME}/bin/digital"

# Verify installation
if [ -f "${TOOLS}/${DIGITAL_NAME}/Digital.jar" ]; then
    echo "[INFO] Digital installed successfully at ${TOOLS}/${DIGITAL_NAME}"
else
    echo "[ERROR] Digital.jar not found after installation"
    exit 1
fi

# Cleanup
rm -f Digital.zip
