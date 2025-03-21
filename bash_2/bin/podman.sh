#!/bin/bash
#
# --mount type=bind,src=volume-name,target=/data1
#
# --user=test
#
# --userns=keep-id:uid=2000,gid=2000
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

#printf "podman(test)  : $test\n"
#printf "podman ${test} ${test_set} ${work_dir} in $(pwd)\n"

container="eabench_bash2"
userargs="--user=test --workdir=/home/test"
userns="--userns=keep-id:uid=2000,gid=2000"
#mntargs="--mount=type=bind,src=$(pwd)/${work_dir}/home,dst=/home"
mntargs="--volume $(pwd)/${work_dir}/home:/home:Z"
logargs="--log-driver=k8s-file --log-opt=path=$(pwd)/${work_dir}/podman.log"

if (( $(podman --version | sed -e 's+podman version \([0-9][0-9]*\).*+\1+') < 4 ))
then
    # Podman 3.4.4 doesn't support the uid/gid mapping so take a chance on just keeping the user's id
    userns="--userns=keep-id"
fi

if [ -f ${test_set}/${test}/podman.opts ]
then
    podopts=$(cat ${test_set}/${test}/podman.opts)
    podopts=$(eval "echo ${podopts}")
else
    podopts=""
fi

echo ${podopts} | grep -q timeout
if [ $? != 0 ]
then
    podopts="${podopts} --timeout=10"
fi

rm -f ${work_dir}/podman.log

#echo podman run --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} ./test.sh
podman run --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} ./test.sh
rc=$?

exit $rc
