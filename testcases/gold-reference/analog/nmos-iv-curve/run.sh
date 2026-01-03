#!/bin/bash
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# NMOS IV Curve Testcase Execution Script

set -e

# Get testcase directory
TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set output directory (can be overridden by iic-testcase)
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

echo "[INFO] Running testcase: nmos-iv-curve"
echo "[INFO] Output directory: $OUTPUT_DIR"

# Create temporary SPICE file with correct output path
TEMP_SPICE="$OUTPUT_DIR/tb_nmos.spice"
sed "s|\$OUTPUT_DIR|$OUTPUT_DIR|g" "$TESTCASE_DIR/inputs/tb_nmos.spice" > "$TEMP_SPICE"

# Run ngspice simulation
echo "[INFO] Running ngspice DC simulation..."
ngspice -b "$TEMP_SPICE" > "$OUTPUT_DIR/simulation.log" 2>&1

# Check for errors
if grep -qi "error" "$OUTPUT_DIR/simulation.log"; then
    echo "[FAIL] Simulation errors found. Check $OUTPUT_DIR/simulation.log"
    exit 1
fi

# Verify output file was created
if [ ! -f "$OUTPUT_DIR/nmos_iv.raw" ]; then
    echo "[FAIL] Output file nmos_iv.raw not created"
    exit 1
fi

echo "[PASS] NMOS IV curve simulation completed successfully"
echo "[INFO] Results: $OUTPUT_DIR/nmos_iv.raw"
exit 0
