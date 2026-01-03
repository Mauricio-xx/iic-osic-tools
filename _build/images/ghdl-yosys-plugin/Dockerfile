#######################################################################
# Compile Yosys GHDL plugin
#######################################################################
ARG BASE_IMAGE_BUILD="ghcr.io/mauricio-xx/ihp-eda-tools:base-dev"
ARG TOOL_IMAGE_YOSYS="ghcr.io/mauricio-xx/ihp-eda-tools:tool-yosys-latest"
ARG TOOL_IMAGE_GHDL="ghcr.io/mauricio-xx/ihp-eda-tools:tool-ghdl-latest"
FROM ${TOOL_IMAGE_YOSYS} AS yosys
FROM ${TOOL_IMAGE_GHDL} AS ghdl
FROM ${BASE_IMAGE_BUILD} AS ghdl-yosys-plugin
ARG GHDL_YOSYS_PLUGIN_REPO_URL="https://github.com/ghdl/ghdl-yosys-plugin.git"
ARG GHDL_YOSYS_PLUGIN_REPO_COMMIT="ad5be7439eb4331343e26f9199d3678985088fed"
ARG GHDL_YOSYS_PLUGIN_NAME="ghdl-yosys-plugin"
COPY --from=yosys	${TOOLS}    ${TOOLS}
COPY --from=ghdl	${TOOLS}    ${TOOLS}
RUN --mount=type=bind,source=images/ghdl-yosys-plugin,target=/images/ghdl-yosys-plugin \
    bash /images/ghdl-yosys-plugin/scripts/install.sh
