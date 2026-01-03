#!/bin/bash
set -e
export SCRIPT_DIR=$TOOLS/osic-multitool
cd /tmp || exit 1

if [ ! -d "$PDK_ROOT" ]; then
    mkdir -p "$PDK_ROOT"
fi

# install IHP-SG13G2
PDK="ihp-sg13g2"

# Clone from official IHP repository, dev branch
git clone --branch dev --recurse-submodules https://github.com/IHP-GmbH/IHP-Open-PDK.git ihp
cd ihp || exit 1

# now move to the proper location
if [ -d $PDK ]; then
	mv $PDK "$PDK_ROOT/$PDK"
fi

# store git hash of installed PDK version for reference
PDK_COMMIT=$(git rev-parse HEAD)
echo "$PDK_COMMIT" > "${PDK_ROOT}/${PDK}/COMMIT"

# compile the additional Verilog-A models
cd "$PDK_ROOT/$PDK/libs.tech/verilog-a" || exit 1
# ngspice
export PATH="$TOOLS/openvaf/bin:$PATH"
sed -i 's/\bopenvaf\b/& --target_cpu generic/' openvaf-compile-va.sh
chmod +x openvaf-compile-va.sh
./openvaf-compile-va.sh
# xyce
export PATH="$TOOLS/xyce/bin:$PATH"
chmod +x adms-compile-va.sh
./adms-compile-va.sh
if [ ! -f ../xyce/plugins/Xyce_Plugin_PSP103_VA.so ] || [ ! -f ../xyce/plugins/Xyce_Plugin_r3_cmc.so ]; then
    echo "[ERROR] ADMS model compilation for Xyce failed!"
    exit 1
fi

# Add custom bindkeys for Magic
echo "# Custom bindkeys for ICD" 		        >> "$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"
echo "source $SCRIPT_DIR/iic-magic-bindkeys" 	>> "$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc"

# Patch LibreLane config.tcl for LibreLane 2.x compatibility
# The PDK uses PDN_* naming but LibreLane 2.x expects FP_PDN_*
LIBRELANE_CONFIG="$PDK_ROOT/$PDK/libs.tech/librelane/config.tcl"
if [ -f "$LIBRELANE_CONFIG" ]; then
    cat >> "$LIBRELANE_CONFIG" << 'EOF'

# LibreLane 2.x compatibility patch
# Maps PDN_* variables to FP_PDN_* naming convention
set ::env(FILL_CELL) "sg13g2_fill_*"
set ::env(DECAP_CELL) "sg13g2_decap_*"
set ::env(WELLTAP_CELL) ""
set ::env(ENDCAP_CELL) ""
set ::env(FP_PDN_RAIL_OFFSET) $::env(PDN_RAIL_OFFSET)
set ::env(FP_PDN_RAIL_WIDTH) 0.44
set ::env(FP_PDN_RAIL_LAYER) $::env(PDN_RAIL_LAYER)
set ::env(FP_PDN_HORIZONTAL_LAYER) $::env(PDN_HORIZONTAL_LAYER)
set ::env(FP_PDN_VERTICAL_LAYER) $::env(PDN_VERTICAL_LAYER)
set ::env(FP_PDN_VWIDTH) $::env(PDN_VWIDTH)
set ::env(FP_PDN_VSPACING) $::env(PDN_VSPACING)
set ::env(FP_PDN_VPITCH) $::env(PDN_VPITCH)
set ::env(FP_PDN_VOFFSET) $::env(PDN_VOFFSET)
set ::env(FP_PDN_HWIDTH) $::env(PDN_HWIDTH)
set ::env(FP_PDN_HSPACING) $::env(PDN_HSPACING)
set ::env(FP_PDN_HPITCH) $::env(PDN_HPITCH)
set ::env(FP_PDN_HOFFSET) $::env(PDN_HOFFSET)
set ::env(FP_PDN_CORE_RING_VWIDTH) $::env(PDN_CORE_RING_VWIDTH)
set ::env(FP_PDN_CORE_RING_HWIDTH) $::env(PDN_CORE_RING_HWIDTH)
set ::env(FP_PDN_CORE_RING_VSPACING) $::env(PDN_CORE_RING_VSPACING)
set ::env(FP_PDN_CORE_RING_HSPACING) $::env(PDN_CORE_RING_HSPACING)
set ::env(FP_PDN_CORE_RING_VOFFSET) $::env(PDN_CORE_RING_VOFFSET)
set ::env(FP_PDN_CORE_RING_HOFFSET) $::env(PDN_CORE_RING_HOFFSET)

# Source the standard cell library config (contains LIB, STA_CORNERS, DEFAULT_CORNER)
source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/config.tcl"
EOF
    echo "[INFO] LibreLane 2.x compatibility patch applied to config.tcl"
fi

# remove testing folders to save space
cd "$PDK_ROOT/$PDK"
find . -name "testing" -print0 | xargs -0 rm -rf

# remove mdm files from doc folder to save space
cd "$PDK_ROOT/$PDK/libs.doc"
find . -name "*.mdm" -print0 | xargs -0 rm -rf

# remove measurement folder to save space
rm -rf "$PDK_ROOT/$PDK/libs.doc/meas"

#FIXME gzip Liberty (.lib) files
#FIXME cd "$PDK_ROOT/$PDK/libs.ref"
#FIXME find . -name "*.lib" -exec gzip {} \;
