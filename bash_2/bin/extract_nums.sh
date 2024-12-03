#!/bin/bash
#
# Extract anything that resembles a number from stdout
#   - we're desparate...
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

#
# The "nums" script:
#   - strip out text:                       s/[A-Za-z][A-Za-z0-9]*/ /g
#   - remove punctuation:                   s/[[:punct:]]/ /g;
#   - sorry, no zeroes allowed:             s/^0 //; s/ 0 / /; s/ 0$//;
#   - consolidate spaces:                   s/ +/ /g;
#   - for all lines except the last one:    $!{ H; x; s+\n++g; x; d};
#     - append to "hold"                    H
#     - delete \n appended to "hold" by H;  x; s+\n++g;
#     - delete pattern space                x; d
#   - at the last line, print "hold" space: ${ x; p }
#
sed \
    -e "/^.* stdout P / { s///; H; x; s+\n++; x; d; }" \
    -e "/^.* stdout F / { s///; H; s+.*++; x; s+\n++; }" \
    -e '/^#++.*=.*/d' \
    ${podmanlog}  | \
sed -n \
    -E 's/[A-Za-z][A-Za-z0-9]*/ /g; s/[[:punct:]]/ /g; s/^0 //; s/ 0 / /; s/ 0$//; {H; x; s+\n+ +g; x}; $!d; ${ x; s/ +/ /g; p}'

##sed -n\
##    -e 's/[A-Za-z][A-Za-z0-9]*/ /g' \
#    -e 's/[[:punct:]]/ /g' \
#    -e 's/^0 //; s/ 0 / /; s/ 0$//' \
#    -e 's/ +/ /g' \
#    -e '$!{ H; x; s+\n++g; x; d}' \
#    -e '${ x; p }'
#
#sed -n \
#    -E 's/[A-Za-z][A-Za-z0-9]*/ /g' \
#    -E 's/[[:punct:]]/ /g' \
#    -E 's/^0 //; s/ 0 / /; s/ 0$//' \
#    -E 's/ +/ /g' \
#    -E '$!{ H; x; s+\n++g; x; d}' \
#    -E '${ x; p }'
