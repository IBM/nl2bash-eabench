#!/bin/bash
#!/bin/bash
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

container="eabench_bash3"
#userargs="--user=test --workdir=/home/test"
userargs="--workdir=/home/test"
#userns="--userns=keep-id:uid=1000,gid=1000"
#mntargs="--mount=type=bind,src=$(pwd)/${work_dir}/home,dst=/home"
mntargs="--volume $(pwd)/${work_dir}/home:/home:Z"
#logargs="--log-driver=k8s-file --log-opt=path=$(pwd)/${work_dir}/podman.log"

if [ -f ${test_set}/${test}/podman.opts ]
then
    tmo=$(sed 's+.*timeout-\([0-9][0-9]*\).*+\1+p' ${test_set}/${test}/podman.opts)
    if [ -z "$tmo" ]
    then
        tmo=10
    fi
else
    tmo=10
fi

rm -f ${work_dir}/podman.log

docker run --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} timeout ${tmo} ./test.sh > >(sed -e "s+^+ stdout F +" > ${work_dir}/docker_stdout.log) 2> >(sed -e "s+^+ stderr F +" > ${work_dir}/docker_stderr.log)
rc=$?

#
# Catch timeout rc and map to 255, same as podman
#
if [ $rc == 124 ]
then
    rc=255
fi

cat ${work_dir}/docker_stdout.log ${work_dir}/docker_stderr.log > ${work_dir}/podman.log
rm  ${work_dir}/docker_stdout.log ${work_dir}/docker_stderr.log

exit $rc
