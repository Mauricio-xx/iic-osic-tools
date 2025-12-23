# CLAUDE.md - AI Assistant Guide for IIC-OSIC-TOOLS

## Project Overview

**IIC-OSIC-TOOLS** (Integrated Infrastructure for Collaborative Open Source IC Tools) is an all-in-one Docker/Podman container providing open-source EDA (Electronic Design Automation) tools for integrated circuit (IC) design. It supports both analog and digital circuit design flows.

- **Maintainer**: Department for Integrated Circuits (ICD), Johannes Kepler University (JKU)
- **License**: Apache-2.0
- **Architectures**: `x86_64/amd64` and `aarch64/arm64` (native support)
- **Base OS**: Ubuntu 24.04 LTS (since release 2025.01)
- **DOI**: 10.5281/zenodo.14387234

## Repository Structure

```
iic-osic-tools/
├── _build/                    # Docker build infrastructure
│   ├── images/                # Individual tool Dockerfiles (50+ tools)
│   │   ├── base/              # Base image with system dependencies
│   │   ├── base-dev/          # Development base with *-dev packages
│   │   ├── iic-osic-tools/    # Final combined image
│   │   │   ├── Dockerfile     # Multi-stage final image build
│   │   │   └── skel/          # Skeleton files copied into image
│   │   └── <tool>/            # Each tool has its own directory
│   │       ├── Dockerfile
│   │       └── scripts/install.sh
│   ├── tools/                 # Build helper tools
│   ├── docker-bake.hcl        # Docker Bake configuration
│   ├── tool_metadata.yml      # Tool versions (commits/tags)
│   ├── build-all.sh           # Complete build script
│   ├── build-base.sh          # Build base image
│   ├── build-tools.sh         # Build individual tools
│   ├── build-images.sh        # Build final image
│   ├── builder-create.sh      # Create buildx builders
│   └── README.md              # Build documentation
├── _tests/                    # Regression test suite
│   ├── 01-18/                 # Numbered test directories
│   ├── TESTS.md               # Test descriptions
│   └── run_docker_tests.sh    # Test runner script
├── .github/
│   ├── ISSUE_TEMPLATE/        # Bug report and feature request templates
│   └── workflows/             # CI/CD for devcontainer builds
├── start_*.sh                 # Container start scripts (Linux/macOS)
├── start_*.bat                # Container start scripts (Windows)
├── eda_server_*.sh            # Multi-instance server management
├── README.md                  # Main documentation
├── RELEASE_NOTES.md           # Version changelog
├── KNOWN_ISSUES.md            # Known problems and workarounds
└── CITATION.cff               # Citation information
```

## Key Concepts

### Process Development Kits (PDKs)

Three PDKs are pre-installed:
- **sky130A**: SkyWater Technologies 130nm CMOS
- **gf180mcuD**: GlobalFoundries 180nm CMOS
- **ihp-sg13g2**: IHP Microelectronics 130nm SiGe:C BiCMOS (default since 2025.05)

Switch PDKs using the `sak-pdk` command:
```bash
sak-pdk ihp-sg13g2   # Switch to IHP PDK
sak-pdk sky130A      # Switch to SkyWater PDK
```

### Container Operation Modes

1. **VNC mode** (`start_vnc.sh`): Full XFCE desktop via browser/VNC client
2. **X11 mode** (`start_x.sh`): Native window display using local X server
3. **Jupyter mode** (`start_jupyter.sh`): Jupyter notebook interface
4. **Shell mode** (`start_shell.sh`): Direct CLI access
5. **Devcontainer**: VS Code integration

### Tool Categories

The container includes 70+ tools organized by function:
- **Schematic/Layout**: xschem, klayout, magic, xcircuit
- **Simulation**: ngspice, xyce, iverilog, verilator, ghdl, nvc
- **Synthesis**: yosys (with GHDL and Slang plugins)
- **Place & Route**: openroad, librelane (formerly OpenLane)
- **Verification**: netgen (LVS), cvc (ERC), cocotb, fault
- **RF/EM**: openems, palace, qucs-s, rftoolkit
- **RISC-V**: riscv-gnu-toolchain, spike, pulp-tools

## Development Workflow

### Building the Container

**Prerequisites**: Docker with buildx, SSH access to build machines for multi-arch builds.

```bash
# Step 1: Create builders (one-time setup)
cd _build
./builder-create.sh

# Step 2: Build base image
./build-base.sh

# Step 3: Build all tools (can take hours)
./build-tools.sh

# Step 4: Build and push final image
DOCKER_PREFIXES="hpretl,registry.iic.jku.at:5000" DOCKER_TAGS="latest" ./build-images.sh
```

### Adding a New Tool

