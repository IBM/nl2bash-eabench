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

    #
    # Ignore spurious changes
    #
    sed -e "/^D home\/test\/downloads\/soft-link3.dat$/d" \
        -e "/^A home\/test\/downloads\/soft-link3.dat$/d" \
        -e "/^A home\/test\/uploads.targets$/d" \
        -e "/^C home\/test$/d" \
        -e "/^C home\/test\/downloads$/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory"
        exit 2
    fi

    #
    # Test001
    #
    # Typical - /home/test/uploads.targets should contain
    #   file4.dat
    #   file1.dat
    #   file3.dat
    #
    TARGETS=home/test/uploads.targets

    for file in file1.dat file3.dat file4.dat
    do
        grep -q $file $TARGETS
        if [ $? != 0 ]
        then
            echo >&2 "$TARGETS should have contained \"$file\""
            exit 2
        fi
    done

    if [ $(wc -l $TARGETS) != 3 ]
    then
        echo >&2 "$TARGETS should have contained only file1.dat, file3.dat, file4.dat"
        cat >&2 $TARGETS
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
