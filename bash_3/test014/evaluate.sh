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
    # Test014
    #
    list=(
        2
        3
        5
        7
        11
        13
        17
        19
        23
        29
        31
        37
        41
        43
        47
        53
        59
        61
        67
        71
        73
        79
        83
        89
        97
        101
        103
        107
        109
        113
        127
        131
        137
        139
        149
        151
        157
        163
        167
        173
        179
        181
        191
        193
        197
        199
        211
        223
        227
        229
        233
        239
        241
        251
        257
        263
        269
        271
        277
        281
        283
        293
        307
        311
        313
        317
        331
        337
        347
        349
        353
        359
        367
        373
        379
        383
        389
        397
        401
        409
        419
        421
        431
        433
        439
        443
        449
        457
        461
        463
        467
        479
        487
        491
        499
        503
        509
        521
        523
        541
    )
    #
    for n in ${list[@]}
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$n$|^$n[^0-9]|[^0-9]$n$|[^0-9]$n[^0-9]"
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find $n in stdout"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc
