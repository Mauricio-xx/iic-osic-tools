# IHP-EDA-Tools Testcase Guide

This guide explains how to use the testcase infrastructure in IHP-EDA-Tools for running, validating, and creating reproducible circuit design examples.

## Overview

The testcase infrastructure provides:
- **Gold-reference examples** - Official examples for learning IHP SG13G2 design
- **Validation testcases** - PDK verification and tool integration tests
- **CLI tools** - `iic-testcase` for discovery, execution, and validation
- **Templates** - Easy creation of new testcases

## Quick Start

### Inside the Container

```bash
# List all available testcases
iic-testcase list

# Filter by category or type
iic-testcase list --category gold-reference
iic-testcase list --type simulation

# Get information about a testcase
iic-testcase info gold-reference/analog/nmos-iv-curve

# Run a testcase
iic-testcase run gold-reference/analog/nmos-iv-curve

# Run and validate outputs
iic-testcase validate gold-reference/analog/nmos-iv-curve
```

## CLI Reference

### `iic-testcase list`

List available testcases with optional filtering.

```bash
iic-testcase list [options]

Options:
  --category <cat>   Filter by category (gold-reference|validation|contributed)
  --type <type>      Filter by type (simulation|drc|lvs|pex|rtl2gds)
  --tag <tag>        Filter by tag
```

### `iic-testcase info`

Show detailed information about a testcase.

```bash
iic-testcase info <testcase-id>
```

### `iic-testcase run`

Execute a testcase.

```bash
iic-testcase run <testcase-id> [options]

Options:
  --output <dir>     Output directory (default: testcase/output)
  --no-compare       Skip comparison with expected outputs
```

### `iic-testcase validate`

Run a testcase and validate outputs against expected results.

```bash
iic-testcase validate <testcase-id> [--output <dir>]
```

### `iic-testcase init`

Create a new testcase from a template.

```bash
iic-testcase init <name> [options]

Options:
  --template <type>  Template type (analog-simulation|digital-rtl2gds|drc-test)
```

### `iic-testcase verify`

Verify testcase structure and metadata.

```bash
iic-testcase verify <path>
```

### `iic-testcase export`

Export a testcase to a standalone directory.

```bash
iic-testcase export <testcase-id> <output-dir>
```

## Comparison Utility

The `iic-testcase-compare` utility provides output validation methods:

### Check File Exists

```bash
iic-testcase-compare exists output.gds --min-size 1000
```

### Compare Checksums

```bash
iic-testcase-compare checksum output.raw expected.raw --algorithm md5
```

### Pattern Matching

```bash
iic-testcase-compare pattern simulation.log \
    --must-contain "success" \
    --must-not-contain "error" \
    --ignore-case
```

### Numerical Comparison

```bash
iic-testcase-compare numerical results.csv expected.csv \
    --tolerance 0.01 \
    --column 2
```

## Testcase Structure

Every testcase follows this structure:

```
my-testcase/
├── testcase.yaml      # Required: Metadata and configuration
├── run.sh             # Required: Execution script
├── inputs/            # Required: Input files
│   └── netlist.spice
├── expected/          # Optional: Expected outputs for validation
│   └── output.raw
└── README.md          # Recommended: Documentation
```

### testcase.yaml

```yaml
name: my-testcase
version: "1.0.0"
description: "Brief description"

category: contributed    # gold-reference | validation | contributed
type: simulation        # simulation | drc | lvs | pex | rtl2gds

requirements:
  pdk:
    name: ihp-sg13g2
  tools:
    - ngspice

execution:
  script: run.sh
  timeout: 300

inputs:
  - path: inputs/netlist.spice
    type: spice-netlist

expected_outputs:
  - path: expected/output.raw
    type: ngspice-rawfile
    comparison:
      method: pattern
      must_not_contain:
        - "Error"

tags:
  - keyword
```

### run.sh

```bash
#!/bin/bash
set -e

TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

# Run your simulation/flow
ngspice -b "$TESTCASE_DIR/inputs/netlist.spice" -o "$OUTPUT_DIR/sim.log"

exit 0
```

## Categories

| Category | Description | Location |
|----------|-------------|----------|
| `gold-reference` | Official examples by IHP-EDA-Tools team | `/foss/testcases/gold-reference/` |
| `validation` | PDK verification tests | `/foss/testcases/validation/` |
| `contributed` | Community contributions | `/foss/designs/testcases/` |

## Types

| Type | Description | Tools |
|------|-------------|-------|
| `simulation` | SPICE/Verilog-A simulation | ngspice, xyce |
| `drc` | Design Rule Check | klayout, magic |
| `lvs` | Layout vs Schematic | netgen, klayout |
| `pex` | Parasitic Extraction | magic |
| `rtl2gds` | RTL-to-GDS flow | librelane, yosys, openroad |
| `rf` | RF/EM simulation | openems, qucs-s |

## Available Gold-Reference Testcases

### Analog
- `gold-reference/analog/nmos-iv-curve` - NMOS DC IV characterization

### Digital
- `gold-reference/digital/counter-rtl2gds` - RTL-to-GDS with LibreLane

### Validation
- `validation/drc/klayout-invocation` - KLayout DRC environment check
- `validation/lvs/netgen-invocation` - Netgen LVS environment check

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TESTCASE_ROOT` | `/foss/testcases` | System testcase directory |
| `USER_TESTCASE_ROOT` | `/foss/designs/testcases` | User testcase directory |
| `TESTCASE_DIR` | Set by CLI | Current testcase directory |
| `OUTPUT_DIR` | `$TESTCASE_DIR/output` | Output directory |

## Troubleshooting

### Testcase not found

Ensure the testcase ID matches the directory structure:
```bash
# Correct
iic-testcase run gold-reference/analog/nmos-iv-curve

# Wrong - missing category
iic-testcase run nmos-iv-curve
```

### PDK not configured

Make sure to source the PDK script in run.sh:
```bash
source sak-pdk-script.sh ihp-sg13g2
```

### Permission denied

Make sure run.sh is executable:
```bash
chmod +x run.sh
```

## See Also

- [TESTCASE-CONTRIBUTING.md](TESTCASE-CONTRIBUTING.md) - How to contribute testcases
- [testcases/README.md](../testcases/README.md) - Testcase directory overview
