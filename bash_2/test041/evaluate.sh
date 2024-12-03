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
    # Test041
    #
    # Typical output:
    #  c8da99ee39d364ca4159865b93bf375b  download1.dat
    #  0c7305a81550a92b19dcc1fb15b0ecbc  download2.dat
    #  b026abff67189ee72f7096373348bd54  download3.dat
    #  abbc0bd10037ef6cf67f469db41fefe3  download4.dat
    #
    declare -A sums=(
        [download1.dat]="c8da99ee39d364ca4159865b93bf375b"
        [download2.dat]="0c7305a81550a92b19dcc1fb15b0ecbc"
        [download3.dat]="b026abff67189ee72f7096373348bd54"
        [download4.dat]="abbc0bd10037ef6cf67f469db41fefe3"
    )

    rc=0
    for(( i=1; i<=${#sums[@]}; i++ ))
    do
        sum=${sums[download$i.dat]}
        #echo Looking for $sum for download$i.dat
        (strip_out_stdout.sh podman.log | grep "POST" | grep "download$i.dat" | grep -E "$sum") > /dev/null
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find \"$sum\" for download$i.dat in stdout"
            rc=2
        fi
    done
    exit $rc
)
rc=$?

exit $rc
