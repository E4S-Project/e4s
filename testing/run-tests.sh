#!/bin/bash

function start_section() {
  local section_title="$1"
  export SECTION_ID=$(echo "$section_title" | tr -C 'a-zA-Z0-9' '_')
  echo -e "\e[0Ksection_start:$(date +%s):${SECTION_ID}[collapsed=true]\r\e[0K\e[1;36m${section_title}\e[0m"
  set -x
}

function end_section() {
  set +x
  echo -e "\e[0Ksection_end:$(date +%s):${SECTION_ID}\r\e[0K"
}


echo Ready to run tests for $TEST_TARGET


SKIP_TESTS_aarch64_rocky_cpu="cabana dyninst tau zfp charliecloud e4s-alc e4s-cl gptune hdf5 hdf5-vol-async plumed umap wps wrf gotcha"
SKIP_TESTS_aarch64_rocky_cuda_90="zfp-cuda amrex-cuda heffte-cuda hypre-cuda petsc-cuda raja-cuda strumpack-cuda sundials-cuda tasmanian-cuda"
SKIP_TESTS_aarch64_rocky_cuda_120="amrex-cuda zfp-cuda heffte-cuda petsc-cuda sundials-cuda"
SKIP_TESTS_aarch64_ubuntu_cpu="cabana dyninst tau charliecloud darshan-util e4s-alc e4s-cl gotcha gptune hdf5 hdf5-vol-async plasma plumed umap wps wrf gotcha"
SKIP_TESTS_aarch64_ubuntu_cuda_90="amrex-cuda heffte-cuda hypre-cuda raja-cuda strumpack-cuda sundials-cuda tasmanian-cuda"
SKIP_TESTS_aarch64_ubuntu_cuda_120="amrex-cuda heffte-cuda petsc-cuda slate-cuda sundials-cuda"
SKIP_TESTS_x86_64_rocky_cpu="cabana dyninst tau bricks charliecloud e4s-alc e4s-cl gptune hdf5 hdf5-vol-async plumed umap variorum warpx wps wrf gotcha"
SKIP_TESTS_x86_64_rocky_cuda_90="heffte-cuda papi-cuda petsc-cuda sundials-cuda amrex-cuda"
SKIP_TESTS_x86_64_rocky_cuda_120="heffte-cuda papi-cuda petsc-cuda sundials-cuda"
SKIP_TESTS_x86_64_ubuntu_cpu="cabana dyninst tau variorum bricks charliecloud darshan-util e4s-alc e4s-cl gptune hdf5 hdf5-vol-async plasma plumed umap warpx wps wrf gotcha"
SKIP_TESTS_x86_64_ubuntu_cuda_80="heffte-cuda papi-cuda petsc-cuda sundials-cuda amrex-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_90="heffte-cuda papi-cuda sundials-cuda amrex-cuda"
SKIP_TESTS_x86_64_ubuntu_cuda_120="heffte-cuda kokkos-kernels-cuda papi-cuda petsc-cuda sundials-cuda"
SKIP_TESTS_x86_64_ubuntu_rocm_942="amrex-rocm hypre-rocm magma-rocm umpire-rocm heffte-rocm slate-rocm tasmanian-rocm"





#Clone the testsuite and enter the directory
git clone https://github.com/E4S-Project/testsuite.git
cd testsuite/
#Create subdirectories mapped to test types (cpu_tests, gpu_tests, cuda_tests, rocm_tests)
./make-links.sh > /dev/null
TEST_DIR=./cpu_tests/

PROC_ARG=(--processes 1)

case "$TEST_TARGET" in
    "oneapi")
        ln -sf ./settings.oneapi.sh ./settings.sh
        which mpirun
        which mpiexec
        which mpicc
        cat ./settings.sh
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



OS_NAME=$( [ -f /etc/os-release ] && source /etc/os-release && echo "$ID" || echo "unknown_os" )
ARCH_NAME=$(arch 2>/dev/null || uname -m)
TARGET_NAME="${TEST_TARGET:-unknown_target}"

