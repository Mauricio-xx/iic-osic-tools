#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Verify Netgen LVS environment for IHP SG13G2

import os
import sys

def main():
    pdk_root = os.environ.get('PDK_ROOT', '/foss/pdks')
    pdk = os.environ.get('PDK', 'ihp-sg13g2')

    print(f"[INFO] Checking LVS environment for {pdk}")
    print(f"[INFO] PDK_ROOT: {pdk_root}")

    errors = 0

    # Check netgen setup file exists
    setup_file = os.path.join(pdk_root, pdk, 'libs.tech', 'netgen', 'sg13g2_setup.tcl')
    if os.path.exists(setup_file):
        print(f"[PASS] Netgen setup file found: {setup_file}")
    else:
        # Try alternative naming
        setup_alt = os.path.join(pdk_root, pdk, 'libs.tech', 'netgen', 'setup.tcl')
        if os.path.exists(setup_alt):
            print(f"[PASS] Netgen setup file found: {setup_alt}")
        else:
            print(f"[FAIL] Netgen setup file not found: {setup_file}")
            errors += 1

    # Check Magic tech file exists
    magic_tech = os.path.join(pdk_root, pdk, 'libs.tech', 'magic', 'sg13g2.tech')
    if os.path.exists(magic_tech):
        print(f"[PASS] Magic tech file found: {magic_tech}")
    else:
        magic_tech_alt = os.path.join(pdk_root, pdk, 'libs.tech', 'magic', 'ihp-sg13g2.tech')
        if os.path.exists(magic_tech_alt):
            print(f"[PASS] Magic tech file found: {magic_tech_alt}")
        else:
            print(f"[WARN] Magic tech file not found at expected location")

    # Check netgen is available
    import shutil
    netgen_path = shutil.which('netgen')
    if netgen_path:
        print(f"[PASS] Netgen found: {netgen_path}")
    else:
        print(f"[FAIL] Netgen not found in PATH")
        errors += 1

    # Check magic is available
    magic_path = shutil.which('magic')
    if magic_path:
        print(f"[PASS] Magic found: {magic_path}")
    else:
        print(f"[FAIL] Magic not found in PATH")
        errors += 1

    # Check sak-lvs.sh wrapper
    sak_lvs = shutil.which('sak-lvs.sh')
    if sak_lvs:
        print(f"[PASS] sak-lvs.sh found: {sak_lvs}")
    else:
        print(f"[WARN] sak-lvs.sh not found in PATH")

    # Check xschem is available (for schematic extraction)
    xschem_path = shutil.which('xschem')
    if xschem_path:
        print(f"[PASS] xschem found: {xschem_path}")
    else:
        print(f"[WARN] xschem not found in PATH")

    # Summary
    print("")
    if errors == 0:
        print("[PASS] LVS environment validation completed successfully")
        return 0
    else:
        print(f"[FAIL] LVS environment validation failed with {errors} error(s)")
        return 1

if __name__ == '__main__':
    sys.exit(main())
