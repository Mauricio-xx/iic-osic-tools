#######################################################################
# Compile openvaf-reloaded
#######################################################################
ARG BASE_IMAGE_BUILD=ghcr.io/mauricio-xx/ihp-eda-tools:base-dev
FROM ${BASE_IMAGE_BUILD} AS openvaf
ARG OPENVAF_REPO_URL="https://github.com/arpadbuermen/OpenVAF.git"
ARG OPENVAF_REPO_COMMIT="fce38d894b7a8e92a76b8fd76e842eb02cec3659"
ARG OPENVAF_NAME="openvaf"
ENV OPENVAF_NAME=${OPENVAF_NAME}
RUN --mount=type=bind,source=images/openvaf,target=/images/openvaf \
    bash /images/openvaf/scripts/install.sh
