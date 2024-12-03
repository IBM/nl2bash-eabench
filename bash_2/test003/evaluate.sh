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

#printf "Running a test003-specific evaluator\n"

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
    # Test003
    #
    # Typical output
    #
    #  [test@murk test003]$ free -m
    #                total        used        free      shared  buff/cache   available
    #  Mem:          15986         619       11273          24        4092       15015
    #  Swap:          2047           0        2047
    #
    # BUT there's not much you can count on so try just looking for the value
    #
    # post_test.sh grabs a couple of values immediately after bash.sh runs
    #   - FREE, FREEM, FREEH, MEMINFO, VMSTAT
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}  # this should be FREE, FREEM, FREEH, MEMINFO, VMSTAT
    do
        eval ${var}
    done

    #printf "FREE is %d, FREEM is %d, MEMINFO is %d, VMSTAT is %d\n" ${FREE} ${FREEM} ${MEMINFO} ${VMSTAT}

    IFS=' ' read -a nums <<< $(extract_nums.sh podman.log)

    if [ ${#nums[@]} == 0 ]
    then
        echo >&2 "Expected a numeric value in stdout"
        exit 2
    fi

    for num in ${nums[@]}
    do
        if (( FREE-FREE/100 < num ))  &&  (( num < FREE+FREE/100 ))
        then
            exit 0
        fi
        if (( FREEM-FREEM/100 < num ))  &&  (( num < FREEM+FREEM/100 ))
        then
            exit 0
        fi
    done

    #
    # Looking of -mh output, eg, "8.6Gi"
    #
    strip_out_stdout.sh podman.log | grep $FREEH > /dev/null
    if [ $? == 0 ]
    then
        exit 0
    fi

    echo >&2 "Expected a value approximately equal to ${FREE} or ${FREEM} in stdout"
    exit 2
)
rc=$?

exit $rc
