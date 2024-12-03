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
    declare -A twins=(
        [101]="103"
        [107]="109"
        [137]="139"
        [149]="151"
        [179]="181"
        [191]="193"
        [197]="199"
        [227]="229"
        [239]="241"
        [269]="271"
        [281]="283"
        [311]="313"
        [347]="349"
        [419]="421"
        [431]="433"
        [461]="463"
        [521]="523"
        [569]="571"
        [599]="601"
        [617]="619"
        [641]="643"
        [659]="661"
        [809]="811"
        [821]="823"
        [827]="829"
        [857]="859"
        [881]="883"
    )

    for p in ${!twins[@]}
    do
        t=${twins[$p]}
        strip_out_stdout.sh podman.log | grep $p | grep -q -E "^$t$|^$t[^0-9]|[^0-9]$t$|[^0-9]$t[^0-9]"
        if [ $? != 0 ]
        then
            echo >&2 "Expected stdout to contain $p, ${twins[$p]}"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc
