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

#printf "Running a test004-specific evaluator\n"

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
    # Test004
    #
    # Typical output
    #
    #  Filesystem      Size  Used Avail Use% Mounted on
    #  overlay          98G  9.1G   84G  10% /
    #  tmpfs            64M     0   64M   0% /dev
    #  /dev/xvda2       98G  9.1G   84G  10% /home
    #  shm              63M     0   63M   0% /dev/shm
    #  tmpfs           7.9G     0  7.9G   0% /sys/fs/cgroup
    #  devtmpfs        7.8G     0  7.8G   0% /dev/tty
    #  tmpfs           7.9G     0  7.9G   0% /proc/acpi
    #  tmpfs           7.9G     0  7.9G   0% /proc/scsi
    #  tmpfs           7.9G     0  7.9G   0% /sys/firmware
    #  tmpfs           7.9G     0  7.9G   0% /sys/fs/selinux
    #  tmpfs           7.9G     0  7.9G   0% /sys/dev/block
    #
    # post_test.sh creates two variables:
    #   - DFB --> "df /" (before)
    #   - DFA --> "df /" (afer)
    #   - DFH --> "df -h"
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    strip_out_stdout.sh podman.log | grep -E "${DFB}|${DFA}|${DFH}" > /dev/null
    if [ $? != 0 ]
    then
        printf >&2 "Expected to find either \"$DFA\", \"$DFB\", or \"$DFH\" in stdout\n"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
