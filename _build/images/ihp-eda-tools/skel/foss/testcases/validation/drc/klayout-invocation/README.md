# KLayout DRC Invocation Validation

## Description

This validation testcase verifies that the KLayout DRC environment is correctly configured for the IHP SG13G2 PDK. It checks:

- DRC script (`run_drc.py`) exists
- Rule deck files are present
- KLayout is available in PATH
- `sak-drc.sh` wrapper is accessible

## Purpose

This is a **validation testcase** meant to verify PDK tool integration, not a design example. It helps ensure the container's DRC tools are properly set up before running actual DRC checks.

## Usage

```bash
iic-testcase run validation/drc/klayout-invocation
```

## Expected Output

The testcase passes if all DRC environment checks succeed:
- DRC script found
- Rule deck found
- KLayout executable found

## License

SPDX-License-Identifier: Apache-2.0
