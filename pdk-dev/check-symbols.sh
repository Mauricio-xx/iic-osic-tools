#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Validate xschem symbols for IHP SG13G2 PDK
# Checks for consistency and required attributes

set -e

echo "=== IHP SG13G2 Symbol Validation ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Find xschem library directory
XSCHEM_LIB="$PDK_ROOT/ihp-sg13g2/libs.tech/xschem"
if [ ! -d "$XSCHEM_LIB" ]; then
    echo "[ERROR] xschem library not found at $XSCHEM_LIB"
    exit 1
fi

echo "[INFO] Checking symbols in: $XSCHEM_LIB"

# Find all symbol files
SYM_FILES=$(find "$XSCHEM_LIB" -name "*.sym" 2>/dev/null)

if [ -z "$SYM_FILES" ]; then
    echo "[WARNING] No symbol files found"
    exit 0
fi

ERRORS=0
WARNINGS=0
TOTAL=0

for sym_file in $SYM_FILES; do
    ((TOTAL++))
    basename=$(basename "$sym_file")

    # Check for required attributes
    has_type=false
    has_format=false
    has_template=false

    if grep -q "^T.*type=" "$sym_file" 2>/dev/null; then
        has_type=true
    fi

    if grep -q "^T.*format=" "$sym_file" 2>/dev/null; then
        has_format=true
    fi

    if grep -q "^T.*template=" "$sym_file" 2>/dev/null; then
        has_template=true
    fi

    # Report issues
    if ! $has_type; then
        echo "[WARNING] $basename: missing 'type' attribute"
        ((WARNINGS++))
    fi

    if ! $has_format && ! $has_template; then
        # Only warn if it's not a hierarchical symbol
        if ! grep -q "type=subcircuit" "$sym_file" 2>/dev/null; then
            echo "[WARNING] $basename: missing 'format' or 'template' attribute"
            ((WARNINGS++))
        fi
    fi

    # Check for valid pin definitions
    pin_count=$(grep -c "^B 5" "$sym_file" 2>/dev/null || echo 0)
    if [ "$pin_count" -eq 0 ]; then
        echo "[WARNING] $basename: no pins defined"
        ((WARNINGS++))
    fi
done

# Check for corresponding .sch files
echo ""
echo "[INFO] Checking schematic/symbol pairs..."
SCH_FILES=$(find "$XSCHEM_LIB" -name "*.sch" 2>/dev/null)

for sch_file in $SCH_FILES; do
    basename=$(basename "$sch_file" .sch)
    sym_file="${sch_file%.sch}.sym"

    if [ ! -f "$sym_file" ]; then
        echo "[INFO] Schematic without symbol: $basename.sch"
    fi
done

echo ""
echo "=== Symbol Validation Summary ==="
echo "Total symbols: $TOTAL"
echo "Warnings: $WARNINGS"
echo "Errors: $ERRORS"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] Symbol validation failed"
    exit 1
else
    if [ $WARNINGS -gt 0 ]; then
        echo "[WARNING] Symbol validation passed with warnings"
    else
        echo "[INFO] Symbol validation passed"
    fi
    exit 0
fi
