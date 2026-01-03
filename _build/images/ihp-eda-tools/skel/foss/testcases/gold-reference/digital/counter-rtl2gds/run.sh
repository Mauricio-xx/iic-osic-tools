#!/bin/bash
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Counter RTL-to-GDS Testcase Execution Script

set -e

# Get testcase directory
TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set output directory (can be overridden by iic-testcase)
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment with standard cells
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell > /dev/null 2>&1 || true

echo "[INFO] Running testcase: counter-rtl2gds"
echo "[INFO] Output directory: $OUTPUT_DIR"

# Copy input files to output directory (LibreLane needs them in working dir)
WORKDIR="$OUTPUT_DIR/work"
mkdir -p "$WORKDIR"
cp "$TESTCASE_DIR/inputs"/* "$WORKDIR/"

# Run LibreLane RTL-to-GDS flow
echo "[INFO] Running LibreLane RTL-to-GDS flow..."
cd "$WORKDIR"
librelane --manual-pdk "$WORKDIR/counter.json" > "$OUTPUT_DIR/librelane.log" 2>&1

# Check for errors in the log
if grep -q "ERROR" "$OUTPUT_DIR/librelane.log"; then
    echo "[FAIL] LibreLane flow failed. Check $OUTPUT_DIR/librelane.log"
    exit 1
fi

# Find and copy final GDS output
GDS_FILE=$(find "$WORKDIR" -name "counter.gds" -type f 2>/dev/null | head -1)
if [ -z "$GDS_FILE" ]; then
    GDS_FILE=$(find "$WORKDIR" -name "*.gds" -type f 2>/dev/null | head -1)
fi

if [ -n "$GDS_FILE" ]; then
    cp "$GDS_FILE" "$OUTPUT_DIR/counter.gds"
    echo "[INFO] GDS output: $OUTPUT_DIR/counter.gds"
else
    echo "[WARN] GDS file not found in expected location"
fi

# Find and copy LEF output
LEF_FILE=$(find "$WORKDIR" -name "counter.lef" -type f 2>/dev/null | head -1)
if [ -z "$LEF_FILE" ]; then
    LEF_FILE=$(find "$WORKDIR" -name "*.lef" -type f 2>/dev/null | head -1)
fi

if [ -n "$LEF_FILE" ]; then
    cp "$LEF_FILE" "$OUTPUT_DIR/counter.lef"
    echo "[INFO] LEF output: $OUTPUT_DIR/counter.lef"
fi

echo "[PASS] Counter RTL-to-GDS flow completed successfully"
exit 0
