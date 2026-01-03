# IHP-EDA-Tools User Manual

Complete manual for integrated circuit designers using the IHP-EDA-Tools Docker container with the IHP SG13G2 PDK.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Installation and Setup](#2-installation-and-setup)
3. [Operation Modes](#3-operation-modes)
4. [Analog Design Flow](#4-analog-design-flow)
5. [Digital Design Flow](#5-digital-design-flow)
6. [Tool Catalog](#6-tool-catalog)
7. [Utility Scripts (SAK)](#7-utility-scripts-sak)
8. [Testcase System](#8-testcase-system)
9. [Troubleshooting](#9-troubleshooting)
10. [Quick Reference](#10-quick-reference)

---

## 1. Introduction

### 1.1 What is IHP-EDA-Tools?

**IHP-EDA-Tools** is a Docker container that provides a complete environment of open-source EDA (Electronic Design Automation) tools, optimized exclusively for the IHP SG13G2 PDK.

**Key features:**
- Over 50 pre-installed and configured EDA tools
- Ready-to-use IHP SG13G2 PDK
- Support for analog and digital design
- Complete RTL-to-GDS flow with LibreLane
- Reproducible environment across different machines

### 1.2 IHP SG13G2 PDK

The IHP SG13G2 PDK (Process Design Kit) is a 130nm SiGe:C BiCMOS process developed by IHP Microelectronics in Germany.

**Process features:**
- Technology: 130nm SiGe:C BiCMOS
- High-frequency HBT transistors
- 1.2V and 3.3V MOSFETs
- Precision resistors and capacitors
- Integrated inductors

**PDK components:**
- PSP OSDI models for ngspice
- Verilog-A plugins for Xyce
- DRC/LVS rules for KLayout
- Symbols for xschem
- Technology files for Magic
- Support for OpenROAD/LibreLane

### 1.3 Docker Container vs Local Installation

| Aspect | Docker | Local Installation |
|--------|--------|-------------------|
| **Setup time** | Minutes | Hours/Days |
| **Reproducibility** | High | Variable |
| **Updates** | Automatic | Manual |
| **Isolation** | Complete | None |
| **Disk space** | ~20 GB | Variable |
| **Graphics performance** | Slightly lower | Native |

### 1.4 System Requirements

**Minimum:**
- CPU: x86_64 (Intel/AMD)
- RAM: 8 GB
- Disk: 25 GB free
- Operating System: Windows 10+, macOS 11+, or Linux

**Recommended:**
- CPU: 4+ cores
- RAM: 16 GB or more
- Disk: SSD with 50 GB free
- GPU: OpenGL compatible (for accelerated rendering)

---

## 2. Installation and Setup

### 2.1 Docker Installation

#### Linux (Ubuntu/Debian)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y ca-certificates curl gnupg

# Add official Docker repository
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow usage without sudo (requires session restart)
sudo usermod -aG docker $USER
newgrp docker
```

#### macOS

1. Download Docker Desktop:
   - **Intel**: https://desktop.docker.com/mac/main/amd64/Docker.dmg
   - **Apple Silicon**: https://desktop.docker.com/mac/main/arm64/Docker.dmg

2. Open the `.dmg` file and drag Docker to Applications
3. Start Docker Desktop from Applications
4. Accept the terms and wait for initialization

#### Windows

1. Download Docker Desktop: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

2. Run the installer and follow the wizard

3. **Important:** Enable WSL 2:
   ```powershell
   # In PowerShell as Administrator
   wsl --install
   wsl --update
   ```

4. Restart the system

5. Start Docker Desktop

### 2.2 Download the Image

```bash
# From GitHub Container Registry (recommended)
docker pull ghcr.io/mauricio-xx/ihp-eda-tools:latest

# Or from Docker Hub
docker pull mauricio-xx/ihp-eda-tools:latest
```

**Note:** The first download may take several minutes depending on internet speed (~4 GB compressed).

### 2.3 Clone the Repository

```bash
git clone --depth=1 https://github.com/mauricio-xx/ihp-eda-tools.git
cd ihp-eda-tools
```

> **Note:** This project is an optimized fork of [iic-osic-tools](https://github.com/iic-jku/iic-osic-tools)
> originally developed by Harald Pretl and the JKU team. We thank them for their excellent work
> that served as the foundation for this IHP-focused version.

### 2.4 Design Directory

By default, the container mounts the `~/eda/designs` directory to `/foss/designs` inside the container.

```bash
# Create directory (if it doesn't exist)
mkdir -p ~/eda/designs

# Or use a custom directory
export DESIGNS=/path/to/my/designs
```

**Important:** All design files must be inside this directory to be accessible from the container.

### 2.5 Environment Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `DESIGNS` | `$HOME/eda/designs` | Mounted design directory |
| `DOCKER_USER` | `hpretl` | Docker repository username |
| `DOCKER_IMAGE` | `ihp-eda-tools` | Image name |
| `DOCKER_TAG` | `latest` | Image tag |
| `WEBSERVER_PORT` | `80` | Port for noVNC (VNC mode) |
| `VNC_PORT` | `5901` | Direct VNC port |

---

## 3. Operation Modes

IHP-EDA-Tools supports four operation modes according to user needs.

### 3.1 VNC Mode (Recommended for beginners)

Provides a complete XFCE desktop accessible from a web browser.

**Start:**
```bash
./start_vnc.sh
```

**Access:**
- Open browser at: http://localhost
- Default password: `abc123`

**Advantages:**
- Works on any operating system
- No additional configuration required
- Complete desktop with file manager

**Disadvantages:**
- Slower rendering than native X11
- Requires more system resources

**Customize password:**
```bash
VNC_PW=my_password ./start_vnc.sh
```

### 3.2 X11 Mode (Recommended for performance)

Renders windows directly on the host desktop.

**Start:**
```bash
./start_x.sh
```

**Advantages:**
- Native graphics rendering (faster)
- Better desktop integration
- Copy/paste between container and host

**Additional requirements:**

**Linux:**
- Working X11 server (installed by default on most distributions)

**macOS:**
- Install XQuartz: https://www.xquartz.org
- In XQuartz Preferences > Security: Enable "Allow connections from network clients"

**Windows:**
- WSL 2 with WSLg (Windows 10 Build 19044+ or Windows 11)

### 3.3 Shell Mode (For advanced users)

Direct command line access without graphical interface.

**Start:**
```bash
./start_shell.sh
```

**Features:**
- Runs as root by default
- Ideal for automated scripts
- Minimal resource usage

**Usage example:**
```bash
./start_shell.sh
# Inside the container:
ngspice -b /foss/designs/my_circuit.spice
```

### 3.4 Mode Comparison

| Feature | VNC | X11 | Shell |
|---------|-----|-----|-------|
| Graphical interface | Yes | Yes | No |
| Graphics performance | Medium | High | N/A |
| Ease of use | High | Medium | Low |
| Host integration | Low | High | Medium |
| Resource usage | High | Medium | Low |
| Extra config required | No | Yes* | No |

*Except on Linux with native X11

---

## 4. Analog Design Flow

### 4.1 Flow Overview

```
Specification
     |
     v
Schematic Capture (xschem)
     |
     v
SPICE Simulation (ngspice/xyce)
     |
     v
Layout Design (KLayout/Magic)
     |
     v
DRC Verification (sak-drc.sh)
     |
     v
LVS Verification (sak-lvs.sh)
     |
     v
Parasitic Extraction (sak-pex.sh)
     |
     v
Post-Layout Simulation
     |
     v
Tapeout
```

### 4.2 Schematic Capture with xschem

xschem is the main schematic editor for analog design with IHP.

**Start xschem:**
```bash
xschem
```

**Configure PDK:**
```bash
# In ~/.xschemrc file or in terminal before opening xschem
source sak-pdk-script.sh ihp-sg13g2
```

**Access IHP symbols:**
- Menu: File > Open Library
- Navigate to: `$PDK_ROOT/ihp-sg13g2/libs.tech/xschem/`

**Available symbols:**
| Category | Examples |
|----------|----------|
| MOSFET | sg13_lv_nmos, sg13_lv_pmos, sg13_hv_nmos, sg13_hv_pmos |
| HBT | npn13G2, npn13G2L, npn13G2V |
| Resistors | res_rppd, res_rsil |
| Capacitors | cap_cmim |
| Inductors | inductor2 |

**Useful shortcuts:**
| Key | Action |
|-----|--------|
| `i` | Insert symbol |
| `w` | Draw wire |
| `c` | Copy |
| `m` | Move |
| `q` | Object properties |
| `Ctrl+S` | Save |
| `Netlist` | Generate netlist for simulation |

### 4.3 Simulation with ngspice

ngspice is the main SPICE simulator, with support for PSP OSDI models from the IHP PDK.

**Batch simulation:**
```bash
ngspice -b my_circuit.spice -o result.log
```

**Interactive simulation:**
```bash
ngspice my_circuit.spice
```

**Basic netlist example:**
```spice
* Example NMOS IV Curve - IHP SG13G2
.lib cornerMOSlv.lib mos_tt

* Parameters
.param vds_max = 1.2
.param vgs_max = 1.2

* Sources
Vds drain 0 DC 0
Vgs gate 0 DC 0

* Device under test
XM1 drain gate 0 0 sg13_lv_nmos W=1u L=0.13u ng=1

* DC Analysis
.dc Vds 0 'vds_max' 0.01 Vgs 0 'vgs_max' 0.2

* Control
.control
run
plot -i(Vds)
wrdata output.csv -i(Vds)
.endc

.end
```

**Analysis types:**
| Command | Description |
|---------|-------------|
| `.dc` | DC sweep |
| `.ac` | AC analysis (frequency) |
| `.tran` | Transient (time) |
| `.noise` | Noise analysis |
| `.op` | Operating point |

### 4.4 Waveform Visualization

**gaw3 (integrated with xschem):**
- Opens automatically from xschem
- Menu: Simulation > Waveform Viewer

**gtkwave (for digital and mixed-signal):**
```bash
gtkwave file.vcd
```

**surfer (modern, with limitations):**
```bash
surfer file.vcd
```

### 4.5 Layout Design

#### KLayout (Recommended)

```bash
klayout
```

**Load IHP technology:**
- Menu: File > Reader Options > Layout > Technology: ihp-sg13g2

**Main IHP SG13G2 layers:**
| Layer | Purpose |
|-------|---------|
| Activ | Active area |
| GatPoly | Polysilicon (gates) |
| Metal1-5 | Metal layers |
| Via1-4 | Vias between metals |

#### Magic

```bash
magic -T ihp-sg13g2
```

### 4.6 DRC Verification

**Using the SAK script:**
```bash
sak-drc.sh -k my_layout.gds -w ./output
```

**Parameters:**
- `-k <file>`: Input GDS file
- `-w <directory>`: Working/output directory
- `-t <top>`: Top cell (optional)

**Output:**
- `.lyrdb` file: Error report for KLayout
- `.log` file: Execution log

### 4.7 LVS Verification

**Using the SAK script:**
```bash
sak-lvs.sh -s my_schematic.sch -l my_layout.gds -w ./output
```

**Parameters:**
- `-s <file>`: Schematic (xschem)
- `-l <file>`: Layout (GDS)
- `-w <directory>`: Working directory

### 4.8 Parasitic Extraction (PEX)

```bash
sak-pex.sh -l my_layout.gds -w ./output
```

### 4.9 Tutorial: NMOS IV Characterization

This tutorial demonstrates the basic analog simulation flow.

**1. Create working directory:**
```bash
mkdir -p ~/eda/designs/nmos-test
cd ~/eda/designs/nmos-test
```

**2. Create netlist (nmos_iv.spice):**
```spice
* NMOS IV Curve - IHP SG13G2
.lib cornerMOSlv.lib mos_tt

Vds drain 0 DC 0
Vgs gate 0 DC 0

XM1 drain gate 0 0 sg13_lv_nmos W=1u L=0.13u ng=1

.dc Vds 0 1.2 0.01 Vgs 0 1.2 0.2

.control
run
plot -i(Vds) title 'NMOS IV Curves'
.endc

.end
```

**3. Run simulation:**
```bash
ngspice nmos_iv.spice
```

**4. View results:**
- The graph window will show the NMOS IV curves
- Each curve represents a different Vgs value

---

## 5. Digital Design Flow

### 5.1 RTL-to-GDS Flow Overview

```
RTL Code (Verilog/VHDL)
     |
     v
Logic Synthesis (Yosys)
     |
     v
Floorplanning (OpenROAD)
     |
     v
Placement (OpenROAD)
     |
     v
Clock Tree Synthesis (OpenROAD)
     |
     v
Routing (OpenROAD)
     |
     v
DRC/LVS Verification
     |
     v
Final GDSII
```

### 5.2 RTL Coding

**Verilog Example (counter.v):**
```verilog
// counter.v - 32-bit Counter
module counter #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if (enable)
            count <= count + 1;
    end
endmodule
```

### 5.3 Synthesis with Yosys

**Basic synthesis:**
```bash
yosys -p "read_verilog counter.v; synth -top counter; write_json counter.json"
```

**Complete Yosys script:**
```tcl
# synth.tcl
read_verilog counter.v
hierarchy -top counter
proc; opt; fsm; opt; memory; opt
techmap; opt
dfflibmap -liberty $::env(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ.lib
abc -liberty $::env(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ.lib
clean
write_verilog -noattr counter_synth.v
```

### 5.4 RTL-to-GDS Flow with LibreLane

LibreLane is the recommended RTL-to-GDS flow for IHP SG13G2.

**Project configuration (config.json):**
```json
{
  "design": "counter",
  "verilog_files": ["counter.v"],
  "pdk": "ihp-sg13g2",
  "std_cell_library": "sg13g2_stdcell",
  "clock_port": "clk",
  "clock_period": 10.0,
  "die_area": [0, 0, 100, 100],
  "core_area": [10, 10, 90, 90]
}
```

**Run LibreLane:**
```bash
# Configure environment
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell

# Run flow
librelane --manual-pdk config.json
```

**Output files:**
- `runs/<run>/results/final/gds/counter.gds` - Final layout
- `runs/<run>/reports/` - Timing, area, power reports

### 5.5 Digital Simulation

**Icarus Verilog:**
```bash
iverilog -o sim counter.v counter_tb.v
vvp sim
gtkwave dump.vcd
```

**Verilator (faster):**
```bash
verilator --cc --exe --build counter.v counter_tb.cpp
./obj_dir/Vcounter
```

### 5.6 Formal Verification

**SymbiYosys (sby):**
```bash
sby -f counter.sby
```

**.sby file:**
```
[options]
mode prove
depth 20

[engines]
smtbmc z3

[script]
read -formal counter.v
prep -top counter

[files]
counter.v
```

### 5.7 Tutorial: Counter RTL-to-GDS

**1. Prepare files:**
```bash
mkdir -p ~/eda/designs/counter-test
cd ~/eda/designs/counter-test
```

**2. Create counter.v** (code above)

**3. Create config.json** (configuration above)

**4. Run flow:**
```bash
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
librelane --manual-pdk config.json
```

**5. View result:**
```bash
klayout runs/*/results/final/gds/counter.gds
```

---

## 6. Tool Catalog

### 6.1 Schematic Capture and Layout

| Tool | Description | Command |
|------|-------------|---------|
| xschem | Schematic editor | `xschem` |
| klayout | Layout editor/viewer | `klayout` |
| magic | Layout with DRC/PEX | `magic` |
| gds3d | 3D GDS viewer | `gds3d` |
| xcircuit | Alternative editor | `xcircuit` |

### 6.2 Analog Simulation

| Tool | Description | Command |
|------|-------------|---------|
| ngspice | SPICE simulator | `ngspice` |
| xyce | Parallel SPICE | `Xyce` |
| gaw3 | Waveform viewer (xschem) | `gaw` |
| qucs-s | RF simulation environment | `qucs-s` |

### 6.3 Digital Simulation

| Tool | Description | Command |
|------|-------------|---------|
| iverilog | Verilog simulator | `iverilog` |
| verilator | Fast simulator | `verilator` |
| ghdl | VHDL simulator | `ghdl` |
| nvc | Modern VHDL compiler | `nvc` |
| gtkwave | Waveform viewer | `gtkwave` |
| surfer | Modern viewer | `surfer` |
| digital | Educational logic simulator | `digital` |

### 6.4 Synthesis and P&R

| Tool | Description | Command |
|------|-------------|---------|
| yosys | Logic synthesis | `yosys` |
| openroad | P&R engine | `openroad` |
| librelane | RTL-to-GDS flow | `librelane` |
| abc | Sequential synthesis | `abc` |

### 6.5 Verification

| Tool | Description | Command |
|------|-------------|---------|
| netgen | LVS | `netgen` |
| cvc | ERC | `cvc_rv` |
| covered | Verilog coverage | `covered` |
| eqy | Equivalence | `eqy` |
| sby | Formal verification | `sby` |
| mcy | Mutation coverage | `mcy` |

### 6.6 RF and Electromagnetics

| Tool | Description | Command |
|------|-------------|---------|
| openems | FDTD EM simulator | `openems` |
| palace | 3D EM simulator | `palace` |
| qucs-s | RF simulation | `qucs-s` |
| FastHenry2 | Inductance | `fasthenry` |
| FasterCap | Capacitance | `fastercap` |

### 6.7 PDK Development

| Tool | Description | Command |
|------|-------------|---------|
| openvaf | Verilog-A compiler | `openvaf` |
| charlib | Cell characterization | `charlib` |
| cace | Characterization engine | `cace` |
| ciel | PDK manager | `ciel` |

---

## 7. Utility Scripts (SAK)

The SAK (Swiss Army Knife) scripts simplify common verification tasks.

### 7.1 sak-drc.sh - DRC Verification

**Usage:**
```bash
sak-drc.sh -k <file.gds> [-t <top_cell>] [-w <directory>]
```

**Parameters:**
| Parameter | Description |
|-----------|-------------|
| `-k` | Input GDS file |
| `-t` | Top cell (auto-detected if not specified) |
| `-w` | Working directory (default: current directory) |

**Example:**
```bash
sak-drc.sh -k my_layout.gds -w ./drc_output
```

### 7.2 sak-lvs.sh - LVS Verification

**Usage:**
```bash
sak-lvs.sh -s <schematic.sch> -l <layout.gds> [-w <directory>]
```

**Example:**
```bash
sak-lvs.sh -s my_amp.sch -l my_amp.gds -w ./lvs_output
```

### 7.3 sak-pex.sh - Parasitic Extraction

**Usage:**
```bash
sak-pex.sh -l <layout.gds> [-w <directory>]
```

### 7.4 sak-pdk-script.sh - PDK Configuration

**Usage:**
```bash
source sak-pdk-script.sh <pdk> [standard_cell_library]
```

**Examples:**
```bash
# Configure IHP PDK for analog
source sak-pdk-script.sh ihp-sg13g2

# Configure IHP PDK for digital
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
```

**Configured variables:**
- `PDK` - PDK name
- `PDKPATH` - Full path to PDK
- `STD_CELL_LIBRARY` - Standard cell library
- `KLAYOUT_PATH` - KLayout technology path
- `SPICE_USERINIT_DIR` - ngspice initialization directory

### 7.5 sak-clean.sh - Cleanup

Removes temporary simulation and verification files:
```bash
sak-clean.sh
```

### 7.6 sak-layconv.sh - Layout Conversion

Converts between GDS, OASIS, etc. formats:
```bash
sak-layconv.sh input.gds output.oas
```

### 7.7 sak-vlint.sh - Verilog Linting

Checks style and errors in Verilog code:
```bash
sak-vlint.sh my_module.v
```

---

## 8. Testcase System

### 8.1 What are Testcases?

Testcases are reproducible design examples that serve to:
- Learn design flows with IHP SG13G2
- Validate PDK configuration
- Share designs with the community

### 8.2 Testcase Structure

```
testcases/
├── gold-reference/     # Official examples
│   ├── analog/
│   │   └── nmos-iv-curve/
│   └── digital/
│       └── counter-rtl2gds/
├── validation/         # PDK tests
└── contributed/        # Contributions
```

### 8.3 iic-testcase CLI

**List testcases:**
```bash
# All
iic-testcase list

# By category
iic-testcase list --category gold-reference

# By type
iic-testcase list --type simulation
```

**View information:**
```bash
iic-testcase info gold-reference/analog/nmos-iv-curve
```

**Run testcase:**
```bash
iic-testcase run gold-reference/analog/nmos-iv-curve
```

**Validate results:**
```bash
iic-testcase validate gold-reference/analog/nmos-iv-curve
```

### 8.4 Create Your Own Testcase

**Initialize:**
```bash
iic-testcase init my-amplifier --template analog-simulation
```

**Created structure:**
```
my-amplifier/
├── testcase.yaml    # Metadata
├── run.sh           # Execution script
├── inputs/          # Input files
└── README.md        # Documentation
```

**Verify structure:**
```bash
iic-testcase verify my-amplifier/
```

### 8.5 Available Testcases

| Testcase | Type | Description |
|----------|------|-------------|
| `gold-reference/analog/nmos-iv-curve` | simulation | NMOS IV curves |
| `gold-reference/digital/counter-rtl2gds` | rtl2gds | Complete digital flow |
| `validation/drc/klayout-invocation` | drc | DRC environment validation |
| `validation/lvs/netgen-invocation` | lvs | LVS environment validation |

---

## 9. Troubleshooting

### 9.1 Docker Issues

**Error: "permission denied"**
```bash
# On Linux, add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

**Error: "Cannot connect to Docker daemon"**
```bash
# Verify Docker is running
sudo systemctl start docker
# Or on Docker Desktop, start the application
```

**Insufficient space**
```bash
# Clean unused images and containers
docker system prune -a
```

### 9.2 Graphics Issues

**Black screen in VNC mode**
- Wait a few seconds - desktop takes time to load
- Refresh the browser
- Verify port 80 is not in use

**xschem freezes on macOS**
- Use specific XQuartz version
- Avoid long idle periods
- Keep `htop` running in secondary terminal

**OpenGL error**
```bash
# Inside the container
export LIBGL_ALWAYS_INDIRECT=0
```

**Surfer closes unexpectedly**
- Known issue with OpenGL drivers
- Use gtkwave as alternative

### 9.3 Simulation Issues

**ngspice: "model not found"**
```bash
# Verify PDK configuration
source sak-pdk-script.sh ihp-sg13g2
echo $SPICE_USERINIT_DIR
```

**Convergence error**
- Reduce time step in `.tran`
- Add `.options reltol=1e-4`
- Verify initial conditions

### 9.4 LibreLane Issues

**Error: "PDK not found"**
```bash
# Configure PDK before running
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
```

**Timing violations**
- Increase clock period
- Reduce placement density
- Review cell fanout

### 9.5 Platform-Specific Issues

#### Windows

| Issue | Solution |
|-------|----------|
| WSLg not available | Update WSL: `wsl --update` |
| Frequent xschem crashes | Use VcXsrv version 64.1.17.2.0 |
| Incorrect file permissions | Use `/foss/designs` instead of `/mnt/c/` |

#### macOS

| Issue | Solution |
|-------|----------|
| XQuartz won't connect | Enable network connections in preferences |
| Crash due to inactivity | Keep activity in terminal (run `htop`) |
| Slow VirtioFS | Disable in Docker Desktop settings |

#### Linux

| Issue | Solution |
|-------|----------|
| Docker Desktop X11 | Install `socat` for forwarding |
| /dev/dri permissions | Add user to `video` group |
| Wayland not working | Use X11 or install XWayland |

---

## 10. Quick Reference

### 10.1 Essential Commands

```bash
# Start container
./start_vnc.sh          # VNC mode (browser)
./start_x.sh            # X11 mode (native)
./start_shell.sh        # Shell mode

# Configure PDK
source sak-pdk-script.sh ihp-sg13g2

# Main tools
xschem                  # Schematics
klayout                 # Layout
ngspice my_sim.spice    # Simulation
librelane config.json   # RTL-to-GDS

# Verification
sak-drc.sh -k layout.gds
sak-lvs.sh -s sch.sch -l layout.gds

# Testcases
iic-testcase list
iic-testcase run gold-reference/analog/nmos-iv-curve
```

### 10.2 Important Environment Variables

| Variable | Typical Value | Description |
|----------|---------------|-------------|
| `PDK` | `ihp-sg13g2` | Active PDK |
| `PDKPATH` | `/foss/pdks/ihp-sg13g2` | Path to PDK |
| `TOOLS` | `/foss/tools` | Tools directory |
| `DESIGNS` | `/foss/designs` | Designs directory |
| `PDK_ROOT` | `/foss/pdks` | PDK root |

### 10.3 Important Paths

| Path | Contents |
|------|----------|
| `/foss/tools/` | Installed EDA tools |
| `/foss/pdks/ihp-sg13g2/` | IHP SG13G2 PDK |
| `/foss/designs/` | Working directory (mounted) |
| `/foss/examples/` | Included examples |
| `/foss/testcases/` | Testcase system |
| `/headless/` | Environment configuration |

### 10.4 Keyboard Shortcuts

**xschem:**
| Key | Action |
|-----|--------|
| `i` | Insert symbol |
| `w` | Draw wire |
| `c` | Copy |
| `m` | Move |
| `Del` | Delete |
| `q` | Properties |
| `Ctrl+S` | Save |

**KLayout:**
| Key | Action |
|-----|--------|
| `i` | Insert instance |
| `r` | Draw rectangle |
| `p` | Draw polygon |
| `m` | Move |
| `Space` | Select |
| `F2` | Zoom fit |

### 10.5 Useful Links

- **IHP PDK**: https://github.com/IHP-GmbH/IHP-Open-PDK
- **iic-osic-tools**: https://github.com/iic-jku/iic-osic-tools
- **ngspice**: http://ngspice.sourceforge.net
- **xschem**: https://github.com/StefanSchippers/xschem
- **KLayout**: https://www.klayout.de
- **LibreLane**: https://github.com/librelane/librelane
- **OpenROAD**: https://theopenroadproject.org

---

## License

This manual is licensed under Apache-2.0.

SPDX-License-Identifier: Apache-2.0

---

*Manual generated for IHP-EDA-Tools - Version 2025.01*
