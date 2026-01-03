#!/bin/bash
# SPDX-FileCopyrightText: 2024-2025 Harald Pretl
# Johannes Kepler University, Department for Integrated Circuits
# SPDX-License-Identifier: Apache-2.0
#
# Run all tests (checks) in the subdirectories using a specified Docker image.
# Optionally run testcases from the testcase infrastructure.
#
# Usage: run_docker_tests.sh <image-tag> [--testcases] [--testcases-only]

usage() {
    echo "Usage: $0 <image-tag> [options]"
    echo ""
    echo "Options:"
    echo "  --testcases       Also run testcases from /foss/testcases"
    echo "  --testcases-only  Only run testcases, skip regular tests"
    echo ""
    echo "Example:"
    echo "  $0 hpretl/iic-osic-tools:latest"
    echo "  $0 hpretl/iic-osic-tools:latest --testcases"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

FULL_TAG=$1
shift

RUN_TESTS=1
RUN_TESTCASES=0

# Parse options
while [ $# -gt 0 ]; do
    case "$1" in
        --testcases)
            RUN_TESTCASES=1
            shift
            ;;
        --testcases-only)
            RUN_TESTS=0
            RUN_TESTCASES=1
            shift
            ;;
        *)
            echo "[ERROR] Unknown option: $1"
            usage
            ;;
    esac
done

RAND=$(hexdump -e '/1 "%02x"' -n4 < /dev/urandom)
CONTAINER_NAME=iic-osic-tools_test${RAND}
CMD=_run_tests_${RAND}.sh
WORKDIR=/foss/designs


mkdir -p "runs/${RAND}"

# Check if newer image is available and pull if needed
docker pull --quiet "$FULL_TAG" > /dev/null

# Create the test runner script
cat <<EOL > "$CMD"
#!/bin/bash
ERRORS=0

# Run regular tests
if [ "$RUN_TESTS" -eq 1 ]; then
    echo "========================================"
    echo "[INFO] Running regression tests..."
    echo "========================================"
    find $WORKDIR -type f -name "test*.sh" -exec parallel --halt soon,fail=1 ::: {} +
    if [ \$? -ne 0 ]; then
        echo "[ERROR] Regression tests failed"
        ERRORS=\$((ERRORS + 1))
    else
        echo "[INFO] Regression tests passed"
    fi
fi

# Run testcases
if [ "$RUN_TESTCASES" -eq 1 ]; then
    echo "========================================"
    echo "[INFO] Running testcase validation..."
    echo "========================================"
    if command -v iic-testcase >/dev/null 2>&1; then
        # Run validation testcases
        for tc in /foss/testcases/validation/*/; do
            for subdir in "\$tc"*/; do
                if [ -f "\$subdir/testcase.yaml" ]; then
                    echo "[INFO] Validating: \$subdir"
                    if iic-testcase run "\$subdir" --output "/tmp/testcase-output-\$\$" 2>&1; then
                        echo "[PASS] \$subdir"
                    else
                        echo "[FAIL] \$subdir"
                        ERRORS=\$((ERRORS + 1))
                    fi
                fi
            done
        done
    else
        echo "[WARN] iic-testcase not found, skipping testcase validation"
    fi
fi

# Summary
echo ""
echo "========================================"
if [ \$ERRORS -eq 0 ]; then
    echo "[INFO] All tests passed successfully :-)"
    echo "========================================"
    exit 0
else
    echo "[ERROR] \$ERRORS test(s) failed :-("
    echo "========================================"
    exit 1
fi
EOL
chmod +x "$CMD"

# Now run the actual tests
docker run -it --rm --name "$CONTAINER_NAME" --user "$(id -u):$(id -g)" -e DISPLAY= -e RAND=$RAND -v "$PWD":$WORKDIR:rw "$FULL_TAG" -s "$WORKDIR/$CMD"

# Cleanup
rm -f "$CMD"
