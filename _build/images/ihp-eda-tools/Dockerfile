#######################################################################
# IHP-EDA-TOOLS: Setup individual build images
# IHP-focused container - RISC-V, FPGA, and unused tools removed
#######################################################################
ARG BASE_IMAGE=ghcr.io/mauricio-xx/ihp-eda-tools:base

ARG TOOL_IMAGE_OPEN_PDKS="ghcr.io/mauricio-xx/ihp-eda-tools:tool-open_pdks-latest"
ARG TOOL_IMAGE_COVERED="ghcr.io/mauricio-xx/ihp-eda-tools:tool-covered-latest"
ARG TOOL_IMAGE_DIGITAL="ghcr.io/mauricio-xx/ihp-eda-tools:tool-digital-latest"
ARG TOOL_IMAGE_CVC_RV="ghcr.io/mauricio-xx/ihp-eda-tools:tool-cvc_rv-latest"
ARG TOOL_IMAGE_GAW3_XSCHEM="ghcr.io/mauricio-xx/ihp-eda-tools:tool-gaw3-xschem-latest"
ARG TOOL_IMAGE_GDS3D="ghcr.io/mauricio-xx/ihp-eda-tools:tool-gds3d-latest"
ARG TOOL_IMAGE_GHDL="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-latest"
ARG TOOL_IMAGE_GTKWAVE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-gtkwave-latest"
ARG TOOL_IMAGE_IHP_GMID_KIT="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ihp-gmid-kit-latest"
ARG TOOL_IMAGE_IRSIM="ghcr.io/mauricio-xx/ihp-eda-tools:tool-irsim-latest"
ARG TOOL_IMAGE_IVERILOG="ghcr.io/mauricio-xx/ihp-eda-tools:tool-iverilog-latest"
ARG TOOL_IMAGE_KLAYOUT="ghcr.io/mauricio-xx/ihp-eda-tools:tool-klayout-latest"
ARG TOOL_IMAGE_MAGIC="ghcr.io/mauricio-xx/ihp-eda-tools:tool-magic-latest"
ARG TOOL_IMAGE_NETGEN="ghcr.io/mauricio-xx/ihp-eda-tools:tool-netgen-latest"
ARG TOOL_IMAGE_NVC="ghcr.io/mauricio-xx/ihp-eda-tools:tool-nvc-latest"
ARG TOOL_IMAGE_NGSPICE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspice-latest"
ARG TOOL_IMAGE_NGSPYCE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ngspyce-latest"
ARG TOOL_IMAGE_OPENEMS="ghcr.io/mauricio-xx/ihp-eda-tools:tool-openems-latest"
ARG TOOL_IMAGE_OPENROAD="ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-latest"
ARG TOOL_IMAGE_OPENROAD_LIBRELANE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-openroad-librelane-latest"
ARG TOOL_IMAGE_OSIC_MULTITOOL="ghcr.io/mauricio-xx/ihp-eda-tools:tool-osic-multitool-latest"
ARG TOOL_IMAGE_OPENVAF="ghcr.io/mauricio-xx/ihp-eda-tools:tool-openvaf-latest"
ARG TOOL_IMAGE_PALACE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-palace-latest"
ARG TOOL_IMAGE_QFLOW="ghcr.io/mauricio-xx/ihp-eda-tools:tool-qflow-latest"
ARG TOOL_IMAGE_QUCS_S="ghcr.io/mauricio-xx/ihp-eda-tools:tool-qucs-s-latest"
ARG TOOL_IMAGE_RFTOOLKIT="ghcr.io/mauricio-xx/ihp-eda-tools:tool-rftoolkit-latest"
ARG TOOL_IMAGE_SLANG="ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-latest"
ARG TOOL_IMAGE_SURELOG="ghcr.io/mauricio-xx/ihp-eda-tools:tool-surelog-latest"
ARG TOOL_IMAGE_SURFER="ghcr.io/mauricio-xx/ihp-eda-tools:tool-surfer-latest"
ARG TOOL_IMAGE_VACASK="ghcr.io/mauricio-xx/ihp-eda-tools:tool-vacask-latest"
ARG TOOL_IMAGE_VERILATOR="ghcr.io/mauricio-xx/ihp-eda-tools:tool-verilator-latest"
ARG TOOL_IMAGE_XCIRCUIT="ghcr.io/mauricio-xx/ihp-eda-tools:tool-xcircuit-latest"
ARG TOOL_IMAGE_XSCHEM="ghcr.io/mauricio-xx/ihp-eda-tools:tool-xschem-latest"
ARG TOOL_IMAGE_XYCE="ghcr.io/mauricio-xx/ihp-eda-tools:tool-xyce-latest"
ARG TOOL_IMAGE_YOSYS="ghcr.io/mauricio-xx/ihp-eda-tools:tool-yosys-latest"
ARG TOOL_IMAGE_GHDL_YOSYS_PLUGIN="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-yosys-plugin-latest"
ARG TOOL_IMAGE_SLANG_YOSYS_PLUGIN="ghcr.io/mauricio-xx/ihp-eda-tools:tool-slang-yosys-plugin-latest"

