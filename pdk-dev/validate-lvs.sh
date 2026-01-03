#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Validate LVS setup for IHP SG13G2 PDK
# Runs LVS test cases to ensure setup cells are correct

set -e

echo "=== IHP SG13G2 LVS Validation ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Check for netgen setup
NETGEN_SETUP="$PDK_ROOT/ihp-sg13g2/libs.tech/netgen/sg13g2_setup.tcl"
if [ ! -f "$NETGEN_SETUP" ]; then
    echo "[ERROR] Netgen setup file not found: $NETGEN_SETUP"
    exit 1
fi

echo "[INFO] Netgen setup file found: $NETGEN_SETUP"

# Check for LVS test cases
TEST_DIR="$PDK_ROOT/ihp-sg13g2/libs.tech/netgen/tests"
if [ ! -d "$TEST_DIR" ]; then
    echo "[WARNING] No netgen test directory found at $TEST_DIR"
    echo "[INFO] Running basic netgen setup validation..."

    # Basic validation - just check that netgen can read the setup file
    if netgen -batch source "$NETGEN_SETUP" quit > /dev/null 2>&1; then
        echo "[PASS] Netgen setup file is valid"
        exit 0
    else
        echo "[FAIL] Netgen cannot parse setup file"
        exit 1
    fi
fi

# Run LVS test cases if available
echo "[INFO] Running LVS test cases..."
ERRORS=0
PASSED=0

for test_dir in "$TEST_DIR"/*/; do
    if [ -d "$test_dir" ]; then
        test_name=$(basename "$test_dir")
        echo "[INFO] Running LVS test: $test_name"

        layout_spice="$test_dir/layout.spice"
        schematic_spice="$test_dir/schematic.spice"

        if [ -f "$layout_spice" ] && [ -f "$schematic_spice" ]; then
            if netgen -batch lvs "$layout_spice" "$schematic_spice" \
                      "$NETGEN_SETUP" "/tmp/lvs_${test_name}.log" > /dev/null 2>&1; then
                echo "  [PASS] LVS matched"
                ((PASSED++))
            else
                echo "  [FAIL] LVS mismatch"
                ((ERRORS++))
            fi
        else
            echo "  [SKIP] Missing test files"
        fi
    fi
done

echo ""
echo "=== LVS Validation Summary ==="
echo "Passed: $PASSED"
echo "Failed: $ERRORS"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] LVS validation failed"
    exit 1
else
    echo "[INFO] LVS validation passed"
    exit 0
fi
