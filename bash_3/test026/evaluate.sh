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

#printf "Running a test001-specific evaluator\n"

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
    # Might touch /tmp
    #
    sed -e '/^C \/tmp$/d' \
        -i.bak diff.log

    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory"
        exit 2
    fi

    #
    # Test026
    #
    # Typical
    # 
    #   ./bash.sh 2000-02-29 2451604
    #   ./bash.sh 2016-02-29 2457448
    #   ./bash.sh 2024-06-14 2460476
    #   ./bash.sh 1582-10-15 2299161
    #
    for d in 060 166 288
    do
        strip_out_stdout.sh podman.log | grep -q -E " $d$| $d[^0-9]|[0-9]$d$|[0-9]$d[^0-9]"
        if [ $? == 0 ]
        then
            echo >&2 "Found \"$d\" which is the \"ordinal day\" rather than the Julian day"
            exit 2
        fi
    done

    for jd in 2451604 2457448 2460476 2299161
    do
        strip_out_stdout.sh podman.log | grep -q $jd
        if [ $? != 0 ]
        then
            echo >&2 "Expected Julian Date of $jd in stdout"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc
