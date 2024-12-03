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

#printf "Running a test017-specific evaluator\n"

(
    cd ${wrkdir}

    #
    # Special case:
    #   - mkfs, unfortunately, spits information out on stderr... sometimes...
    # 
    # Output:
    #  stderr: mke2fs 1.45.6 (20-Mar-2020)
    #
    if grep -E 'mke2fs' podman.log > /dev/null
    then
        sed -E '/stderr( F mke2fs 1\.[0-9][0-9]*\.[0-9])/s//stdout\1/' \
            -i.bak podman.log
    fi

    #
    # Look for any stderr output during runtime
    #
    rc=$(strip_out_stderr.sh podman.log | wc -l)
    if [ $rc != 0 ]
    then
        echo >&2 "Command had runtime errors"
        echo >&2 "(Was dd used to overwrite the existing disk.img file?)"
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
    # This time we expect a difference in the home directory
    #   - pre_test.sh creates disk.img
    #
    sed -e "/^A home.test.disk.img/d" \
        -e "/^C home.test/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    if [ ! -f home/test/disk.img ]
    then
        echo >&2 "Expected to find a file named \"disk.img\" in /home/test"
        exit 2
    fi

    #
    # Test017
    #
    # Typical output
    #
    #  done
    #  Creating filesystem with 1024 1k blocks and 128 inodes
    #  
    #  Allocating group tables: done
    #  Writing inode tables: done
    #  done
    #  
    # post_test.sh exports:
    #   - EXT  - filesystem type in disk.img
    #   - SIZE - size of disk.img
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    if [ -z "${EXT}" ]
    then
        echo >&2 "disk.img was deleted?"
        exit 2
    fi

    if [ ${EXT} = "data" ]
    then
        echo >&2 "mkfs did not run"
        exit 2
    fi
    
    if [ ${EXT} != "ext3" ]
    then
        echo >&2 "disk.img contains $EXT filesytem but it should contain ext3"
        exit 2
    fi

    if (( ${SIZE} != 2097152 ))
    then
        echo >&2 "The size of disk.img changed: it is $SIZE but should be 2097152"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
