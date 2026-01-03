#######################################################################
# Install IHP gm/ID Design Kit
#######################################################################
ARG BASE_IMAGE_BUILD=ghcr.io/mauricio-xx/ihp-eda-tools:base-dev
FROM ${BASE_IMAGE_BUILD} AS ihp-gmid-kit
ARG IHP_GMID_KIT_REPO_URL="https://github.com/Mauricio-xx/ihp-gmid-kit.git"
ARG IHP_GMID_KIT_REPO_COMMIT="master"
ARG IHP_GMID_KIT_NAME="ihp-gmid-kit"
RUN --mount=type=bind,source=images/ihp-gmid-kit,target=/images/ihp-gmid-kit \
    bash /images/ihp-gmid-kit/scripts/install.sh
