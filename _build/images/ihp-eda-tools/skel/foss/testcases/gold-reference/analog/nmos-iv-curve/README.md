# NMOS IV Curve Characterization

## Description

This testcase performs DC IV characterization of the IHP SG13G2 low-voltage NMOS transistor. It sweeps drain-source voltage (Vds) and gate-source voltage (Vgs) to generate the device's output characteristics.

## Device Under Test

- **Device**: `sg13_lv_nmos`
- **Width**: 1.0 um
- **Length**: 0.13 um (minimum)
- **Fingers**: 1
- **Corner**: TT (typical-typical)
- **Temperature**: 27C

## Simulation Parameters

| Parameter | Start | Stop | Step |
|-----------|-------|------|------|
| Vds | 0 V | 1.2 V | 10 mV |
| Vgs | 0.3 V | 0.5 V | 50 mV |

## Expected Results

The simulation produces DC IV curves showing:
- Linear region at low Vds
- Saturation region at high Vds
- Increasing drain current with higher Vgs

## Usage

### Using iic-testcase CLI

```bash
# Run the testcase
iic-testcase run gold-reference/analog/nmos-iv-curve

# Run with custom output directory
iic-testcase run gold-reference/analog/nmos-iv-curve --output ~/my-results
```

### Manual Execution

```bash
cd /foss/testcases/gold-reference/analog/nmos-iv-curve
./run.sh
```

## Output Files

- `nmos_iv.raw` - ngspice raw data file with IV curves
- `simulation.log` - ngspice execution log

## Viewing Results

```bash
# Using ngspice
ngspice
> load output/nmos_iv.raw
> plot i(vd)

# Using gaw (waveform viewer)
gaw output/nmos_iv.raw
```

## Related Testcases

- `pmos-iv-curve` - PMOS transistor characterization
- `nmos-temp-sweep` - NMOS temperature dependence

## License

SPDX-License-Identifier: Apache-2.0
