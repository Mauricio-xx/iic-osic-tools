#!/bin/bash
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Netgen LVS Invocation Validation

set -e

TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

echo "[INFO] Running testcase: netgen-invocation"
echo "[INFO] Validating Netgen LVS environment for IHP SG13G2"

# Run validation script
python3 "$TESTCASE_DIR/inputs/check_lvs.py" > "$OUTPUT_DIR/validation.log" 2>&1

# Check result
if grep -q "FAIL" "$OUTPUT_DIR/validation.log"; then
    echo "[FAIL] LVS environment validation failed"
    cat "$OUTPUT_DIR/validation.log"
    exit 1
fi

echo "[PASS] Netgen LVS environment validated successfully"
exit 0