FROM ${TOOL_IMAGE_OPEN_PDKS} AS open_pdks
FROM ${TOOL_IMAGE_COVERED} AS covered
FROM ${TOOL_IMAGE_DIGITAL} AS digital
FROM ${TOOL_IMAGE_CVC_RV} AS cvc_rv
FROM ${TOOL_IMAGE_GAW3_XSCHEM} AS gaw3-xschem
FROM ${TOOL_IMAGE_GDS3D} AS gds3d
FROM ${TOOL_IMAGE_GHDL} AS ghdl
FROM ${TOOL_IMAGE_GTKWAVE} AS gtkwave
FROM ${TOOL_IMAGE_IHP_GMID_KIT} AS ihp-gmid-kit
FROM ${TOOL_IMAGE_IRSIM} AS irsim
FROM ${TOOL_IMAGE_IVERILOG} AS iverilog
FROM ${TOOL_IMAGE_KLAYOUT} AS klayout
FROM ${TOOL_IMAGE_MAGIC} AS magic
FROM ${TOOL_IMAGE_NETGEN} AS netgen
FROM ${TOOL_IMAGE_NVC} AS nvc
FROM ${TOOL_IMAGE_NGSPICE} AS ngspice
FROM ${TOOL_IMAGE_NGSPYCE} AS ngspyce
FROM ${TOOL_IMAGE_OPENEMS} AS openems
FROM ${TOOL_IMAGE_OPENROAD} AS openroad
FROM ${TOOL_IMAGE_OPENROAD_LIBRELANE} AS openroad-librelane
FROM ${TOOL_IMAGE_OSIC_MULTITOOL} AS osic-multitool
FROM ${TOOL_IMAGE_OPENVAF} AS openvaf
FROM ${TOOL_IMAGE_PALACE} AS palace
FROM ${TOOL_IMAGE_QFLOW} AS qflow
FROM ${TOOL_IMAGE_QUCS_S} AS qucs-s
FROM ${TOOL_IMAGE_RFTOOLKIT} AS rftoolkit
FROM ${TOOL_IMAGE_SLANG} AS slang
FROM ${TOOL_IMAGE_SURELOG} AS surelog
FROM ${TOOL_IMAGE_SURFER} AS surfer
FROM ${TOOL_IMAGE_VACASK} AS vacask
FROM ${TOOL_IMAGE_VERILATOR} AS verilator
FROM ${TOOL_IMAGE_XCIRCUIT} AS xcircuit
FROM ${TOOL_IMAGE_XSCHEM} AS xschem
FROM ${TOOL_IMAGE_XYCE} AS xyce
FROM ${TOOL_IMAGE_YOSYS} AS yosys
FROM ${TOOL_IMAGE_GHDL_YOSYS_PLUGIN} AS ghdl-yosys-plugin
FROM ${TOOL_IMAGE_SLANG_YOSYS_PLUGIN} AS slang-yosys-plugin

#######################################################################
# Final output container
#######################################################################
FROM ${BASE_IMAGE} AS iic-osic-tools
ARG CONTAINER_TAG=unknown
ENV IIC_OSIC_TOOLS_VERSION=${CONTAINER_TAG}

