#!/bin/bash
#
# Strip stdout lines in podman.log
#   - podman prefixes each line with data/time, stdout, etc
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
    -e 's+\x0+ +g' \
    -e "/^.* stderr [FP] /d" \
    -e '/^.* stdout F #++.*=.*/d' \
    -e "/^.* stdout P / { s///; H; x; s+\n++; $ {p;z}; x; d; }" \
    -e "/^.* stdout F / { s///; H; g; s+\n++; p; z; x; d }" \
    -e "$ x" \
    ${podmanlog}

