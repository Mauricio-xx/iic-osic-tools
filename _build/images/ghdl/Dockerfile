#######################################################################
# Compile ghdl
#######################################################################
ARG BASE_IMAGE_BUILD=ghcr.io/mauricio-xx/ihp-eda-tools:base-dev
FROM ${BASE_IMAGE_BUILD} AS ghdl
ARG GHDL_REPO_URL="https://github.com/ghdl/ghdl.git"
ARG GHDL_REPO_COMMIT="dc2c18aabaa288919fad7eace3a82c8224e84ff7"
ARG GHDL_NAME="ghdl"
RUN --mount=type=bind,source=images/ghdl,target=/images/ghdl \
    bash /images/ghdl/scripts/install.sh
