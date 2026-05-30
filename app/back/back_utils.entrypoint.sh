set -e
#set -x # show executed lines

echo "ARG-1: \"$1\""
if [[ "$1" != "unitary_tests" && "$1" != "integration_tests" && "$1" != "e2e_tests" ]]; then
    echo "[ERROR]* set first parameter to either \"unitary_tests\", \"integration_tests\", \"e2e_tests\""
    exit 1
fi

# Run by profile
# mvn test -Dspring.profiles.active=something     # @ActiveProfiles("something") 

if [[ "$1" == "unitary_tests" ]]; then
    LOG_FILE="/opt/template51/tests_overall/unitary_tests.log"
    echo -e "\033[38;5;27;48;5;231m [MAIN] Start running unitary tests. \033[0m"
    mvn test &>> $LOG_FILE #& MVN_PID=$!
    #tail -f --pid=$MVN_PID $LOG_FILE
    echo -e "\033[38;5;27;48;5;231m [MAIN] END running unitary tests. \033[0m"
fi


