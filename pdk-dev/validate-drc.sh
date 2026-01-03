#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Validate DRC rules for IHP SG13G2 PDK
# Runs DRC test cases to ensure rule deck is correct

set -e

echo "=== IHP SG13G2 DRC Validation ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Check for test layouts
TEST_DIR="$PDK_ROOT/ihp-sg13g2/libs.tech/klayout/tests"
if [ ! -d "$TEST_DIR" ]; then
    echo "[WARNING] No KLayout DRC test directory found at $TEST_DIR"
    echo "[INFO] Skipping automated DRC tests"
    exit 0
fi

# Find all test GDS files
echo "[INFO] Searching for DRC test cases..."
TEST_FILES=$(find "$TEST_DIR" -name "*.gds" -o -name "*.gds.gz" 2>/dev/null)

if [ -z "$TEST_FILES" ]; then
    echo "[WARNING] No GDS test files found"
    exit 0
fi

ERRORS=0
PASSED=0

for gds_file in $TEST_FILES; do
    echo "[INFO] Testing: $(basename "$gds_file")"

    # Run KLayout DRC
    if klayout -b -r "$PDK_ROOT/ihp-sg13g2/libs.tech/klayout/tech/drc/sg13g2_maximal.lydrc" \
               -rd input="$gds_file" \
               -rd report="/tmp/drc_$(basename "$gds_file").lyrdb" > /dev/null 2>&1; then
        echo "  [PASS] DRC completed"
        ((PASSED++))
    else
        echo "  [FAIL] DRC failed"
        ((ERRORS++))
    fi
done

echo ""
echo "=== DRC Validation Summary ==="
echo "Passed: $PASSED"
echo "Failed: $ERRORS"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] DRC validation failed"
    exit 1
else
    echo "[INFO] DRC validation passed"
    exit 0
fi
