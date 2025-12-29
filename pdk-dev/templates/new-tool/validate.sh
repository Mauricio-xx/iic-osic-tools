#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Template: Validation script for new tool integration
# Copy and modify this script for your specific tool

set -e

TOOL_NAME="${1:-<tool-name>}"

echo "=== Validating $TOOL_NAME Integration with IHP SG13G2 ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Check if tool is installed
if ! command -v "$TOOL_NAME" &> /dev/null; then
    echo "[ERROR] $TOOL_NAME not found in PATH"
    exit 1
fi

# Check for tool-specific PDK files
TOOL_DIR="$PDK_ROOT/ihp-sg13g2/libs.tech/$TOOL_NAME"
if [ ! -d "$TOOL_DIR" ]; then
    echo "[ERROR] Tool integration directory not found: $TOOL_DIR"
    exit 1
fi

echo "[INFO] Found tool directory: $TOOL_DIR"

# Run basic tests
ERRORS=0
PASSED=0

# Test 1: Check configuration file exists
echo "[INFO] Test 1: Configuration file"
CONFIG_FILE="$TOOL_DIR/${TOOL_NAME}rc"
if [ -f "$CONFIG_FILE" ]; then
    echo "  [PASS] Configuration file found"
    ((PASSED++))
else
    echo "  [WARN] No configuration file at $CONFIG_FILE"
fi

# Test 2: Check for README/documentation
echo "[INFO] Test 2: Documentation"
if [ -f "$TOOL_DIR/README.md" ] || [ -f "$TOOL_DIR/README" ]; then
    echo "  [PASS] Documentation found"
    ((PASSED++))
else
    echo "  [WARN] No README found"
fi

# Test 3: Run tool-specific tests if available
echo "[INFO] Test 3: Integration tests"
TEST_DIR="$TOOL_DIR/tests"
if [ -d "$TEST_DIR" ]; then
    for test_script in "$TEST_DIR"/test*.sh; do
        if [ -f "$test_script" ]; then
            test_name=$(basename "$test_script")
            echo "  [INFO] Running: $test_name"
            if bash "$test_script" > /tmp/test_output.log 2>&1; then
                echo "    [PASS]"
                ((PASSED++))
            else
                echo "    [FAIL] See /tmp/test_output.log"
                ((ERRORS++))
            fi
        fi
    done
else
    echo "  [SKIP] No test directory found"
fi

echo ""
echo "=== Validation Summary ==="
echo "Tool: $TOOL_NAME"
echo "Passed: $PASSED"
echo "Failed: $ERRORS"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] Validation failed"
    exit 1
else
    echo "[INFO] Validation passed"
    exit 0
fi
