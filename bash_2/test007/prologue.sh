#!/bin/bash
#
# prologue.sh for test007
#

print_usage() {
    printf "$0 [<flags>] <test_set> <test> <work_dir<\n"
    printf "  <flags>:\n"
    printf "    (no flags yet}\n"
    printf "  <test_set> test directory, eg, bash\n"
    printf "  <test>     test to run, eg, test001\n"
    printf "  <work_dir> work directory, eg, ~/logs/DATE/test001\n"
    printf "\n"
    printf "$*\n"
    exit 1
}

while getopts '' flag
do
    case ${flag} in
        *) print_usage;;
    esac
done

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

if [ -z ${test} ]
then
    print_usage "Missing <test>\n"
fi

test_dir=${test_set}/${test}

if [ ! -d ${test_dir} ]
then
    print_usage "${test_dir} is not a directory\n"
fi

if [ -z ${work_dir} ]
then
    print_usage "Missing <work_dir>\n"
fi

#
# All of that (above) just to do this
#
#cp -p /var/log/wtmp ${work_dir}/home/test/bin
cp -pR ${test_dir}/var ${work_dir}

exit 0

