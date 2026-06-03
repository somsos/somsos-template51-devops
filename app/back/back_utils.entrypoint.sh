#set -e
#set -x # show executed lines

# REFERENCE
#       Run by profile
#       mvn test -Dspring.profiles.active=something     # @ActiveProfiles("something") 

echo "ARG-1: \"$1\""
if [[ "$1" != "unitary_tests" && "$1" != "integration_tests" && "$1" != "e2e_tests" ]]; then
    echo "[ERROR]* set first parameter to either \"unitary_tests\", \"integration_tests\", \"e2e_tests\""
    exit 1
fi
TEST_TYPE="$1"
#LOG_FILE="/opt/template51/tests_overall/unitary_tests.log"
#mvn test &>> $LOG_FILE

# TEST_RESULT
echo "[MAIN] Start running unitary tests."

if [[ "$TEST_TYPE" == "unitary_tests" ]]; then
    echo "[MAIN] Running unitary tests."
    mvn test -Dspring.profiles.active=test
    TEST_RESULT=$?
fi

echo "[MAIN] Finished running unitary tests with result: $TEST_RESULT."


exit $TEST_RESULT


echo "http://jenkins.mariomv-local.org/userContent/backend-tests-result.svg"