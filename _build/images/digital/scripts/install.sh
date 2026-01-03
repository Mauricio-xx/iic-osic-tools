#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Install Digital - Logic Designer and Circuit Simulator
# https://github.com/Mauricio-xx/digital-designer

set -e
cd /tmp

# Clone repository (full history required for git-commit-id-plugin)
echo "[INFO] Cloning Digital from ${DIGITAL_REPO_URL}"
git clone "${DIGITAL_REPO_URL}" digital-src
cd digital-src
git checkout "${DIGITAL_REPO_COMMIT}"

# Build with Maven
echo "[INFO] Building Digital with Maven..."
mvn package -DskipTests -q

# Install
mkdir -p "${TOOLS}/${DIGITAL_NAME}/bin"
cp target/Digital.jar "${TOOLS}/${DIGITAL_NAME}/"
cp -r examples "${TOOLS}/${DIGITAL_NAME}/" 2>/dev/null || true
cp -r distribution/docu "${TOOLS}/${DIGITAL_NAME}/" 2>/dev/null || true

# Create launcher script
cat > "${TOOLS}/${DIGITAL_NAME}/bin/digital" << 'EOF'
#!/bin/bash
# Digital - Logic Designer and Circuit Simulator
DIGITAL_HOME="$(dirname "$(dirname "$(readlink -f "$0")")")"
java -jar "${DIGITAL_HOME}/Digital.jar" "$@"
EOF
chmod +x "${TOOLS}/${DIGITAL_NAME}/bin/digital"

# Verify installation
if [ -f "${TOOLS}/${DIGITAL_NAME}/Digital.jar" ]; then
    echo "[INFO] Digital installed successfully at ${TOOLS}/${DIGITAL_NAME}"
else
    echo "[ERROR] Digital.jar not found after build"
    exit 1
fi

# Cleanup
cd /tmp && rm -rf digital-src
