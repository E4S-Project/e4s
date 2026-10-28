#!/bin/bash

start_section() {
  local section_title="$1"
  export SECTION_ID=$(echo "$section_title" | tr -C 'a-zA-Z0-9' '_')
  echo -e "\e[0Ksection_start:$(date +%s):${SECTION_ID}[collapsed=true]\r\e[0K\e[1;36m${section_title}\e[0m"
}

end_section() {
  echo -e "\e[0Ksection_end:$(date +%s):${SECTION_ID}\r\e[0K"
}

run() {
    echo "$ $@"
    "$@"
}


GREEN_BOLD='\033[1;32m'
YELLOW_BOLD='\033[1;33m'
COLOR_RESET='\033[0m'

process_test_results() {
    local suite_id="$1"
    local suite_title="$2"
    local json_file="$3"
    local test_root="$4"

    local suite_artifacts="${ARTIFACTS}/${suite_id}"

    local -a steps=("setup" "clean" "compile" "run")
    local -a statuses=("pass" "fail")
    local -a run_logs=()
    local -a log_files=()
    local -a step_logs=()

    local -A fail_counts_by_step=()

    local total_passed=0
    local total_failed=0
    local current_count=0

    local passed_tests=""
    local tests=""
    local status=""
    local step=""
    local test_name=""
    local test_dir=""
    local step_dir=""
    local log_file=""
    local count=0

    mkdir -p "${suite_artifacts}/json"
    cp "$json_file" "${suite_artifacts}/json/"

    echo "========================================"
    echo "${suite_title}: Test Results"
    echo "  JSON: $json_file"
    echo "  Artifacts: $suite_artifacts"
    echo "========================================"

    echo -e "${GREEN_BOLD}Successful Tests:${COLOR_RESET}"
    passed_tests=$(./process-json.sh "$json_file")

    if [ -n "$passed_tests" ]; then
        while IFS= read -r test_name; do
            [ -z "$test_name" ] && continue

            total_passed=$((total_passed + 1))
            test_dir="${test_root%/}/$test_name"

            shopt -s nullglob
            run_logs=("$test_dir"/run-*.log)
            shopt -u nullglob

            start_section "${suite_title}: $test_name"

            if [ ${#run_logs[@]} -gt 0 ]; then
                for log_file in "${run_logs[@]}"; do
                    echo -e "${YELLOW_BOLD}--- Tail of $(basename "$log_file") ---${COLOR_RESET}"
                    tail -n 300 "$log_file"
                done
            else
                echo "Warning: No run-*.log files found for $test_name in $test_dir"
            fi

            end_section
        done <<< "$passed_tests"
    else
        echo "  (none)"
    fi

    echo "--------------------------------------"

    for status in "${statuses[@]}"; do
        for step in "${steps[@]}"; do
            tests=$(./process-json.sh "$json_file" "$step" "$status" 2>/dev/null)
            [ -z "$tests" ] && continue

            step_dir="${suite_artifacts}/${status}/${step}"

            echo "-> $step ($status): saving logs to $step_dir"
            mkdir -p "$step_dir"

            while IFS= read -r test_name; do
                [ -z "$test_name" ] && continue

                if [ "$status" = "fail" ]; then
                    current_count="${fail_counts_by_step[$step]:-0}"
                    fail_counts_by_step["$step"]=$((current_count + 1))
                    total_failed=$((total_failed + 1))
                fi

                test_dir="${test_root%/}/$test_name"

                if [ -d "$test_dir" ]; then
                    shopt -s nullglob
                    log_files=("$test_dir"/*.log)
                    shopt -u nullglob

                    if [ ${#log_files[@]} -gt 0 ]; then
                        mkdir -p "$step_dir/$test_name"
                        cp "${log_files[@]}" "$step_dir/$test_name/"
                    else
                        echo "Warning: No .log files found in $test_dir"
                    fi
                else
                    echo "Warning: Test directory $test_dir does not exist"
                fi

                if [ "$status" = "fail" ]; then
                    shopt -s nullglob
                    step_logs=("$test_dir/$step"-*.log)
                    shopt -u nullglob

                    if [ ${#step_logs[@]} -gt 0 ]; then
                        start_section "${suite_title} Failure ($step): $test_name"

                        for log_file in "${step_logs[@]}"; do
                            echo -e "${YELLOW_BOLD}--- Tail of $(basename "$log_file") ---${COLOR_RESET}"
                            tail -n 300 "$log_file"
                        done

                        end_section
                    else
                        echo "Warning: No ${step}-*.log found for failing test $test_name"
                    fi
                fi
            done <<< "$tests"

            echo "--------------------------------------"
        done
    done

    echo "========================================"
    echo "${suite_title^^} SUMMARY"
    echo "  Passed: $total_passed"
    echo "  Failed: $total_failed"

if [ "$total_failed" -gt 0 ]; then
    echo "  Failures by step:"

    for step in "${steps[@]}"; do
        count="${fail_counts_by_step[$step]:-0}"

        if [ "$count" -gt 0 ]; then
            echo "    $step: $count"
        fi
    done
fi

    echo "========================================"

    return 0
}

run_test_suite() {
    local suite_id="$1"
    local suite_title="$2"
    local test_root="$3"
    local test_dir="$4"
    shift 4

    local previous_json=""
    local new_json=""
    local test_exit=0
    local processing_exit=0

    mkdir -p json-outputs

    # Remember what the newest JSON was before this run. This prevents the
    # second test suite from accidentally reusing the first suite's JSON.
    previous_json=$(
        find json-outputs -maxdepth 1 -type f -name '*.json' \
            -printf '%T@ %p\n' 2>/dev/null |
            sort -n |
            tail -n 1 |
            cut -d' ' -f2-
    )

    start_section "Running: ${suite_title}"

    time run ./test-all.sh \
        --json \
        --color-off \
        "$@" \
        "$test_dir"

    test_exit=$?

    end_section

    new_json=$(
        find json-outputs -maxdepth 1 -type f -name '*.json' \
            -printf '%T@ %p\n' 2>/dev/null |
            sort -n |
            tail -n 1 |
            cut -d' ' -f2-
    )

    if [ -z "$new_json" ]; then
        echo -e "${YELLOW_BOLD}ERROR: ${suite_title} produced no JSON output${COLOR_RESET}"
        return 1
    fi

    if [ "$new_json" = "$previous_json" ]; then
        echo -e "${YELLOW_BOLD}ERROR: ${suite_title} did not produce a new JSON file${COLOR_RESET}"
        return 1
    fi

    process_test_results \
        "$suite_id" \
        "$suite_title" \
        "$new_json" \
        "$test_root"

    processing_exit=$?

    if [ "$processing_exit" -ne 0 ]; then
        echo -e "${YELLOW_BOLD}ERROR: Could not process ${suite_title} results${COLOR_RESET}"
    fi

    # Preserve both the test failure and an internal reporting failure.
    return $((test_exit | processing_exit))
}

if [ -z "${ARTIFACTS:-}" ]; then
    echo "ERROR: ARTIFACTS is not set"
    exit 1
fi
mkdir -p "$ARTIFACTS"

echo Ready to run tests for $TEST_TARGET

echo "Saving env to ${ARTIFACTS}/initial-env.txt"
env | sort > "${ARTIFACTS}/initial-env.txt"

    echo "TAU_LIB_PATH=${TAU_LIB_PATH:-<unset>}"
    echo "DYNINST_LIB_PATH=${DYNINST_LIB_PATH:-<unset>}"

#SPACK SKIP TESTS
SKIP_TESTS_ALL_CPU="adios2 openpmd-api umap plumed e4s-alc warpx"
SKIP_TESTS_ALL_CUDA="heffte-cuda adios2-cuda"
SKIP_TESTS_ALL_ROCM=""

SKIP_TESTS_aarch64_rocky_cpu="cabana zfp charliecloud e4s-cl gptune hdf5 hdf5-vol-async umap wps wrf"
SKIP_TESTS_aarch64_rocky_cuda_90=""
SKIP_TESTS_aarch64_rocky_cuda_120=""
SKIP_TESTS_aarch64_ubuntu_cpu="cabana charliecloud darshan-util e4s-cl gptune hdf5 hdf5-vol-async plasma wps wrf"
SKIP_TESTS_aarch64_ubuntu_cuda_90=""
SKIP_TESTS_aarch64_ubuntu_cuda_120=""

#dyninst: static initialization segfaults with libtbbmalloc_proxy. Rebuild without tbb and/or report to devs
SKIP_TESTS_ppc64le_ubuntu_cpu="arborx axom boost dyninst libunwind mercury raja bricks butterflypack darshan-util e4s-alc e4s-cl gasnet hdf5 hdf5-vol-async py-libensemble unifyfs warpx wps wrf libceed"
SKIP_TESTS_ppc64le_ubuntu_cuda_70=""

SKIP_TESTS_x86_64_rocky_cpu="plasma cabana dyninst charliecloud e4s-cl gptune hdf5 hdf5-vol-async variorum warpx wps wrf"
SKIP_TESTS_x86_64_rocky_cuda_90="papi-cuda"
SKIP_TESTS_x86_64_rocky_cuda_120="papi-cuda"
SKIP_TESTS_x86_64_ubuntu_cpu="plasma cabana variorum charliecloud darshan-util e4s-cl gptune hdf5 hdf5-vol-async warpx wps wrf"
SKIP_TESTS_x86_64_ubuntu_cuda_80="papi-cuda libceed-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_90="papi-cuda petsc-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_120="papi-cuda sundials-cuda"

SKIP_TESTS_x86_64_ubuntu_oneapi="cabana charliecloud fortrilinos hpx variorum hdf5-vol-async mercury nekbone plumed stc turbine umap unifyfs"

SKIP_TESTS_x86_64_ubuntu_rocm_90a="heffte-rocm tasmanian-rocm"
SKIP_TESTS_x86_64_ubuntu_rocm_942="amrex-rocm heffte-rocm slate-rocm tasmanian-rocm"

#NON-SPACK SKIP TESTS
SKIP_NONSPACK_aarch64_rocky_cuda_90="tensorflow-cuda"
SKIP_NONSPACK_aarch64_rocky_cuda_120="tensorflow-cuda cv2 jax"
SKIP_NONSPACK_aarch64_ubuntu_cuda_90="tensorflow-cuda"
SKIP_NONSPACK_aarch64_ubuntu_cuda_120="tensorflow-cuda jax"
SKIP_NONSPACK_aarch64_ubuntu_cpu="tensorflow-cuda"

SKIP_NONSPACK_ppc64le_ubuntu_cpu="pytorch pytorch-cuda tensorflow tensorflow-cuda"
SKIP_NONSPACK_ppc64le_ubuntu_cuda_70="pytorch-cuda"

SKIP_NONSPACK_x86_64_ubuntu_cuda_80="tensorflow"
SKIP_NONSPACK_x86_64_ubuntu_cuda_90="tensorflow"
SKIP_NONSPACK_x86_64_ubuntu_rocm_90a="jax tensorflow"



OS_NAME=$( [ -f /etc/os-release ] && source /etc/os-release && echo "$ID" || echo "unknown_os" )
ARCH_NAME=$(arch 2>/dev/null || uname -m)
TARGET_NAME="${TEST_TARGET:-unknown_target}"

PLATFORM_SKIP_NAME="SKIP_TESTS_${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}"
PLATFORM_SKIP_NAME="${PLATFORM_SKIP_NAME//-/_}"
SKIP_TESTS="${!PLATFORM_SKIP_NAME}"

NONSPACK_PLATFORM_SKIP_NAME="SKIP_NONSPACK_${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}"
NONSPACK_PLATFORM_SKIP_NAME="${NONSPACK_PLATFORM_SKIP_NAME//-/_}"
NONSPACK_SKIP_TESTS="${!NONSPACK_PLATFORM_SKIP_NAME}"

case "$TEST_TARGET" in
    cpu|oneapi)
        SKIP_TESTS="${SKIP_TESTS} ${SKIP_TESTS_ALL_CPU}"
        ;;
    *cuda*)
        SKIP_TESTS="${SKIP_TESTS} ${SKIP_TESTS_ALL_CUDA}"
        ;;
    *rocm*)
        SKIP_TESTS="${SKIP_TESTS} ${SKIP_TESTS_ALL_ROCM}"
        ;;
esac

echo "Running on Platform: ${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}"

TEST_MODE_FLAG="--skip-tests"

#Create test-skips.md only on branches where we want to test instead of skip the listed files
if [ -f "test-skips.md" ]; then
    TEST_MODE_FLAG="--test-only"
    echo "Found test-skips.md: Running ONLY target Spack tests: \"$SKIP_TESTS\""
    echo "Running ONLY target non-Spack tests: \"$NONSPACK_SKIP_TESTS\""
else
    echo "Skipping Spack tests: \"$SKIP_TESTS\""

    echo "Skipping non-Spack tests: \"$NONSPACK_SKIP_TESTS\""
fi

if [ -n "$SKIP_TESTS" ]; then
    SKIP_ARG=( "$TEST_MODE_FLAG" "$SKIP_TESTS" )
else
    echo "Warning? No Spack tests skipped."
    SKIP_ARG=()
fi

if [ -n "$NONSPACK_SKIP_TESTS" ]; then
    NONSPACK_SKIP_ARG=("$TEST_MODE_FLAG" "$NONSPACK_SKIP_TESTS")
else
    echo "Warning? No non-Spack tests skipped."
    NONSPACK_SKIP_ARG=()
fi


#Clone the testsuite and enter the directory
run git clone https://github.com/E4S-Project/testsuite.git
run cd testsuite/
#Create subdirectories mapped to test types (cpu_tests, gpu_tests, cuda_tests, rocm_tests)
echo "$ ./make-links.sh"
run ./make-links.sh > /dev/null
TEST_DIR=./cpu_tests/

PROC_ARG=(--processes 1)

case "$TEST_TARGET" in
    "oneapi")
        run ln -sf ./settings.oneapi.sh ./settings.sh
        which mpirun
        which mpiexec
        which mpicc
        run  cat ./settings.sh
        echo "Running OneAPI Tests"
        ;;
    *rocm*)
        TEST_DIR=./rocm_tests/
        echo "Running ROCM Tests"

        ;;
    *cuda*)
        TEST_DIR=./cuda_tests/
        echo "Running CUDA Tests"
        ;;
    "cpu")
        #CPU basted tests should be more parallel-run tolerant
        PROC_ARG=()
        echo "Running CPU Tests"
        ;;
    *)
        echo "Unknown target: $TEST_TARGET"
        ;;
esac

echo "----------------------------------------"
echo "  TEST_DIR = $TEST_DIR"
echo "  PROC_ARG = ${PROC_ARG[*]:-(empty)}"
echo "----------------------------------------"

#We might need to limit the number of processes to avoid contention (--processes 1). Color used to break some ci interfaces but we can experiment with that later as well. Return code is the number of failed tests.

#stdbuf -oL -eL didn't help with live-updating web log

run_test_suite \
    "spack" \
    "Spack Tests for ${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}" \
    "./validation_tests" \
    "$TEST_DIR" \
    "${PROC_ARG[@]}" \
    "${SKIP_ARG[@]}"

SPACK_EXIT=$?



# ==================================================
# Explicit Package Test Coverage Report
# ==================================================
start_section "Coverage Check: Explicitly Installed Packages"

echo -e "${GREEN_BOLD}Checking test coverage for explicitly installed packages...${COLOR_RESET}"

# 1. Store explicit packages in an array
readarray -t EXPLICIT_PKGS < <(spack find --explicit --format "{name}" 2>/dev/null | sort -u)
TOTAL_EXPLICIT=${#EXPLICIT_PKGS[@]}

# 2. Store CUDA and ROCm variant packages in associative arrays
declare -A CUDA_PKGS ROCM_PKGS

while read -r pkg; do [ -n "$pkg" ] && CUDA_PKGS["$pkg"]=1; done < <(spack find --explicit --format "{name}" +cuda 2>/dev/null)
while read -r pkg; do [ -n "$pkg" ] && ROCM_PKGS["$pkg"]=1; done < <(spack find --explicit --format "{name}" +rocm 2>/dev/null)

tested_pkgs=()
missing_tests=()

for pkg in "${EXPLICIT_PKGS[@]}"; do
    target_dir="validation_tests/${pkg}"

    # Pure Bash set lookups—no subshells or grep needed
    if [[ "$TEST_TARGET" == *cuda* ]] && [[ -n "${CUDA_PKGS[$pkg]}" ]]; then
        if [ -d "validation_tests/${pkg}-cuda" ]; then
            target_dir="validation_tests/${pkg}-cuda"
        fi
    elif [[ "$TEST_TARGET" == *rocm* ]] && [[ -n "${ROCM_PKGS[$pkg]}" ]]; then
        if [ -d "validation_tests/${pkg}-rocm" ]; then
            target_dir="validation_tests/${pkg}-rocm"
        fi
    fi

    # Classify coverage
    if [ -d "$target_dir" ]; then
        tested_pkgs+=("$pkg")
    else
        missing_tests+=("$pkg")
    fi
done

echo "========================================"
echo "EXPLICIT PACKAGE TEST COVERAGE SUMMARY"
echo "  Target Platform:             $TEST_TARGET"
echo "  Total Explicit Packages:     $TOTAL_EXPLICIT"
echo "  Packages WITH Tests:         ${#tested_pkgs[@]}"
echo "  Packages MISSING Tests:      ${#missing_tests[@]}"
echo "----------------------------------------"

if [ ${#missing_tests[@]} -gt 0 ]; then
    echo -e "${YELLOW_BOLD}Explicitly installed packages without tests on this target:${COLOR_RESET}"
    for pkg in "${missing_tests[@]}"; do
        echo "  - $pkg"
    done
else
    echo "All explicitly installed packages have corresponding tests for target: $TEST_TARGET"
fi
echo "========================================"

end_section


run_test_suite \
    "non-spack" \
    "Non-Spack Tests" \
    "./non_spack_tests" \
    "./non_spack_tests" \
    --processes 1 \
    "${NONSPACK_SKIP_ARG[@]}"

NONSPACK_EXIT=$?

#if [[ -z "${TAU_LIB_PATH:-}" || ! -d "${TAU_LIB_PATH}" ]]; then
#    echo -e "${YELLOW_BOLD}ERROR: TAU_LIB_PATH is not set to a valid directory: '${TAU_LIB_PATH:-<unset>}'${COLOR_RESET}"
#    NONSPACK_EXIT=1
#fi

#if [[ -z "${DYNINST_LIB_PATH:-}" || ! -d "${DYNINST_LIB_PATH}" ]]; then
#    echo -e "${YELLOW_BOLD}ERROR: DYNINST_LIB_PATH is not set to a valid directory: '${DYNINST_LIB_PATH:-<unset>}'${COLOR_RESET}"
#    NONSPACK_EXIT=1
#fi


FINAL_EXIT=$((SPACK_EXIT | NONSPACK_EXIT))

echo "========================================"
echo "OVERALL TEST SUMMARY"
echo "  Spack suite exit:      $SPACK_EXIT"
echo "  Non-Spack suite exit:  $NONSPACK_EXIT"
echo "  Final exit:            $FINAL_EXIT"
echo "========================================"

exit "$FINAL_EXIT"

