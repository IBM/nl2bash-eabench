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


(
    cd ${wrkdir}

    #
    # Look for any stderr output during runtime
    #
    rc=$(strip_out_stderr.sh podman.log | wc -l)
    if [ $rc != 0 ]
    then
        strip_out_stderr.sh podman.log >&2
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

    #
    # Expect changes to file extension
    #
    sed -e "/^C home.test/d" \
        -e "/^C home.test.file.log/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test038
    #
    # Typical output:
    #
    rc=0
    for(( i=1; i<=10; i++ ))
    do
        if [ $i == 4 ] || [ $i == 5 ] || [ $i == 9 ]
        then
            (strip_out_stdout.sh podman.log | sed -e "s+\t+ +g" | grep -E "^ *$i *$")
            if [ $? != 0 ]
            then
                rc=2
                echo >&2 "Expected to see \"  $i Line $i\" in stdout"
            fi
        else
            (strip_out_stdout.sh podman.log | sed -e "s+\t+ +g" | grep -E "^ *$i *Line $i *$")
            if [ $? != 0 ]
            then
                rc=2
                echo >&2 "Expected to see \"  $i Line $i\" in stdout"
            fi
        fi
    done

    exit $rc
)
rc=$?

exit $rc
