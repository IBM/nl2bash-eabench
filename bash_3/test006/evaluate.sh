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
    # Test002
    #
    #
    #x=$(extract_vars.sh podman.log)
    read x <<< $(extract_vars.sh podman.log)
    eval $x
    for pid in ${PIDS[@]}
    do
        #echo $pid
        str=$(strip_out_stdout.sh podman.log | grep -v "PIDS" | grep -E "^$pid$|^$pid[^0-9]|[^0-9]$pid$|[^0-9]$pid[^0-9]")
        if [ $? == 0 ]
        then
            if [ $pid == 755 ]
            then
                echo $str
                if echo $str | grep -q -E "not|doesn.t|can.t"
                then
                    echo "Ignored invalid pid 755"
                else
                    echo >&2 "pid 755 should not have been output"
                    exit 2
                fi
            fi
        else
            if [ $pid != 755 ]
            then
                echo >&2 "Expected to see pid $pid in stdout"
                exit 2
            fi
        fi
    done

    exit 0
)
rc=$?

exit $rc
