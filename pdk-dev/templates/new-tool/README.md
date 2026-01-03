# Template: Integrating a New Tool with IHP SG13G2 PDK

This guide explains how to add support for a new EDA tool to the IHP SG13G2 PDK.

## Overview

Tool integration typically involves:
1. Creating technology files or configuration
2. Adding device symbols or cells
3. Setting up simulation models
4. Creating test cases

## Step 1: Identify Integration Points

Different tool types require different integration approaches:

### Schematic/Layout Tools
- Technology files (layers, colors, DRC rules)
- Device symbols or PCells
- Layer mappings

### Simulation Tools
- SPICE models (subcircuits, compact models)
- Model libraries
- Include paths

### Synthesis/P&R Tools
- Standard cell libraries
- Timing libraries (.lib)
- Physical rules (LEF/DEF)

## Step 2: Create Configuration Files

Use the templates in this directory as starting points:

```
templates/new-tool/
├── README.md              # This file
├── tool-config.template   # Generic configuration template
├── test-cases/            # Example test cases
│   └── basic_test.sh
└── validate.sh            # Validation script template
```

## Step 3: Directory Structure

Place tool-specific files in the PDK following this pattern:

```
ihp-sg13g2/
└── libs.tech/
    └── <tool-name>/
        ├── README.md           # Tool integration documentation
        ├── <tool>rc             # Tool configuration file
        ├── tech/               # Technology files
        ├── models/             # Simulation models (if applicable)
        └── tests/              # Test cases
```

## Step 4: Add Test Cases

Create test cases that verify the integration works:

1. Basic functionality test
2. All device types test
3. Corner case tests

Example test script:
```bash
#!/bin/bash
# Test <tool-name> integration with IHP SG13G2

source sak-pdk-script.sh ihp-sg13g2

# Run tool with test input
<tool> <test-input> > output.log 2>&1

# Verify output
if grep -q "expected_output" output.log; then
    echo "[PASS] Integration test passed"
    exit 0
else
    echo "[FAIL] Integration test failed"
    exit 1
fi
```

## Step 5: Document the Integration

Update the PDK documentation:

1. Add entry to main README
2. Document tool-specific setup
3. Provide usage examples

## Step 6: Validate

Run the validation script to ensure integration is correct:

```bash
./validate.sh <tool-name>
```

## Example Integrations

Refer to existing integrations as examples:

- **ngspice**: `libs.tech/ngspice/` - SPICE models with OSDI
- **klayout**: `libs.tech/klayout/` - DRC/LVS rule decks
- **xschem**: `libs.tech/xschem/` - Schematic symbols
- **magic**: `libs.tech/magic/` - Tech file and bindkeys
- **netgen**: `libs.tech/netgen/` - LVS setup

## Contributing

1. Fork the IHP-Open-PDK repository
2. Create your integration
3. Add test cases
4. Submit pull request with documentation

## Getting Help

- IHP PDK Issues: https://github.com/IHP-GmbH/IHP-Open-PDK/issues
- IIC-JKU Fork: https://github.com/iic-jku/IHP-Open-PDK