1. Create directory `_build/images/<tool-name>/`
2. Add `Dockerfile` following the pattern:
   ```dockerfile
   ARG BASE_IMAGE_BUILD=registry.iic.jku.at:5000/iic-osic-tools:base-dev
   FROM ${BASE_IMAGE_BUILD} AS <tool-name>
   ARG <TOOL>_REPO_URL="https://github.com/..."
   ARG <TOOL>_REPO_COMMIT="<commit-or-tag>"
   COPY images/<tool-name>/scripts/install.sh install.sh
   RUN --mount=type=bind,source=images/<tool-name>,target=/images/<tool-name> \
       bash /images/<tool-name>/scripts/install.sh
   ```
3. Add install script at `_build/images/<tool-name>/scripts/install.sh`
4. Add entry to `_build/tool_metadata.yml`
5. Add target to `_build/docker-bake.hcl`
6. Add COPY command in `_build/images/iic-osic-tools/Dockerfile`

### Updating Tool Versions

Edit `_build/tool_metadata.yml` to change the commit/tag for a tool:
```yaml
- name: magic
  repo: https://github.com/rtimothyedwards/magic.git
  commit: "8.3.582"
```

## Testing

### Running Tests

```bash
cd _tests
./run_docker_tests.sh hpretl/iic-osic-tools:latest
```

### Test Structure

Each test resides in a numbered directory (01-18) containing:
- `test_*.sh`: Test script that returns 0 on success, non-zero on failure
- Supporting files (source code, configs)

Tests are run in parallel using GNU parallel. Check `TESTS.md` for descriptions.

### Writing Tests

```bash
#!/bin/bash
# Test script template
if command -v <tool> >/dev/null 2>&1; then
    # Run test
    <tool> <args> > "$LOG"
    if grep -q "ERROR" "$LOG"; then
        echo "[ERROR] Test <description> FAILED."
        exit 1
    else
        echo "[INFO] Test <description> passed."
        exit 0
    fi
fi
```

## Code Conventions

### Shell Scripts
- SPDX license headers required
- Use `shellcheck` for validation
- Support `DRY_RUN` mode where applicable
- Use `set -e` for error handling in build scripts

### Dockerfiles
- Use multi-stage builds
- Cache-friendly layer ordering
- ARG for version control
- Install to `/foss/tools/<tool-name>/`

### Environment Variables
- `TOOLS=/foss/tools`: Tool installation directory
- `PDK_ROOT=/foss/pdks`: PDK installation directory
- `DESIGNS=/foss/designs`: User design directory (mounted volume)
- `HOME=/headless`: Container home directory

### Naming Conventions
- Scripts: `sak-*.sh` (formerly `iic-*.sh`, aliases still work)
- Container names: `iic-osic-tools_<mode>_uid_<uid>`
- Image tags: `YYYY.MM` format (e.g., `2025.12`)

## Important Files

| File | Purpose |
|------|---------|
| `_build/tool_metadata.yml` | Tool version pins (commits/tags) |
| `_build/docker-bake.hcl` | Docker Bake build configuration |
| `_build/images/iic-osic-tools/Dockerfile` | Final image assembly |
| `RELEASE_NOTES.md` | Version history and changes |
| `KNOWN_ISSUES.md` | Known problems and workarounds |
| `start_vnc.sh` | Primary VNC startup script |
| `start_x.sh` | X11 forwarding startup script |

## Common Tasks

### Test Local Image
```bash
DOCKER_USER=registry.iic.jku.at:5000 DOCKER_TAG=next ./start_shell.sh
```

### Debug Container Issues
```bash
./start_x.sh --debug  # Verbose startup output
```

### Skip UI Startup
```bash
docker run hpretl/iic-osic-tools --skip bash
```

### Set VNC Resolution
```bash
export VNC_RESOLUTION=1920x1080
./start_vnc.sh
```

## CI/CD

- **devcontainer-docker.yaml**: Builds and publishes devcontainer images to GHCR
- **devcontainer-template.yaml**: Template workflow for devcontainer builds

Images are published to:
- Docker Hub: `hpretl/iic-osic-tools`
- GHCR: `ghcr.io/iic-jku/iic-osic-tools-devcontainer`

## Issue Reporting

Before filing issues:
1. Check `KNOWN_ISSUES.md` for documented problems
2. Check existing GitHub issues
3. Determine if issue is with container or specific tool
4. Include: OS, operation mode (VNC/X11), version tag

## Quick Reference

| Command | Description |
|---------|-------------|
| `sak-pdk <pdk>` | Switch PDK |
| `sak-drc.sh` | Run DRC checks |
| `sak-lvs.sh` | Run LVS checks |
| `sak-pex.sh` | Run parasitic extraction |
| `librelane` | RTL-to-GDS flow |
| `xschem` | Schematic editor |
| `klayout` | Layout editor |
| `ngspice` | SPICE simulator |
| `magic` | Layout with DRC/PEX |
