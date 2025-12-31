# IHP-EDA-Tools: Docker Bake configuration
# This is an IHP-focused container - RISC-V, FPGA, and unused tools have been removed

target "base" {
  platforms = ["linux/amd64"]
  dockerfile = "images/base/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:base"]
}

target "base-dev" {
  platforms = ["linux/amd64"]
  dockerfile = "images/base-dev/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:base-dev"]
}

group "tools" {
  targets = ["tools-level-1", "tools-level-2", "tools-level-3"]
}

target "image-full" {
  platforms = ["linux/amd64"]
  dockerfile = "images/ihp-eda-tools/Dockerfile"
}

group "images" {
  targets = ["image-full"]
}


# Base target for common settings
target "base-tool" {
  platforms = ["linux/amd64"]
  cache-to = ["type=inline"]
}

# Individual tool targets for tools-level-1
target "magic" {
  inherits = ["base-tool"]
  dockerfile = "images/magic/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-magic-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-magic-latest"]
}

target "openvaf" {
  inherits = ["base-tool"]
  dockerfile = "images/openvaf/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-openvaf-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-openvaf-latest"]
}

target "osic-multitool" {
  inherits = ["base-tool"]
  dockerfile = "images/osic-multitool/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-osic-multitool-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-osic-multitool-latest"]
}

target "xyce" {
  inherits = ["base-tool"]
  dockerfile = "images/xyce/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-xyce-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-xyce-latest"]
}

target "covered" {
  inherits = ["base-tool"]
  dockerfile = "images/covered/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-covered-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-covered-latest"]
}

target "digital" {
  inherits = ["base-tool"]
  dockerfile = "images/digital/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-digital-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-digital-latest"]
}

target "cvc_rv" {
  inherits = ["base-tool"]
  dockerfile = "images/cvc_rv/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-cvc_rv-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-cvc_rv-latest"]
}

target "gaw3-xschem" {
  inherits = ["base-tool"]
  dockerfile = "images/gaw3-xschem/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-gaw3-xschem-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-gaw3-xschem-latest"]
}

target "ghdl" {
  inherits = ["base-tool"]
  dockerfile = "images/ghdl/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-latest"]
}

target "gtkwave" {
  inherits = ["base-tool"]
  dockerfile = "images/gtkwave/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-gtkwave-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-gtkwave-latest"]
}

target "irsim" {
  inherits = ["base-tool"]
  dockerfile = "images/irsim/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-irsim-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-irsim-latest"]
}

target "iverilog" {
  inherits = ["base-tool"]
  dockerfile = "images/iverilog/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-iverilog-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-iverilog-latest"]
}

target "klayout" {
  inherits = ["base-tool"]
  dockerfile = "images/klayout/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-klayout-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-klayout-latest"]
}

target "netgen" {
  inherits = ["base-tool"]
  dockerfile = "images/netgen/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-netgen-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-netgen-latest"]
}

target "ngspyce" {
  inherits = ["base-tool"]
  dockerfile = "images/ngspyce/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspyce-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspyce-latest"]
}

target "nvc" {
  inherits = ["base-tool"]
  dockerfile = "images/nvc/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-nvc-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-nvc-latest"]
}

target "openems" {
  inherits = ["base-tool"]
  dockerfile = "images/openems/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-openems-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-openems-latest"]
}

target "openroad" {
  inherits = ["base-tool"]
  dockerfile = "images/openroad/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-latest"]
}

target "openroad-librelane" {
  inherits = ["base-tool"]
  dockerfile = "images/openroad-librelane/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-librelane-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-librelane-latest"]
}

target "palace" {
  inherits = ["base-tool"]
  dockerfile = "images/palace/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-palace-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-palace-latest"]
}

target "surelog" {
  inherits = ["base-tool"]
  dockerfile = "images/surelog/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-surelog-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-surelog-latest"]
}

target "surfer" {
  inherits = ["base-tool"]
  dockerfile = "images/surfer/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-surfer-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-surfer-latest"]
}

target "qflow" {
  inherits = ["base-tool"]
  dockerfile = "images/qflow/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-qflow-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-qflow-latest"]
}

target "qucs-s" {
  inherits = ["base-tool"]
  dockerfile = "images/qucs-s/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-qucs-s-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-qucs-s-latest"]
}

target "slang" {
  inherits = ["base-tool"]
  dockerfile = "images/slang/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-latest"]
}

target "verilator" {
  inherits = ["base-tool"]
  dockerfile = "images/verilator/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-verilator-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-verilator-latest"]
}

target "xcircuit" {
  inherits = ["base-tool"]
  dockerfile = "images/xcircuit/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-xcircuit-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-xcircuit-latest"]
}

target "xschem" {
  inherits = ["base-tool"]
  dockerfile = "images/xschem/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-xschem-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-xschem-latest"]
}

target "yosys" {
  inherits = ["base-tool"]
  dockerfile = "images/yosys/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-yosys-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-yosys-latest"]
}

target "rftoolkit" {
  inherits = ["base-tool"]
  dockerfile = "images/rftoolkit/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-rftoolkit-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-rftoolkit-latest"]
}

# Individual tool targets for tools-level-2
target "xyce-xdm" {
  inherits = ["base-tool"]
  dockerfile = "images/xyce-xdm/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-xyce-xdm-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-xyce-xdm-latest"]
}

target "open_pdks" {
  inherits = ["base-tool"]
  dockerfile = "images/open_pdks/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-open_pdks-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-open_pdks-latest"]
}

target "vacask" {
  inherits = ["base-tool"]
  dockerfile = "images/vacask/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-vacask-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-vacask-latest"]
}

target "ghdl-yosys-plugin" {
  inherits = ["base-tool"]
  dockerfile = "images/ghdl-yosys-plugin/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-yosys-plugin-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-yosys-plugin-latest"]
}

target "slang-yosys-plugin" {
  inherits = ["base-tool"]
  dockerfile = "images/slang-yosys-plugin/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-yosys-plugin-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-yosys-plugin-latest"]
}

# Individual tool targets for tools-level-3
target "gds3d" {
  inherits = ["base-tool"]
  dockerfile = "images/gds3d/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-gds3d-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-gds3d-latest"]
}

target "ngspice" {
  inherits = ["base-tool"]
  dockerfile = "images/ngspice/Dockerfile"
  tags = ["ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspice-latest"]
  cache-from = ["type=registry,ref=ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspice-latest"]
}

# Group targets for tools-level-1 (IHP-focused: removed fpga, kactus2, libman, padring, pulp-tools, riscv, veryl)
group "tools-level-1" {
  targets = [
    "magic", "openvaf", "osic-multitool", "xyce", "covered", "cvc_rv",
    "digital", "gaw3-xschem", "ghdl", "gtkwave", "irsim", "iverilog", "klayout",
    "netgen", "ngspyce", "nvc", "openems", "palace", "surelog", "surfer",
    "qflow", "qucs-s", "slang", "verilator", "xcircuit", "xschem", "yosys",
    "rftoolkit", "openroad", "openroad-librelane"
  ]
}

# Group targets for tools-level-2 (IHP-focused: removed spike)
group "tools-level-2" {
  targets = [
    "open_pdks", "vacask", "ghdl-yosys-plugin", "slang-yosys-plugin"
  ]
  # "xyce-xdm" disabled
}

# Group targets for tools-level-3
group "tools-level-3" {
  targets = [
    "gds3d", "ngspice"
  ]
}
