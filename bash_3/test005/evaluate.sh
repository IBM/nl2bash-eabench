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
    # Strip out spurious changes
    #
    sed -e "/^C \/etc$/d" \
        -e "/^C \/tmp$/d" \
        -e "/^C \/etc\/passwd$/d" \
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
    # Test005
    #
    # root bin daemon adm lp sync shutdown halt mail operator games ftp nobody dbus systemd-coredump systemd-resolve tss test
    # 0 1 2 4 7 12 100 50 65534 81 997 193 59 1000
    #
    for gname in root bin daemon adm lp sync shutdown halt mail operator games ftp nobody dbus systemd-coredump systemd-resolve tss test
    do
        strip_out_stdout.sh podman.log | grep -q "$gname"
        if [ $? == 0 ]
        then
            echo >&2 "It should not have complained about group \"$gname\""
            exit 2
        fi
    done

    # Removed 0 and 1 due to false alarms
    for gid in 2 4 7 12 100 50 65534 81 997 193 59 1000
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$gid$|^$gid[^0-9]|[^0-9]$gid$|[^0-9]$gid[^0-9]"
        if [ $? == 0 ]
        then
            echo >&2 "It should not have complained about group id \"$gid\""
            exit 2
        fi
    done


    gname="snoopy"
    gid=1001
    strip_out_stdout.sh podman.log | grep -q "snoopy" || \
    strip_out_stdout.sh podman.log | grep -q -E "^$gid$|^$gid[^0-9]|[^0-9]$gid$|[^0-9]$gid[^0-9]"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find either user \"$gname\" or group id \"$gid\" in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
