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

rm -f ${work_dir}/podman.log

docker run --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} ./test.sh > >(sed -e "s+^+ stdout F +" > ${work_dir}/docker_stdout.log) 2> >(sed -e "s+^+ stderr F +" > ${work_dir}/docker_stderr.log)
rc=$?

cat ${work_dir}/docker_stdout.log ${work_dir}/docker_stderr.log > ${work_dir}/podman.log
rm  ${work_dir}/docker_stdout.log ${work_dir}/docker_stderr.log

exit $rc
