#!/bin/bash
#
# Strip stdout lines in podman.log containing my variables
#   - stdout lines carrying variables begin with "^#++", eg, "^#++MEM=123456"
#

print_usage() {
    printf "$0 [<flags>] <podmanlog>\n"
    printf "  <flags>:\n"
    printf "    (no flags yet}\n"
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

podmanlog=${@:$OPTIND+0:1}

if [ -z ${podmanlog} ]
then
    print_usage "Missing <podman.log>\n"
fi

if [ ! -r ${podmanlog} ]
then
    print_usage "Either ${podmanlog} does not exist or it is not readable\n"
fi

sed \
    -e "/^.* stdout P / { s///; H; x; s+\n++; x; d; }" \
    -e "/^.* stdout F / { s///; H; s+.*++; x; s+\n++; }" \
    -e '/^#++.*=.*/!d' \
    ${podmanlog} | \
sed \
    -E 's/^#\+\+(.*)/\1/' 

