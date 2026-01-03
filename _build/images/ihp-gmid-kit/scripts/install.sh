#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 Harald Pretl, Mauricio Montanares
# SPDX-License-Identifier: Apache-2.0
#
# Install IHP gm/ID Design Kit for analog IC design

set -e

mkdir -p "$TOOLS"
git clone --filter=blob:none "$IHP_GMID_KIT_REPO_URL" "${TOOLS}/$IHP_GMID_KIT_NAME"
cd "${TOOLS}/$IHP_GMID_KIT_NAME" || exit 1
git checkout "$IHP_GMID_KIT_REPO_COMMIT"

# Install Python dependencies
pip3 install -r requirements.txt --no-cache-dir

# Add the src directory to PYTHONPATH by creating a .pth file
SITE_PACKAGES=$(python3 -c "import site; print(site.getsitepackages()[0])")
echo "${TOOLS}/$IHP_GMID_KIT_NAME/src" > "${SITE_PACKAGES}/ihp_gmid.pth"
echo "${TOOLS}/$IHP_GMID_KIT_NAME/vendor" >> "${SITE_PACKAGES}/ihp_gmid.pth"

echo "[INFO] IHP gm/ID Design Kit installed successfully"
