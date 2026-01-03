#!/bin/bash
# SPDX-FileCopyrightText: 2024 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# IHP-focused container: Only installs ciel (PDK manager)
# PDKs sky130 and gf180mcu have been removed - this container is IHP-only
#
set -e

if [ ! -d "$PDK_ROOT" ]; then
    mkdir -p "$PDK_ROOT"
fi

# Install ciel via pip (PDK version manager)
echo "[INFO] Installing ciel (PDK version manager)."
pip3 install --upgrade --no-cache-dir --break-system-packages --ignore-installed \
	ciel

echo "[INFO] ciel installed successfully."
echo "[INFO] Note: This is an IHP-focused container. Only IHP SG13G2 PDK will be installed."
