#######################################################################
# Install Digital - Logic Designer and Circuit Simulator
#######################################################################
ARG BASE_IMAGE_BUILD=registry.iic.jku.at:5000/iic-osic-tools:base-dev
FROM ${BASE_IMAGE_BUILD} AS digital
ARG DIGITAL_REPO_URL="https://github.com/Mauricio-xx/digital-designer.git"
ARG DIGITAL_REPO_COMMIT="master"
ARG DIGITAL_NAME="digital"
RUN --mount=type=bind,source=images/digital,target=/images/digital \
    bash /images/digital/scripts/install.sh
