#!/bin/bash
# SPDX-FileCopyrightText: [YEAR] [YOUR NAME]
# SPDX-License-Identifier: Apache-2.0
#
# Testcase Execution Script
# This script is called by iic-testcase run/validate

set -e

# Get testcase directory (where this script is located)
TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Output directory (set by iic-testcase or default to ./output)
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
# Options: ihp-sg13g2, ihp-sg13g2 sg13g2_stdcell (with standard cells)
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

echo "[INFO] Running testcase: $(basename "$TESTCASE_DIR")"
echo "[INFO] Output directory: $OUTPUT_DIR"

# ============================================================================
# Your testcase implementation goes here
# ============================================================================

# Example: ngspice simulation
# ngspice -b "$TESTCASE_DIR/inputs/netlist.spice" \
#     -r "$OUTPUT_DIR/output.raw" \
#     -o "$OUTPUT_DIR/simulation.log"

# Example: KLayout DRC
# sak-drc.sh -k "$TESTCASE_DIR/inputs/layout.gds" -w "$OUTPUT_DIR"

# Example: LVS check
# sak-lvs.sh -s "$TESTCASE_DIR/inputs/schematic.sch" \
#            -l "$TESTCASE_DIR/inputs/layout.gds" \
#            -w "$OUTPUT_DIR"

# Example: LibreLane RTL-to-GDS
# cd "$OUTPUT_DIR"
# librelane --manual-pdk "$TESTCASE_DIR/inputs/design.json"

# ============================================================================
# Validation (basic checks before iic-testcase validates)
# ============================================================================

# Check for errors in log files
if [ -f "$OUTPUT_DIR/simulation.log" ]; then
    if grep -qi "error" "$OUTPUT_DIR/simulation.log"; then
        echo "[FAIL] Errors found in simulation log"
        exit 1
    fi
fi

# Verify expected output exists
# if [ ! -f "$OUTPUT_DIR/output.raw" ]; then
#     echo "[FAIL] Expected output not created"
#     exit 1
# fi

echo "[PASS] Testcase completed successfully"
exit 0
