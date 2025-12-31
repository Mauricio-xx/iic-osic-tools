# CLAUDE.md - AI Assistant Guide for IHP-EDA-TOOLS

## Project Overview

**IHP-EDA-TOOLS** is an IHP-focused Docker/Podman container providing open-source EDA (Electronic Design Automation) tools for integrated circuit (IC) design with the IHP SG13G2 PDK. It supports both analog and digital circuit design flows.

This is a specialized fork of [IHP-EDA-Tools](https://github.com/iic-jku/ihp-eda-tools), focused exclusively on the IHP SG13G2 130nm SiGe:C BiCMOS process.

- **Original Project**: IHP-EDA-Tools by Johannes Kepler University (JKU)
- **This Fork**: IHP-focused container by Mauricio-xx
- **License**: Apache-2.0
- **Architectures**: `x86_64/amd64` and `aarch64/arm64` (native support)
- **Base OS**: Ubuntu 24.04 LTS

## Key Differences from Upstream

| Aspect | IHP-EDA-Tools | IHP-EDA-TOOLS |
|--------|----------------|---------------|
| PDKs | sky130, gf180mcu, ihp-sg13g2 | IHP SG13G2 only |
| RISC-V | Full toolchain | Removed |
| FPGA | nextpnr (iCE40) | Removed |
| Tools | ~70 tools | ~50 tools |
| Image size | ~20 GB | ~13-14 GB |
| Focus | General-purpose | IHP-specific |

## Repository Structure

```
ihp-eda-tools/
├── _build/                    # Docker build infrastructure
│   ├── images/                # Individual tool Dockerfiles (~35 tools)
│   │   ├── base/              # Base image with system dependencies
│   │   ├── base-dev/          # Development base with *-dev packages
│   │   ├── open_pdks/         # IHP PDK installation only
│   │   ├── ihp-eda-tools/    # Final combined image
│   │   │   ├── Dockerfile     # Multi-stage final image build
│   │   │   └── skel/          # Skeleton files copied into image
│   │   └── <tool>/            # Each tool has its own directory
│   ├── docker-bake.hcl        # Docker Bake configuration
│   ├── tool_metadata.yml      # Tool versions (commits/tags)
│   └── build-*.sh             # Build scripts
├── _tests/                    # Regression test suite (7 tests)
│   ├── 01-07/                 # IHP-focused tests only
│   ├── TESTS.md               # Test descriptions
│   └── run_docker_tests.sh    # Test runner script
├── pdk-dev/                   # PDK development tools
│   ├── validate-drc.sh        # DRC rule validation
│   ├── validate-lvs.sh        # LVS setup validation
│   ├── compile-models.sh      # Verilog-A to OSDI compilation
│   ├── test-simulation.sh     # Simulation test suite
│   ├── check-symbols.sh       # xschem symbol validation
│   └── templates/             # Templates for new tool integration
├── start_*.sh                 # Container start scripts
├── start_pdk_dev.sh           # PDK development mode launcher
├── PLAN_IHP_CONTAINER.md      # Implementation plan document
└── CLAUDE.md                  # This file
```

## Process Development Kit (PDK)

**Only IHP SG13G2 is installed** - a 130nm SiGe:C BiCMOS process from IHP Microelectronics.

The PDK is installed from the `dev` branch with recursive submodules:
- Source: https://github.com/iic-jku/IHP-Open-PDK
- Branch: `dev`

Key PDK features:
- PSP OSDI models for ngspice
- PSP Verilog-A plugins for Xyce
- KLayout DRC/LVS rule decks
- xschem symbols and schematics
- Magic tech files with custom bindkeys
- Netgen LVS setup cells
- OpenROAD/LibreLane support

## Tool Categories

### Included Tools (~50)

#### Schematic and Layout
- `xschem` - Schematic editor with IHP symbols
- `klayout` - Layout editor with DRC/LVS
- `magic` - Layout with DRC/PEX
- `gds3d` - 3D GDS viewer
- `xcircuit` - Alternative schematic editor

#### Analog Simulation
- `ngspice` - SPICE with OSDI (PSP models)
- `xyce` - Parallel SPICE with Verilog-A plugins
- `gaw3-xschem` - Waveform viewer for xschem
- `vacask` - Modern analog simulator
- `ngspyce` - Python bindings for ngspice

#### Digital Flow (RTL-to-GDS)
- `yosys` - Logic synthesis + plugins (ghdl, slang)
- `openroad` - Place & Route engine
- `librelane` - Complete RTL-to-GDS flow
- `eqy`, `sby`, `mcy` - Formal verification

#### Digital Simulation
- `digital` - Logic designer and circuit simulator (educational)
- `iverilog` - Verilog simulator
- `verilator` - Fast Verilog simulator
- `ghdl` - VHDL simulator
- `nvc` - Modern VHDL simulator
- `gtkwave` - Digital waveform viewer
- `surfer` - Modern waveform viewer
- `cocotb` - Python testbench

#### Verification
- `netgen` - LVS
- `cvc` - ERC (circuit validity checker)
- `covered` - Verilog code coverage

#### RF/EM
- `openems` - FDTD EM simulator
- `palace` - 3D EM simulator (AWS)
- `qucs-s` - RF simulation environment
- `rftoolkit` - FastHenry2, FasterCap

#### PDK Development
- `openvaf` - Verilog-A to OSDI compiler
- `charlib` - Standard cell characterization
- `cace` - Circuit characterization engine
- `ciel` - PDK version manager

### Removed Tools (Not in IHP Image)

- **PDKs**: sky130A, gf180mcuD
- **RISC-V**: riscv-gnu-toolchain, spike, pulp-tools
- **FPGA**: nextpnr, fpga-tools
- **Others**: kactus2, libman, padring, pyopus, veryl, chisel

## Container Operation Modes

1. **VNC mode** (`start_vnc.sh`): Full XFCE desktop via browser
2. **X11 mode** (`start_x.sh`): Native window display
3. **Shell mode** (`start_shell.sh`): Direct CLI access
4. **PDK Dev mode** (`start_pdk_dev.sh`): Mount local PDK for development

## PDK Development Mode

For PDK developers and contributors:

```bash
# Mount your local PDK fork for editing
./start_pdk_dev.sh --pdk-source ~/IHP-Open-PDK

# Inside container - run validation scripts
/foss/pdk-dev/validate-drc.sh
/foss/pdk-dev/validate-lvs.sh
/foss/pdk-dev/compile-models.sh
/foss/pdk-dev/test-simulation.sh
/foss/pdk-dev/check-symbols.sh
```

This allows:
- Editing PDK files on host
- Immediately testing changes in container
- Running validation scripts
- Sharing test cases between designers and PDK developers

## Testing

### Running Tests

```bash
cd _tests
./run_docker_tests.sh hpretl/ihp-eda-tools:latest
```

### Test Suite (7 tests)

| Test | Description |
|------|-------------|
| 01 | Python packages import |
| 02 | ngspice with ihp-sg13g2 |
| 03 | OpenROAD flow scripts with ihp-sg13g2 |
| 04 | Xyce with ihp-sg13g2 |
| 05 | iVerilog functionality |
| 06 | VACASK analog simulator |
| 07 | LibreLane with ihp-sg13g2 |

## Building the Container

```bash
cd _build

# Step 1: Create builders (one-time)
./builder-create.sh

# Step 2: Build base images
./build-base.sh
./build-base-dev.sh

# Step 3: Build tools
./build-tools.sh

# Step 4: Build final image
./build-images.sh
```

## Environment Variables

- `TOOLS=/foss/tools` - Tool installation directory
- `PDK_ROOT=/foss/pdks` - PDK installation directory
- `DESIGNS=/foss/designs` - User design directory (mounted volume)
- `PDK=ihp-sg13g2` - Active PDK (always IHP)
- `PDKPATH=$PDK_ROOT/ihp-sg13g2` - PDK path

## Important Files

| File | Purpose |
|------|---------|
| `_build/tool_metadata.yml` | Tool version pins |
| `_build/docker-bake.hcl` | Docker Bake configuration |
| `_build/images/ihp-eda-tools/Dockerfile` | Final image assembly |
| `_build/images/open_pdks/scripts/install_ihp.sh` | IHP PDK installation |
| `pdk-dev/` | PDK development scripts |
| `start_pdk_dev.sh` | PDK development mode launcher |
| `PLAN_IHP_CONTAINER.md` | Implementation plan |

## Quick Reference

| Command | Description |
|---------|-------------|
| `xschem` | Schematic editor |
| `klayout` | Layout editor |
| `magic` | Layout with DRC/PEX |
| `ngspice` | SPICE simulator |
| `xyce` | Parallel SPICE |
| `librelane` | RTL-to-GDS flow |
| `openroad` | Place & Route |
| `sak-drc.sh` | Run DRC checks |
| `sak-lvs.sh` | Run LVS checks |
| `sak-pex.sh` | Run parasitic extraction |

## Contributing

This is a fork maintained separately from upstream IHP-EDA-Tools.

- **No pull requests to upstream** - This fork has diverged intentionally
- For PDK issues: https://github.com/IHP-GmbH/IHP-Open-PDK
- For container issues: Use this repository's issue tracker

## Development Workflow

### Adding Tool Support for IHP

1. Review `pdk-dev/templates/new-tool/README.md`
2. Create tool integration in PDK under `libs.tech/<tool>/`
3. Add test cases to `pdk-dev/integration-tests/`
4. Run validation scripts

### Updating PDK Version

The PDK is installed from branch `dev`. To update:

1. Edit `_build/images/open_pdks/scripts/install_ihp.sh`
2. Change branch or commit reference
3. Rebuild image

## Code Conventions

### Shell Scripts
- SPDX license headers required
- Use `set -e` for error handling
- Support IHP SG13G2 PDK only

### Dockerfiles
- Use multi-stage builds
- Install to `/foss/tools/<tool-name>/`
- No sky130/gf180 references
