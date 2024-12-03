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
    #
    #
    sed -e "/^C home.test/d"            \
        -e "/^A home.test.tiny.dat/d"   \
        -e "/^A home.test.small.dat/d"  \
        -e "/^A home.test.medium.dat/d" \
        -e "/^A home.test.large.dat/d"  \
        -e "/^A home.test.grand.dat/d"  \
        -e "/^A home.test.super.dat/d"  \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test044: *.dat in ascending order by size
    #
    # Typical output:
    #   -rw-rw-r--. 1 test test 1024 Mar 20 16:44 small.dat
    #   -rw-rw-r--. 1 test test 2048 Mar 20 16:44 medium.dat
    #   -rw-rw-r--. 1 test test 3072 Mar 20 16:44 large.dat
    # or
    #   small.dat  medium.dat  large.dat
    #
    (strip_out_stdout.sh podman.log | grep "pre_test.sh"  > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "post_test.sh" > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "test.sh"      > /dev/null) || \
    (strip_out_stdout.sh podman.log | grep "bash.sh"      > /dev/null)
    if [ $? == 0 ]
    then
        echo >&2 "Only *.dat files should appear in stdout"
        exit 2
    fi

    # Check if files are "naturally" in order (keep POSTed lines)
    strip_out_stdout.sh podman.log | sed -e '/\.dat/!d' | sed -e "s+^STDOUT: ++" | sed -e "/^POST: /!d" | nl > tmp.log
    #cat tmp.log

    (grep -E "^ *1.*tiny.dat"   tmp.log > /dev/null) && \
    (grep -E "^ *2.*small.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *3.*medium.dat" tmp.log > /dev/null) && \
    (grep -E "^ *4.*large.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *5.*grand.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *6.*super.dat"  tmp.log > /dev/null)
    no=$?

    # This time delete POSTed lines and look for command output
    strip_out_stdout.sh podman.log | sed -e '/\.dat/!d' | sed -e "s+^STDOUT: ++" | sed -e "/^POST: /d" | nl > tmp.log
    #cat tmp.log

    # Look for all files on a single line
    rc=$(wc -l tmp.log | sed -e 's/ *\([1-9][0-9]*\).*/\1/')
    #echo wc is $rc
    if [ $rc == 1 ]
    then
        grep -E "tiny.dat.*small.dat.*medium.dat.*large.dat.*grand.dat.*super.dat" tmp.log > /dev/null
        if [ $? == 0 ]
        then
            if [ $no == 0 ]
            then
                echo "(You may have gotten lucky: they are \"naturally\" in order by size)"
            fi
            exit 0
        fi

        grep -E "super.dat.*grand.dat.*large.dat.*medium.dat.*small.dat.*tiny.dat" tmp.log > /dev/null
        if [ $? == 0 ]
        then
            echo >&2 "Appears to have sorted in descending rather than ascending order"
            exit 2
        fi

        echo >&2 "Doesn't appear to have sorted the files by size"
        exit 2
    fi
    #
    # More than one line output to stdout
    #

    (grep -E "^ *1.*tiny.dat"   tmp.log > /dev/null) && \
    (grep -E "^ *2.*small.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *3.*medium.dat" tmp.log > /dev/null) && \
    (grep -E "^ *4.*large.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *5.*grand.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *6.*super.dat"  tmp.log > /dev/null)
    if [ $? == 0 ]
    then
        if [ $no == 0 ]
        then
            echo "(You may have gotten lucky: they are \"naturally\" in order by size)"
        fi
        exit 0
    fi

    (grep -E "^ *6.*tiny.dat"   tmp.log > /dev/null) && \
    (grep -E "^ *5.*small.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *4.*medium.dat" tmp.log > /dev/null) && \
    (grep -E "^ *3.*large.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *2.*grand.dat"  tmp.log > /dev/null) && \
    (grep -E "^ *1.*super.dat"  tmp.log > /dev/null)
    if [ $? == 0 ]
    then
        echo >&2 "Expected ascending rather than descending order"
        exit 2
    fi

    echo >&2 "Doesn't appear to have sorted the files by size"

    grep -E "[0-9]K " tmp.log > /dev/null
    if [ $? == 0 ]
    then
        echo >&2 "Was the filesize output in units of \"K\"?"
    fi

    exit 2
)
rc=$?

exit $rc
