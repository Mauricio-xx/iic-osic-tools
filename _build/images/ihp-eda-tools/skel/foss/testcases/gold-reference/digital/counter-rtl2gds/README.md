# Counter RTL-to-GDS

## Description

This testcase demonstrates a complete RTL-to-GDS flow using LibreLane with the IHP SG13G2 PDK. It synthesizes a simple 32-bit counter from Verilog RTL and produces a final GDSII layout.

## Design

- **Module**: `counter`
- **Width**: 32-bit (parameterizable)
- **Clock**: `clk_i`
- **Reset**: `reset_i` (asynchronous, active-high)
- **Output**: `out_o[31:0]`

The counter increments on each rising clock edge and resets to zero when `reset_i` is asserted.

## Flow Configuration

| Parameter | Value |
|-----------|-------|
| Clock Period | 20 ns (50 MHz) |
| Die Area | 65 x 65 um |
| Target Density | 50% |
| Standard Cell Library | sg13g2_stdcell |

## Usage

### Using iic-testcase CLI

```bash
# Run the testcase
iic-testcase run gold-reference/digital/counter-rtl2gds

# Run with custom output directory
iic-testcase run gold-reference/digital/counter-rtl2gds --output ~/my-results
```

### Manual Execution

```bash
cd /foss/testcases/gold-reference/digital/counter-rtl2gds
./run.sh
```

## Input Files

| File | Description |
|------|-------------|
| `counter.v` | Verilog RTL source |
| `counter.json` | LibreLane flow configuration |
| `impl.sdc` | Implementation timing constraints |
| `signoff.sdc` | Signoff timing constraints |
| `pin_order.cfg` | IO pin placement |

## Output Files

- `counter.gds` - Final GDSII layout
- `counter.lef` - Library Exchange Format
- `librelane.log` - Flow execution log

## Flow Stages

1. **Synthesis** (Yosys) - Converts Verilog to gate-level netlist
2. **Floorplanning** (OpenROAD) - Defines die area and IO placement
3. **Placement** (OpenROAD) - Places standard cells
4. **Clock Tree Synthesis** (OpenROAD) - Builds clock distribution network
5. **Routing** (OpenROAD) - Connects all signals
6. **Signoff** - Final timing and DRC checks

## Viewing Results

```bash
# View GDS in KLayout
klayout output/counter.gds

# View in Magic
magic -T ihp-sg13g2 output/counter.gds
```

## Related Testcases

- `nmos-iv-curve` - Analog simulation example

## License

SPDX-License-Identifier: Apache-2.0
