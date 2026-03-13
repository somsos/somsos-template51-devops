#!/bin/bash

# OVERALL
#    I manage 2 levels of logs:
#       [INFO] For important menssages usually showed to the user
#       [DEBUG] For secondary logs, usually to know what happend in spacial cases


# DESCRIPTION
#    Stateless function
#    I manage 2 levels of logs INFO for shirs
# INPUT
#    $1:  last process status obtained with $? just after its execution
#    $2:  line
#    $2:  logline
function print_info_logs {
  if [ $1 -ne 0 ]; then
    echo -e "$2 FAILED\n=========Error logs start============="
    cat $3
    echo -e "=========Error logs finish=============\n"
    exit $1
  fi
  echo -e "$2 Succeeded"
}
