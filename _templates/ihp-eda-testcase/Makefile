# SPDX-FileCopyrightText: 2025 IHP-EDA-Tools Contributors
# SPDX-License-Identifier: Apache-2.0
#
# Makefile for IHP-EDA-Tools Testcase
# Usage: make [target]

CONTAINER_IMAGE ?= ghcr.io/iic-jku/iic-osic-tools:latest
TESTCASE_DIR := $(shell pwd)
OUTPUT_DIR := $(TESTCASE_DIR)/output

.PHONY: all run validate clean verify docker-run docker-validate help

all: run

# Run testcase locally (requires tools in PATH)
run:
	@echo "Running testcase..."
	@mkdir -p $(OUTPUT_DIR)
	@OUTPUT_DIR=$(OUTPUT_DIR) ./run.sh

# Run validation locally
validate:
	@echo "Validating testcase..."
	@iic-testcase validate . --output $(OUTPUT_DIR)

# Verify testcase structure
verify:
	@echo "Verifying testcase structure..."
	@iic-testcase verify .

# Run testcase in Docker container
docker-run:
	@echo "Running testcase in Docker..."
	@docker run --rm \
		-v "$(TESTCASE_DIR):/testcase:ro" \
		-v "$(OUTPUT_DIR):/output" \
		-e OUTPUT_DIR=/output \
		-e TESTCASE_DIR=/testcase \
		$(CONTAINER_IMAGE) \
		bash -c "cd /testcase && ./run.sh"

# Validate testcase in Docker container
docker-validate:
	@echo "Validating testcase in Docker..."
	@docker run --rm \
		-v "$(TESTCASE_DIR):/testcase:ro" \
		-v "$(OUTPUT_DIR):/output" \
		$(CONTAINER_IMAGE) \
		bash -c "iic-testcase validate /testcase --output /output"

# Clean output files
clean:
	@echo "Cleaning output directory..."
	@rm -rf $(OUTPUT_DIR)

# Show help
help:
	@echo "IHP-EDA-Tools Testcase Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  run             Run testcase locally"
	@echo "  validate        Run and validate testcase locally"
	@echo "  verify          Verify testcase structure"
	@echo "  docker-run      Run testcase in Docker container"
	@echo "  docker-validate Validate testcase in Docker container"
	@echo "  clean           Remove output files"
	@echo "  help            Show this help"
	@echo ""
	@echo "Environment variables:"
	@echo "  CONTAINER_IMAGE Docker image (default: $(CONTAINER_IMAGE))"
	@echo "  OUTPUT_DIR      Output directory (default: ./output)"
