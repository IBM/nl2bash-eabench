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

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test048: search *.c and *.h for TODO
    #
    # Typical output:
    #   src/vpd.c
    #   src/sliop/vpd_sliop.c
    #
    (strip_out_stdout.sh podman.log | grep "vpd.c"       > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_shvpp.c" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_mezz.c"  > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_hzb.c"   > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_hvvmm.c" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_cvmm.c"  > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "vpd_wing.c"  > /dev/null)

    if [ $? == 0 ]
    then
        echo >&2 "stdout should only contain vpd.h and vpd_sliop.c"
        exit 2
    fi

    (strip_out_stdout.sh podman.log | grep "vpd.h"       > /dev/null) && \
    (strip_out_stdout.sh podman.log | grep "vpd_sliop.c" > /dev/null)

    if [ $? != 0 ]
    then
        echo >&2 "Expected to find vpd.h and vpd_sliop.c in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
