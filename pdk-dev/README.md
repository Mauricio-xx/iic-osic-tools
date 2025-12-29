# IHP PDK Development Tools

This directory contains tools and scripts for developing and validating the IHP SG13G2 PDK.

## Overview

The PDK Development Mode allows contributors to:
- Validate DRC rules
- Test LVS setup
- Compile Verilog-A models to OSDI
- Run simulation test cases
- Validate xschem symbols

## Usage

### Starting PDK Development Mode

From the host system:
```bash
./start_pdk_dev.sh --pdk-source ~/my-ihp-pdk-fork
```

This mounts your local PDK directory at `/foss/pdks/ihp-sg13g2` inside the container, allowing you to edit files and immediately test changes.

### Validation Scripts

All scripts are located in `/foss/pdk-dev/` inside the container:

| Script | Description |
|--------|-------------|
| `validate-drc.sh` | Run DRC test cases to validate rule deck |
| `validate-lvs.sh` | Run LVS test cases to validate setup cells |
| `compile-models.sh` | Compile Verilog-A to OSDI using OpenVAF |
| `test-simulation.sh` | Run simulation test suite |
| `check-symbols.sh` | Validate xschem symbols consistency |

### Running Validation

```bash
# Inside container
cd /foss/pdk-dev

# Run all validations
./validate-drc.sh
./validate-lvs.sh
./test-simulation.sh

# Compile Verilog-A models
./compile-models.sh

# Check symbol consistency
./check-symbols.sh
```

## Directory Structure

```
pdk-dev/
├── README.md              # This file
├── validate-drc.sh        # DRC rule validation
├── validate-lvs.sh        # LVS setup validation
├── compile-models.sh      # Verilog-A compilation
├── test-simulation.sh     # Simulation tests
├── check-symbols.sh       # Symbol validation
├── templates/             # Templates for new integrations
│   └── new-tool/          # Template for adding new tool support
└── integration-tests/     # PDK integration test cases
```

## Adding Support for a New Tool

See `templates/new-tool/README.md` for a guide on integrating a new EDA tool with the IHP PDK.

## Test Cases

The `integration-tests/` directory contains test cases shared between circuit designers and PDK developers. This ensures that changes to the PDK don't break existing designs.

## Contributing

1. Fork the IHP-Open-PDK repository
2. Start PDK Development Mode with your fork
3. Make changes and run validation scripts
4. Submit pull request to upstream PDK

## Related Documentation

- [IHP SG13G2 PDK Documentation](https://github.com/IHP-GmbH/IHP-Open-PDK)
- [IIC-JKU IHP PDK Fork](https://github.com/iic-jku/IHP-Open-PDK)
