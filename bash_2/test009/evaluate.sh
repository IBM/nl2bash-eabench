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

#printf "Running a test009-specific evaluator\n"

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
    # Be explicit about failing a yum command without the -y flag
    #
    (grep -E 'yum.*install' home/test/bash.sh | head -1 | grep -v -e '-y'          > /dev/null) && \
    (grep -E 'yum.*install' home/test/bash.sh | head -1 | grep -v -e '--assumeyes' > /dev/null)
    if [ $? == 0 ]
    then
        echo >&2 "Expected to see \"-y\" flag on yum command line"
        exit 2
    fi

    #
    # Test009: system files are created
    #
    #grep -E '^A /usr/bin/wget' diff.log > /dev/null
    #if [ $? != 0 ]
    #then
    #    echo >&2 "Expected to see \"/usr/bin/wget\" added to the container's files"
    #    exit 2
    #fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory"
        exit 2
    fi

    #
    # Test009
    #
    # Typical output (the last line is from "which wget" in post_test.sh
    #
    #  Installed:
    #    libmetalink-0.1.3-7.el8.x86_64            wget-1.19.5-11.el8.x86_64
    #  
    #  Complete!
    #  /usr/bin/wget
    strip_out_stdout.sh podman.log | grep "Installed:" > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to see \"Installed:\" in stdout"
        exit 2
    fi
    strip_out_stdout.sh podman.log | grep "/usr/bin/wget" > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to see \"/usr/bin/wget\" in stdout from \"which wget\" in post_test.sh"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
