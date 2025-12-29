#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Run simulation test suite for IHP SG13G2 PDK
# Tests both ngspice and Xyce simulators

set -e

echo "=== IHP SG13G2 Simulation Tests ==="
echo ""

# Check if PDK is available
if [ ! -d "$PDK_ROOT/ihp-sg13g2" ]; then
    echo "[ERROR] IHP SG13G2 PDK not found at $PDK_ROOT/ihp-sg13g2"
    exit 1
fi

# Set PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

WORKDIR="${WORKDIR:-/tmp/pdk_sim_test}"
mkdir -p "$WORKDIR"

ERRORS=0
PASSED=0

# Test 1: Basic NMOS simulation with ngspice
echo "[INFO] Test 1: ngspice NMOS DC sweep"
cat > "$WORKDIR/test_nmos.spice" << 'EOF'
* IHP SG13G2 NMOS Test
.lib cornerMOSlv.lib mos_tt
.include psp103_nmos.spi

.param vdd=1.2
vds drain 0 dc 'vdd'
vgs gate 0 dc 0.6
vs source 0 dc 0
vb bulk 0 dc 0

xmn drain gate source bulk sg13_lv_nmos w=1u l=0.13u ng=1

.control
dc vds 0 1.2 0.01 vgs 0.4 1.2 0.2
wrdata $WORKDIR/nmos_iv.dat i(vds)
.endc
.end
EOF

cd "$PDK_ROOT/ihp-sg13g2/libs.tech/ngspice/models" 2>/dev/null || cd "$PDK_ROOT/ihp-sg13g2"
if ngspice -b "$WORKDIR/test_nmos.spice" > "$WORKDIR/nmos.log" 2>&1; then
    echo "  [PASS] ngspice NMOS simulation"
    ((PASSED++))
else
    echo "  [FAIL] ngspice NMOS simulation"
    ((ERRORS++))
fi

# Test 2: Basic PMOS simulation with ngspice
echo "[INFO] Test 2: ngspice PMOS DC sweep"
cat > "$WORKDIR/test_pmos.spice" << 'EOF'
* IHP SG13G2 PMOS Test
.lib cornerMOSlv.lib mos_tt
.include psp103_pmos.spi

.param vdd=1.2
vds drain 0 dc '-vdd'
vgs gate 0 dc -0.6
vs source 0 dc 0
vb bulk 0 dc 0

xmp drain gate source bulk sg13_lv_pmos w=1u l=0.13u ng=1

.control
dc vds 0 -1.2 -0.01 vgs -0.4 -1.2 -0.2
wrdata $WORKDIR/pmos_iv.dat i(vds)
.endc
.end
EOF

if ngspice -b "$WORKDIR/test_pmos.spice" > "$WORKDIR/pmos.log" 2>&1; then
    echo "  [PASS] ngspice PMOS simulation"
    ((PASSED++))
else
    echo "  [FAIL] ngspice PMOS simulation"
    ((ERRORS++))
fi

# Test 3: Xyce simulation (if available)
if command -v xyce &> /dev/null; then
    echo "[INFO] Test 3: Xyce NMOS simulation"

    XYCE_PLUGIN="$PDK_ROOT/ihp-sg13g2/libs.tech/xyce/plugins/Xyce_Plugin_PSP103_VA.so"
    if [ -f "$XYCE_PLUGIN" ]; then
        cat > "$WORKDIR/test_xyce_nmos.spice" << EOF
* IHP SG13G2 NMOS Test for Xyce
.lib '$PDK_ROOT/ihp-sg13g2/libs.tech/xyce/models/cornerMOSlv.lib' mos_tt

vds drain 0 dc 1.2
vgs gate 0 dc 0.6
vs source 0 dc 0
vb bulk 0 dc 0

xmn drain gate source bulk sg13_lv_nmos w=1u l=0.13u ng=1

.dc vds 0 1.2 0.01 vgs 0.4 1.2 0.2
.print dc i(vds)
.end
EOF

        if xyce -plugin "$XYCE_PLUGIN" "$WORKDIR/test_xyce_nmos.spice" > "$WORKDIR/xyce.log" 2>&1; then
            echo "  [PASS] Xyce NMOS simulation"
            ((PASSED++))
        else
            echo "  [FAIL] Xyce NMOS simulation"
            ((ERRORS++))
        fi
    else
        echo "  [SKIP] Xyce plugin not found"
    fi
else
    echo "[INFO] Test 3: Xyce not available, skipping"
fi

echo ""
echo "=== Simulation Test Summary ==="
echo "Passed: $PASSED"
echo "Failed: $ERRORS"
echo "Work directory: $WORKDIR"

if [ $ERRORS -gt 0 ]; then
    echo "[ERROR] Some simulation tests failed"
    exit 1
else
    echo "[INFO] All simulation tests passed"
    exit 0
fi
