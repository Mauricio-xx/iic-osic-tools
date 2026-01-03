# Netgen LVS Invocation Validation

## Description

This validation testcase verifies that the Netgen LVS environment is correctly configured for the IHP SG13G2 PDK. It checks:

- Netgen setup file (`sg13g2_setup.tcl`) exists
- Magic tech file is present
- Netgen executable is available in PATH
- Magic executable is available in PATH
- `sak-lvs.sh` wrapper is accessible
- xschem is available for schematic extraction

## Purpose

This is a **validation testcase** meant to verify PDK tool integration, not a design example. It helps ensure the container's LVS tools are properly set up before running actual LVS checks.

## Usage

```bash
iic-testcase run validation/lvs/netgen-invocation
```

## Expected Output

The testcase passes if all LVS environment checks succeed:
- Netgen setup file found
- Magic tech file found
- Netgen executable found
- Magic executable found

## License

SPDX-License-Identifier: Apache-2.0