# Copy all layers into the final container
COPY --link --from=open_pdks                    ${PDK_ROOT}/                    ${PDK_ROOT}/
COPY --link --from=covered                      ${TOOLS}/covered                ${TOOLS}/covered/
COPY --link --from=digital                      ${TOOLS}/digital                ${TOOLS}/digital/
COPY --link --from=cvc_rv                       ${TOOLS}/cvc_rv                 ${TOOLS}/cvc_rv/
COPY --link --from=gaw3-xschem                  ${TOOLS}/gaw3-xschem            ${TOOLS}/gaw3-xschem/
COPY --link --from=gds3d                        ${TOOLS}/gds3d                  ${TOOLS}/gds3d/
COPY --link --from=gds3d                        ${PDK_ROOT}/                    ${PDK_ROOT}/
COPY --link --from=ghdl                         ${TOOLS}/ghdl                   ${TOOLS}/ghdl/
COPY --link --from=gtkwave                      ${TOOLS}/gtkwave                ${TOOLS}/gtkwave/
COPY --link --from=ihp-gmid-kit                 ${TOOLS}/ihp-gmid-kit           ${TOOLS}/ihp-gmid-kit/
COPY --link --from=irsim                        ${TOOLS}/irsim                  ${TOOLS}/irsim/
COPY --link --from=iverilog                     ${TOOLS}/iverilog               ${TOOLS}/iverilog/
COPY --link --from=klayout                      ${TOOLS}/klayout                ${TOOLS}/klayout/
COPY --link --from=magic                        ${TOOLS}/magic                  ${TOOLS}/magic/
COPY --link --from=netgen                       ${TOOLS}/netgen                 ${TOOLS}/netgen/
COPY --link --from=nvc                          ${TOOLS}/nvc                    ${TOOLS}/nvc/
COPY --link --from=ngspice                      ${TOOLS}/ngspice                ${TOOLS}/ngspice/
COPY --link --from=ngspyce                      ${TOOLS}/ngspyce                ${TOOLS}/ngspyce/
COPY --link --from=openems                      ${TOOLS}/openems                ${TOOLS}/openems/
COPY --link --from=openroad                     ${TOOLS}/openroad               ${TOOLS}/openroad/
COPY --link --from=openroad-librelane           ${TOOLS}/openroad-librelane     ${TOOLS}/openroad-librelane/
COPY --link --from=osic-multitool               ${TOOLS}/osic-multitool         ${TOOLS}/osic-multitool/
COPY --link --from=openvaf                      ${TOOLS}/openvaf                ${TOOLS}/openvaf/
COPY --link --from=palace                       ${TOOLS}/palace                 ${TOOLS}/palace/
COPY --link --from=qflow                        ${TOOLS}/qflow                  ${TOOLS}/qflow/
COPY --link --from=qucs-s                       ${TOOLS}/qucs-s                 ${TOOLS}/qucs-s/
COPY --link --from=rftoolkit                    ${TOOLS}/rftoolkit              ${TOOLS}/rftoolkit/
COPY --link --from=slang                        ${TOOLS}/slang                  ${TOOLS}/slang/
COPY --link --from=surelog                      ${TOOLS}/surelog                ${TOOLS}/surelog/
COPY --link --from=surfer                       ${TOOLS}/surfer                 ${TOOLS}/surfer/
COPY --link --from=vacask                       ${TOOLS}/vacask                 ${TOOLS}/vacask/
COPY --link --from=verilator                    ${TOOLS}/verilator              ${TOOLS}/verilator/
COPY --link --from=xcircuit                     ${TOOLS}/xcircuit               ${TOOLS}/xcircuit/
COPY --link --from=xschem                       ${TOOLS}/xschem                 ${TOOLS}/xschem/
COPY --link --from=xyce                         ${TOOLS}/xyce                   ${TOOLS}/xyce/
COPY --link --from=yosys                        ${TOOLS}/yosys                  ${TOOLS}/yosys/
COPY --link --from=ghdl-yosys-plugin            ${TOOLS}_add/yosys/             ${TOOLS}/yosys/
COPY --link --from=slang-yosys-plugin           ${TOOLS}_add/yosys/             ${TOOLS}/yosys/

# Copy tool version file
COPY tool_metadata.yml /

# Copy EDA skeleton into image
COPY images/ihp-eda-tools/skel /

# Install EDA packages from Python, NPM, and GEM; install examples; install KLayout add-ons
RUN bash /headless/scripts/install_eda.sh && \
    git clone --depth=1 https://github.com/mole99/ota-5t.git ${EXAMPLES}/cace/ota-5t && \
    git clone --depth=1 https://github.com/iic-jku/analog-circuit-design ${EXAMPLES}/analog-course && \
    bash /headless/scripts/install_klayout.sh && \
    bash /headless/scripts/install_links.sh && \
    chmod 755 /tool_metadata.yml && \
    chmod -R 777 /headless && \
    find /headless -type f -not -name "*.sh" -exec chmod 666 {} \; && \
    find /usr/share -type f -name "*.desktop" -exec chmod 644 {} \; && \
    find /usr/share -type f -name "iic*" -exec chmod 644 {} \; && \
    chmod -R 755 /foss/examples && \
    find /foss/examples -type f -not -name "*.sh" -exec chmod 644 {} \; && \
    chmod -R 755 /foss/tools/sak && \
    sed -i 's/__YOSYS_NAMESPACE_RTLIL_Design__std_vector_string_//' /usr/local/lib/python3.12/dist-packages/librelane/scripts/pyosys/ys_common.py
#FIXME Above line to be removed when LibreLane is fixed (dependency issue with newer pyosys versions)

# Metadata labels
LABEL org.opencontainers.image.authors="Harald Pretl <harald.pretl@jku.at>; Georg Zachl <georg.zachl@jku.at>" \
      org.opencontainers.image.url="https://github.com/iic-jku/iic-osic-tools" \
      org.opencontainers.image.documentation="https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/README.md" \
      org.opencontainers.image.source="https://github.com/iic-jku/IIC-OSIC-TOOLS" \
      org.opencontainers.image.version="${CONTAINER_TAG}" \
      org.opencontainers.image.vendor="Department for Integrated Circuits" \
      org.opencontainers.image.licenses=" Apache-2.0" \
      org.opencontainers.image.ref.name="${CONTAINER_TAG}" \
      org.opencontainers.image.title="IHP-EDA-Tools: Open Source IC Tools for IHP PDK" \
      org.opencontainers.image.description="IHP-EDA-Tools is an IHP-focused Docker container for open-source IC design, supporting analog and digital circuit flows with the IHP SG13G2 PDK."

USER 1000:1000