PLATFORM_SKIP_NAME="SKIP_TESTS_${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}"
PLATFORM_SKIP_NAME="${PLATFORM_SKIP_NAME//-/_}"
SKIP_TESTS="${!PLATFORM_SKIP_NAME}"

echo "Running on Platform: ${ARCH_NAME}_${OS_NAME}_${TARGET_NAME}"
echo "Skipping tests: \"$SKIP_TESTS\""


if [ -n "$SKIP_TESTS" ]; then
    SKIP_ARG=( --skip-tests "$SKIP_TESTS" )
else
    echo "Warning? Skipping nothing."
    SKIP_ARG=()
fi

#We might need to limit the number of processes to avoid contention (--processes 1). Color used to break some ci interfaces but we can experiment with that later as well. Return code is the number of failed tests.

start_section "Running: time stdbuf -oL -eL ./test-all.sh --json  --color-off ${PROC_ARG[@]}  ${SKIP_ARG[@]}  $TEST_DIR"

time stdbuf -oL -eL ./test-all.sh --json --color-off "${PROC_ARG[@]}"  "${SKIP_ARG[@]}"  "$TEST_DIR"
TESTEXIT=$?

end_section

json_files=(json-outputs/*.json)
JSON_FILE="${json_files[0]}"
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: No JSON files found in json-outputs/"
    exit 1
fi

cp $JSON_FILE $ARTIFACTS

# Define ANSI color codes
GREEN_BOLD='\033[1;32m'
COLOR_RESET='\033[0m'

printf "${GREEN_BOLD}"
echo "Successful Tests:"
./process-json.sh "$JSON_FILE"
printf "${COLOR_RESET}"

STEPS=("setup" "clean" "compile" "run")
all_failed_tests=()
for step in "${STEPS[@]}"; do
    #echo "Checking failed tests for step: $step..."

    failed_tests=$(./process-json.sh "$JSON_FILE" "$step" "fail" 2>/dev/null)

    if [ -n "$failed_tests" ]; then
        step_dir="$ARTIFACTS/$step"
        echo "-> $step Failures found! Creating directory: $step_dir for:"
        echo "$failed_tests"
        mkdir -p "$step_dir"

        # Read each failed test name line-by-line
        while IFS= read -r test_name; do
            # Skip empty lines
            [ -z "$test_name" ] && continue
            all_failed_tests+=("$test_name")

            test_dir="./validation_tests/$test_name"
            
            if [ -d "$test_dir" ]; then
                # Use subshell and 'nullglob' to prevent cp errors if no .log files exist
                (
                    shopt -s nullglob
                    log_files=("$test_dir"/*.log)
                    
                    if [ ${#log_files[@]} -gt 0 ]; then
                        echo "   Copying logs for: $test_name"
                        mkdir -p "$step_dir"/"$test_name"
                        cp "${log_files[@]}" "$step_dir"/"$test_name"
                    else
                        echo "   Warning: No .log files found in $test_dir"
                    fi
                )
            else
                echo "   Warning: Test directory $test_dir does not exist!"
            fi

            step_logs=("$test_dir/$step"-*.log)

                    if [ ${#step_logs[@]} -gt 0 ]; then
                        start_section "Failure Log ($step): $test_name"

                        for log_file in "${step_logs[@]}"; do
                            echo -e "\e[1;33m--- Tail of $(basename "$log_file") ---\e[0m"
                            tail -n 300 "$log_file"
                        done

                        end_section
                    fi

        done <<< "$failed_tests"
    #else
    #    echo "-> No failures for $step."
    echo "--------------------------------------"
    fi
    
done

if [ ${#all_failed_tests[@]} -gt 0 ]; then
    # Flatten the array elements into a single space-separated string
    failing_tests_str="${all_failed_tests[*]}"

    # Print a single clean line you can copy-paste to the top of this script
    echo "${PLATFORM_SKIP_NAME}=\"$failing_tests_str\""
fi

#echo "Logs processed."


exit $TESTEXIT