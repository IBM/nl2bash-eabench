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
    # This time we expect a difference in the home directory
    #
    sed -e "/^C home.test.subdirA/d" -i.bak home.log
    for(( i=0; i<10; i++ ))
    do
        sed -e "/^D home.test.subdirA.pgm$i.py/d" \
            -e "/^A home.test.subdirA.pgm00$i.py/d" \
            -i.bak home.log
    done

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test035
    #
    # Typical output:
    #
    rc=0
    for(( i=0; i<10; i++ ))
    do
        if [ -f home/test/subdirA/pgm$i.py ] || [ ! -f home/test/subdirA/pgm00$i.py ]
        then
            echo >&2 "Expected /home/test/subdirA/pgm$i.py to be renamed to pgm00$i/py"
            rc=2
        fi
    done

    exit $rc
)
rc=$?

exit $rc
