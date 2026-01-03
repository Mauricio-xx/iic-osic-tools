# Contributing Testcases to IHP-EDA-Tools

This guide explains how to create and share testcases with the IHP-EDA-Tools community.

## Why Contribute?

Contributing testcases helps:
- **Share knowledge** - Help others learn IHP SG13G2 design
- **Validate the PDK** - Find and report issues
- **Build a library** - Create reusable design examples
- **Improve documentation** - Show practical usage patterns

## Quick Start

### Option 1: Create Locally

```bash
# Inside the container
iic-testcase init my-amplifier --template analog-simulation

# Edit files
cd my-amplifier
# Edit testcase.yaml, run.sh, add inputs

# Verify structure
iic-testcase verify .

# Test it works
iic-testcase run .
```

### Option 2: Use GitHub Template

1. Go to GitHub and create a new repository from the template:
   - Template: `ihp-eda-testcase-template` (or copy from `_templates/ihp-eda-testcase/`)

2. Clone and customize:
   ```bash
   git clone https://github.com/your-username/my-testcase
   cd my-testcase
   # Edit files
   ```

3. Test with Docker:
   ```bash
   make docker-run
   ```

## Testcase Requirements

### Required Files

| File | Purpose |
|------|---------|
| `testcase.yaml` | Metadata, requirements, validation rules |
| `run.sh` | Executable script that runs the testcase |
| `inputs/` | Directory with input files |

### Recommended Files

| File | Purpose |
|------|---------|
| `README.md` | Documentation for users |
| `expected/` | Expected outputs for validation |
| `Makefile` | Convenience targets |
| `LICENSE` | License file (Apache-2.0 recommended) |

## Writing testcase.yaml

### Minimal Example

```yaml
name: my-testcase
version: "1.0.0"
description: "What this testcase demonstrates"
category: contributed
type: simulation

requirements:
  pdk:
    name: ihp-sg13g2
  tools:
    - ngspice

execution:
  script: run.sh

inputs:
  - path: inputs/netlist.spice
    type: spice-netlist

tags:
  - my-tag
```

### Complete Example

```yaml
# SPDX-FileCopyrightText: 2025 Your Name
# SPDX-License-Identifier: Apache-2.0

name: miller-ota
version: "1.0.0"
description: "Two-stage Miller OTA with AC analysis"

category: contributed
type: simulation

author:
  name: "Your Name"
  email: "you@example.com"
  github: "your-username"

created: "2025-01-03"
updated: "2025-01-03"

requirements:
  pdk:
    name: ihp-sg13g2
    min_version: "dev"
  container:
    min_version: "2025.01"
  tools:
    - ngspice

execution:
  script: run.sh
  timeout: 300
  parallel: true

inputs:
  - path: inputs/miller_ota.spice
    type: spice-netlist
    description: "OTA netlist with testbench"

expected_outputs:
  - path: expected/ac_response.raw
    type: ngspice-rawfile
    description: "AC simulation results"
    comparison:
      method: pattern
      must_not_contain:
        - "Error"
        - "convergence"

tags:
  - ota
  - amplifier
  - ac-analysis
  - analog

related:
  - gold-reference/analog/nmos-iv-curve
```

## Writing run.sh

### Template

```bash
#!/bin/bash
# SPDX-FileCopyrightText: 2025 Your Name
# SPDX-License-Identifier: Apache-2.0

set -e  # Exit on error

# Standard setup - DO NOT MODIFY
TESTCASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$TESTCASE_DIR/output}"
mkdir -p "$OUTPUT_DIR"

# Source PDK environment
source sak-pdk-script.sh ihp-sg13g2 > /dev/null 2>&1 || true

echo "[INFO] Running testcase: $(basename "$TESTCASE_DIR")"

# ============================================================================
# YOUR IMPLEMENTATION HERE
# ============================================================================

# Example: ngspice simulation
ngspice -b "$TESTCASE_DIR/inputs/netlist.spice" \
    -r "$OUTPUT_DIR/output.raw" \
    -o "$OUTPUT_DIR/simulation.log"

# ============================================================================
# BASIC VALIDATION
# ============================================================================

# Check for errors
if grep -qi "error" "$OUTPUT_DIR/simulation.log"; then
    echo "[FAIL] Errors found in simulation"
    exit 1
fi

echo "[PASS] Testcase completed"
exit 0
```

