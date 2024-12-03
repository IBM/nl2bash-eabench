#!/bin/bash
#
# Remove podman container, including "podman rm"
#   - some errant containers hang in "stopping" state
#     "podman stop" seems better than "podman rm -f" at preventing this
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

pname=${@:$OPTIND+3:1}
pname=${pname:-${test}}

(
    cd ${work_dir}
    rm -f diff.log home.log podman.log
    rm -f diff.log.bak home.log.bak podman.log.bak tmp.log
    rm -fr ./home ./var
)

#
# Remove the container
#
#pname=$(echo ${test} | sed -e 's/^_\(test[0-9][0-9][0-9]\)/X\1/')
#podman stop -t=1 ${pname}
#podman rm -f ${pname}


