# [Testcase Name]

## Description

[Provide a clear description of what this testcase demonstrates or validates]

## Circuit/Design Details

[Describe the circuit or design being tested]

- **Device/Module**: [e.g., sg13_lv_nmos, counter, OTA]
- **Parameters**: [Key parameters like W, L, frequency, etc.]
- **Corner**: [TT, SS, FF, etc.]
- **Temperature**: [e.g., 27°C]

## Simulation/Flow Configuration

| Parameter | Value |
|-----------|-------|
| [Param 1] | [Value] |
| [Param 2] | [Value] |

## Usage

### Using iic-testcase CLI (inside container)

```bash
# Run the testcase
iic-testcase run .

# Run with validation
iic-testcase validate .

# Run with custom output directory
iic-testcase run . --output ~/my-results
```

### Manual Execution

```bash
./run.sh
```

### Using GitHub Actions

This repository includes a CI workflow that automatically tests the testcase using the IHP-EDA-Tools container. See `.github/workflows/test.yml`.

## Input Files

| File | Description |
|------|-------------|
| `inputs/[file]` | [Description] |

## Output Files

| File | Description |
|------|-------------|
| `[output file]` | [Description] |

## Expected Results

[Describe what constitutes a successful test]

## Viewing Results

```bash
# Example commands to view results
# ngspice: gaw output/result.raw
# GDS: klayout output/design.gds
```

## Requirements

- IHP-EDA-Tools container version 2025.01 or later
- IHP SG13G2 PDK

## Author

- **Name**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [@username](https://github.com/username)

## License

SPDX-License-Identifier: Apache-2.0
