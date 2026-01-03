#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Verify KLayout DRC environment for IHP SG13G2

import os
import sys

def main():
    pdk_root = os.environ.get('PDK_ROOT', '/foss/pdks')
    pdk = os.environ.get('PDK', 'ihp-sg13g2')

    print(f"[INFO] Checking DRC environment for {pdk}")
    print(f"[INFO] PDK_ROOT: {pdk_root}")

    errors = 0

    # Check run_drc.py exists
    drc_script = os.path.join(pdk_root, pdk, 'libs.tech', 'klayout', 'tech', 'drc', 'run_drc.py')
    if os.path.exists(drc_script):
        print(f"[PASS] DRC script found: {drc_script}")
    else:
        print(f"[FAIL] DRC script not found: {drc_script}")
        errors += 1

    # Check main rule deck exists
    rule_deck = os.path.join(pdk_root, pdk, 'libs.tech', 'klayout', 'tech', 'drc', 'sg13g2_full.lydrc')
    if os.path.exists(rule_deck):
        print(f"[PASS] Rule deck found: {rule_deck}")
    else:
        # Try alternative location
        rule_deck_alt = os.path.join(pdk_root, pdk, 'libs.tech', 'klayout', 'tech', 'drc', 'sg13g2.lydrc')
        if os.path.exists(rule_deck_alt):
            print(f"[PASS] Rule deck found: {rule_deck_alt}")
        else:
            print(f"[WARN] Rule deck not found at expected location")

    # Check KLayout is available
    import shutil
    klayout_path = shutil.which('klayout')
    if klayout_path:
        print(f"[PASS] KLayout found: {klayout_path}")
    else:
        print(f"[FAIL] KLayout not found in PATH")
        errors += 1

    # Check sak-drc.sh wrapper
    sak_drc = shutil.which('sak-drc.sh')
    if sak_drc:
        print(f"[PASS] sak-drc.sh found: {sak_drc}")
    else:
        print(f"[WARN] sak-drc.sh not found in PATH")

    # Summary
    print("")
    if errors == 0:
        print("[PASS] DRC environment validation completed successfully")
        return 0
    else:
        print(f"[FAIL] DRC environment validation failed with {errors} error(s)")
        return 1

if __name__ == '__main__':
    sys.exit(main())
