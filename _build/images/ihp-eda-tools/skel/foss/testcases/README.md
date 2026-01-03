# IHP-EDA-Tools Testcases

Standardized testcase infrastructure for sharing reproducible examples between circuit designers and PDK developers.

## Structure

```
testcases/
├── manifest.yaml           # Master index of all testcases
├── gold-reference/         # Official examples by IHP-EDA-Tools team
│   ├── analog/
│   │   └── nmos-iv-curve/  # NMOS DC characterization
│   └── digital/
│       └── counter-rtl2gds/ # RTL-to-GDS flow example
├── validation/             # PDK verification tests
└── contributed/            # Community-contributed testcases
```

## Using Testcases

### List Available Testcases

```bash
iic-testcase list
iic-testcase list --category gold-reference
iic-testcase list --type simulation
```

### Get Testcase Information

```bash
iic-testcase info gold-reference/analog/nmos-iv-curve
```

### Run a Testcase

```bash
# Run with default output directory
iic-testcase run gold-reference/analog/nmos-iv-curve

# Run with custom output
iic-testcase run gold-reference/analog/nmos-iv-curve --output ~/results
```

### Create New Testcase

```bash
iic-testcase init my-amplifier --template analog-simulation
```

### Verify Testcase Structure

```bash
iic-testcase verify ./my-testcase
```

## Testcase Format

Each testcase contains:

| File | Required | Description |
|------|----------|-------------|
| `testcase.yaml` | Yes | Metadata and configuration |
| `run.sh` | Yes | Execution script |
| `inputs/` | Yes | Input files (netlists, RTL, etc.) |
| `expected/` | No | Expected outputs for validation |
| `README.md` | Recommended | Documentation |

### testcase.yaml Structure

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

tags:
  - keyword1
  - keyword2
```

## Categories

| Category | Description |
|----------|-------------|
| `gold-reference` | Official examples maintained by IHP-EDA-Tools team |
| `validation` | PDK verification and tool integration tests |
| `contributed` | Community-contributed examples |

## Types

| Type | Description |
|------|-------------|
| `simulation` | SPICE/Verilog-A simulation |
| `drc` | Design Rule Check |
| `lvs` | Layout vs Schematic |
| `pex` | Parasitic Extraction |
| `rtl2gds` | Complete digital flow |
| `rf` | RF/EM simulation |

## Contributing Testcases

1. Create testcase using `iic-testcase init`
2. Add input files and implement `run.sh`
3. Document in README.md
4. Verify with `iic-testcase verify`
5. Submit via GitHub pull request

## License

SPDX-License-Identifier: Apache-2.0
