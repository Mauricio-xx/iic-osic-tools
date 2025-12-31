#######################################################################
# Compile netgen
#######################################################################
ARG BASE_IMAGE_BUILD=ghcr.io/mauricio-xx/ihp-eda-tools:base-dev
FROM ${BASE_IMAGE_BUILD} AS netgen
ARG NETGEN_REPO_URL="https://github.com/rtimothyedwards/netgen.git"
ARG NETGEN_REPO_COMMIT="1.5.313"
ARG NETGEN_NAME="netgen"
RUN --mount=type=bind,source=images/netgen,target=/images/netgen \
    bash /images/netgen/scripts/install.sh