### Best Practices

1. **Always use `set -e`** - Exit on first error
2. **Use environment variables** - `$TESTCASE_DIR`, `$OUTPUT_DIR`
3. **Source PDK script** - For proper environment setup
4. **Log output** - Write logs to `$OUTPUT_DIR`
5. **Check for errors** - Basic validation before exit

## Validation Methods

### Pattern Matching (Recommended for logs)

```yaml
expected_outputs:
  - path: expected/sim.log
    comparison:
      method: pattern
      must_contain:
        - "simulation complete"
      must_not_contain:
        - "Error"
        - "FATAL"
        - "convergence failed"
```

### File Existence

```yaml
expected_outputs:
  - path: expected/output.gds
    comparison:
      method: exists
```

### Checksum (For binary files)

```yaml
expected_outputs:
  - path: expected/output.raw
    comparison:
      method: checksum
      algorithm: md5
```

### Numerical (For data files)

```yaml
expected_outputs:
  - path: expected/results.csv
    comparison:
      method: numerical
      tolerance: 0.01
```

## Testing Your Testcase

### Local Testing

```bash
# Verify structure
iic-testcase verify .

# Run testcase
iic-testcase run .

# Full validation
iic-testcase validate .
```

### Docker Testing

```bash
# Using Makefile
make docker-run
make docker-validate

# Manual
docker run --rm \
  -v "$(pwd):/testcase:ro" \
  -v "$(pwd)/output:/output" \
  ghcr.io/iic-jku/iic-osic-tools:latest \
  bash -c "cd /testcase && ./run.sh"
```

### GitHub Actions

If using the template, CI runs automatically on push:
- Verifies structure
- Runs testcase in container
- Uploads output artifacts

## Sharing Your Testcase

### Option A: GitHub Repository

1. Create repository from template
2. Add your testcase files
3. Push to GitHub
4. Enable GitHub Actions
5. Share the repository URL

### Option B: Pull Request to iic-osic-tools

For high-quality testcases that could be gold-references:

1. Fork `iic-jku/iic-osic-tools`
2. Add testcase to `testcases/contributed/`
3. Update `testcases/manifest.yaml`
4. Submit pull request

### Testcase Quality Checklist

Before sharing, verify:

- [ ] `testcase.yaml` has all required fields
- [ ] `run.sh` is executable and works
- [ ] `README.md` documents usage
- [ ] Testcase passes `iic-testcase verify`
- [ ] Testcase runs successfully in fresh container
- [ ] No hardcoded paths (use `$TESTCASE_DIR`, `$OUTPUT_DIR`)
- [ ] Proper SPDX license headers
- [ ] Reasonable timeout value
- [ ] Meaningful tags for discovery

## Testcase Types Guide

### Analog Simulation

```yaml
type: simulation
requirements:
  tools:
    - ngspice  # or xyce
```

Common patterns:
- DC sweep
- AC analysis
- Transient simulation
- Monte Carlo
- Corner analysis

### DRC Check

```yaml
type: drc
requirements:
  tools:
    - klayout
```

Use `sak-drc.sh` wrapper:
```bash
sak-drc.sh -k "$TESTCASE_DIR/inputs/layout.gds" -w "$OUTPUT_DIR"
```

### LVS Check

```yaml
type: lvs
requirements:
  tools:
    - netgen
    - magic
```

Use `sak-lvs.sh` wrapper:
```bash
sak-lvs.sh -s "$TESTCASE_DIR/inputs/schematic.sch" \
           -l "$TESTCASE_DIR/inputs/layout.gds" \
           -w "$OUTPUT_DIR"
```

### RTL-to-GDS

```yaml
type: rtl2gds
requirements:
  pdk:
    name: ihp-sg13g2
    standard_cells: sg13g2_stdcell
  tools:
    - librelane
    - yosys
    - openroad
```

Use LibreLane:
```bash
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
librelane --manual-pdk "$TESTCASE_DIR/inputs/design.json"
```

## Getting Help

- **Issues**: https://github.com/iic-jku/iic-osic-tools/issues
- **Discussions**: Use GitHub Discussions
- **PDK Issues**: https://github.com/IHP-GmbH/IHP-Open-PDK/issues

## License

All contributed testcases should use Apache-2.0 license for compatibility.

```
SPDX-License-Identifier: Apache-2.0
```
