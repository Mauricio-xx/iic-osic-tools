#!/bin/bash
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# KLayout DRC Invocation Validation

set -e

TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

echo "[INFO] Running testcase: klayout-invocation"
echo "[INFO] Validating KLayout DRC environment for IHP SG13G2"

# Run validation script
python3 "$TESTCASE_DIR/inputs/check_drc.py" > "$OUTPUT_DIR/validation.log" 2>&1

# Check result
if grep -q "FAIL" "$OUTPUT_DIR/validation.log"; then
    echo "[FAIL] DRC environment validation failed"
    cat "$OUTPUT_DIR/validation.log"
    exit 1
fi

echo "[PASS] KLayout DRC environment validated successfully"
exit 0
