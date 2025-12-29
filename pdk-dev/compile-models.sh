#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Compile Verilog-A models to OSDI for ngspice
# Uses OpenVAF compiler

set -e

echo "=== IHP SG13G2 Model Compilation ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Check for OpenVAF
if ! command -v openvaf &> /dev/null; then
    echo "[ERROR] OpenVAF not found in PATH"
    exit 1
fi

echo "[INFO] OpenVAF version: $(openvaf --version 2>&1 | head -1)"

# Find Verilog-A source files
VA_DIR="$PDK_ROOT/ihp-sg13g2/libs.tech/ngspice/models"
if [ ! -d "$VA_DIR" ]; then
    VA_DIR="$PDK_ROOT/ihp-sg13g2/libs.tech/ngspice"
fi

echo "[INFO] Searching for Verilog-A files in: $VA_DIR"

VA_FILES=$(find "$VA_DIR" -name "*.va" 2>/dev/null)

if [ -z "$VA_FILES" ]; then
    echo "[WARNING] No Verilog-A files found"
    echo "[INFO] OSDI models may be pre-compiled in the PDK"

    # Check for existing OSDI files
    OSDI_FILES=$(find "$PDK_ROOT/ihp-sg13g2" -name "*.osdi" 2>/dev/null)
    if [ -n "$OSDI_FILES" ]; then
        echo "[INFO] Found existing OSDI files:"
        echo "$OSDI_FILES"
    fi
    exit 0
fi

# Compile each Verilog-A file
ERRORS=0
COMPILED=0

OUTPUT_DIR="${OUTPUT_DIR:-/tmp/osdi_build}"
mkdir -p "$OUTPUT_DIR"

for va_file in $VA_FILES; do
    basename=$(basename "$va_file" .va)
    echo "[INFO] Compiling: $basename.va"

    osdi_file="$OUTPUT_DIR/${basename}.osdi"

    if openvaf "$va_file" -o "$osdi_file" 2>&1; then
        echo "  [PASS] Compiled to: $osdi_file"
        ((COMPILED++))
    else
        echo "  [FAIL] Compilation failed"
        ((ERRORS++))
    fi
done

echo ""
echo "=== Compilation Summary ==="
echo "Compiled: $COMPILED"
echo "Failed: $ERRORS"
echo "Output directory: $OUTPUT_DIR"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] Some compilations failed"
    exit 1
else
    echo "[INFO] All compilations successful"
    exit 0
fi
