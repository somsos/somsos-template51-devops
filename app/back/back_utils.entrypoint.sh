set -e
#set -x # show executed lines

# REFERENCE
#       Run by profile
#       mvn test -Dspring.profiles.active=something     # @ActiveProfiles("something") 

echo "ARG-1: \"$1\""
if [[ "$1" != "unitary_tests" && "$1" != "integration_tests" && "$1" != "e2e_tests" ]]; then
    echo "[ERROR]* set first parameter to either \"unitary_tests\", \"integration_tests\", \"e2e_tests\""
    exit 1
fi

if [[ "$1" == "unitary_tests" ]]; then
    #LOG_FILE="/opt/template51/tests_overall/unitary_tests.log"
    echo -e "\033[38;5;27;48;5;231m [MAIN] Start running unitary tests. \033[0m"
    #mvn test &>> $LOG_FILE
    mvn test -Dspring.profiles.active=test
    echo -e "\033[38;5;27;48;5;231m [MAIN] END running unitary tests. \033[0m"
fi


echo "http://jenkins.mariomv-local.org/userContent/backend-tests-result.svg"