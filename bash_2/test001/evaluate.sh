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
#printf "which strip_out_stderr.sh is $(which strip_out_stderr.sh)\n"

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
    # Test001
    #
    # Typical
    #
    #  [test@murk test001]$ strip_test_stdout.sh podman.log
    #  Filesystem     1K-blocks    Used Available Use% Mounted on
    #  overlay        102126340 9491924  87427740  10% /
    #  tmpfs              65536       0     65536   0% /dev
    #  /dev/xvda2     102126340 9491924  87427740  10% /home
    #  shm                64000       0     64000   0% /dev/shm
    #  tmpfs            8184892       0   8184892   0% /sys/fs/cgroup
    #  devtmpfs         8167252       0   8167252   0% /dev/tty
    #  tmpfs            8184892       0   8184892   0% /proc/acpi
    #  tmpfs            8184892       0   8184892   0% /proc/scsi
    #  tmpfs            8184892       0   8184892   0% /sys/firmware
    #  tmpfs            8184892       0   8184892   0% /sys/fs/selinux
    #  tmpfs            8184892       0   8184892   0% /sys/dev/block
    #
    # Brute force: look for "df -h"
    #
    grep -E "^ *df  *-h *$" home/test/bash.sh > /dev/null
    if [ $? == 0 ]
    then
        # Score!
        exit 0
    fi

    #
    # Look for our filesystems
    #
    #strip_out_stdout.sh podman.log | grep "/dev/xvd" > /dev/null) && 
    #strip_out_stdout.sh podman.log | grep "/proc"    > /dev/null) && 
    #strip_out_stdout.sh podman.log | grep "/sys/fs"  > /dev/null) && 

    (strip_out_stdout.sh podman.log | grep -q "overlay" ) && \
    (strip_out_stdout.sh podman.log | grep -q "/dev"    ) && \
    (strip_out_stdout.sh podman.log | grep -q "/home"   )
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"overlay\""
        exit 2
    fi

    (strip_out_stdout.sh podman.log | grep "overlay" | grep -q -E "[1-9][0-9][0-9]") || \
    (strip_out_stdout.sh podman.log | grep "overlay" | grep -q -E "[1-9]G")
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain free space for \"/\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
