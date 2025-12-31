#######################################################################
# Add dev packages to base image 
#######################################################################
ARG BASE_IMAGE_BUILD=ghcr.io/mauricio-xx/ihp-eda-tools:base
FROM ${BASE_IMAGE_BUILD} AS base-dev
RUN --mount=type=bind,source=images/base-dev,target=/images/base-dev \
    bash /images/base-dev/scripts/install.sh
