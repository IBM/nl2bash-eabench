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
    # pgm.py files are changed
    #
    sed -e "/^C home.test.subdirA/d" \
        -e "/^C home.test.subdirA.pgm2.py/d" \
        -e "/^C home.test.subdirA.subdirB/d" \
        -e "/^C home.test.subdirA.subdirB.pgm3.py/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test034
    #
    # Typical output:
    #
    grep -E 'python3' home/test/pgm1.py >/dev/null
    if [ $? == 0 ]
    then
        echo >&2 "/home/test/pgm1.py should not have been edited"
        exit 2
    fi

    head -n1 home/test/subdirA/pgm2.py | grep -E '#!/usr/bin/python3' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected \"#!/usr/bin/python3\" as the first line in /home/test/subdirA/pgm2.py"
        exit 2
    fi

    head -n1 home/test/subdirA/subdirB/pgm3.py | grep -E '#!/usr/bin/python3' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected \"#!/usr/bin/python3\" as the first line in /home/test/subdirA/subdirB/pgm3.py"
        exit 2
    fi

    grep "print(.Hello World!.)" home/test/pgm1.py > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Wait - did you over-write ~/pgm1.py?"
        exit 2
    fi

    grep "print(.Hello from me, too!.)" home/test/subdirA/pgm2.py > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Wait - did you over-write subdurA/pgm2.py?"
        exit 2
    fi

    grep "print(.I.m not sayin. nothin.!.)" home/test/subdirA/subdirB/pgm3.py > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Wait - did you over-write subdurA/subdirB/pgm3.py?"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
