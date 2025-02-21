#!/bin/bash
#
# Test-specific evaluator
#   - stub, season to taste
#

while getopts '' flag
do
    case ${flag} in
        *) print_usage;;
    esac
done

test=${@:$OPTIND+0:1}
tstdir=${@:$OPTIND+1:1}
wrkdir=${@:$OPTIND+2:1}

#printf "evaluate(test)  : $test\n"
#printf "evaluate(tstdir): $tstdir\n"
#printf "evaluate(wrkdir): $wrkdir\n"

#printf "Running a test006-specific evaluator\n"

(
    cd ${wrkdir}

    #
    # Look for any stderr output during runtime
    #
    rc=$(strip_out_stderr.sh podman.log | wc -l)
    if [ $rc != 0 ]
    then
        echo >&2 "Command had runtime errors"
        exit 2
    fi

    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files in the container -- see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test006
    #
    # Typical
    #
    # who -b
    #   system boot  Jan 23 16:46      "%b %d %H:%M"
    #   system boot  2024-01-23 11:46  "2024-%m-%d %H:%M"
    #
    # uptime -s
    #   2024-01-23 16:46:40
    #
    # last reboot (/var/log/wtmp?)            "%a %b %d" "%H:%M"
    #   reboot   system boot  4.18.0-513.11.1. Tue Jan 23 16:46   still running
    #   reboot   system boot  4.18.0-513.18.1. Wed Apr  3 16:18   still running
    #
    # post_test.sh grabs "uptime -s" as
    #   - DATE, TIME
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}  # this should be DATE & TIME
    do
        eval ${var}
    done

    #
    # Reformat DATE & TIME for "who"
    #
    WATE="$(date --utc --date=${DATE} +'%b %d')"
    EATE="$(date --utc --date=${DATE} +'%b %e')"
    WINE="$(date --utc --date=${TIME} +'%H:%M')"

    #echo "The WATE is ${WATE}"
    #echo "The WINE is ${WINE}"

    (strip_out_stdout.sh podman.log | grep "${DATE}" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "${EATE}" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "${WATE}" > /dev/null)
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find the date \"$DATE\", \"${WATE}\", or \"${EATE}\", in stdout"
        exit 2
    fi

    (strip_out_stdout.sh podman.log | grep "${TIME}" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "${WINE}" > /dev/null)
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find the time \"$TIME\", or \"${WINE}\", in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
