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
    # Had to add hostname to /usr/bin
    #
    sed -e '/^C .usr.bin/d' \
        -e '/^C .usr/d' \
        -e '/^A .usr.bin.hostname/d' \
        -i.bak diff.log

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
    # Test054: hostname -f
    #
    # Typical output:
    #   stdout: murk.sl.cloud9.ibm.com
    #
    # post_test.sh outputs HOSTNAME
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    #echo "HOSTNAME=" ${HOSTNAME}

    strip_out_stdout.sh podman.log | grep -q "${HOSTNAME}"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find ${HOSTNAME} in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
