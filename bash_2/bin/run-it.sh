#/bin/bash

if [ $# -ne 1 ]
then
    echo "run-it.sh [<test>]"
    exit 1
fi

test=$1
test_set="bash_2"
container="eabench_bash2"
work_dir="output/${test_set}/${test}"

if [ ! -d $test_set/$test ]
then
    echo $test is not a directory under ${test_set}
    exit 1
fi

(
    export PATH="$(pwd)/${test_set}/bin:${PATH}"

    rm -fr ${work_dir}
    mkdir -p ${work_dir}

    # prologue.sh
    cp -pR ${test_set}/${test}/home ${work_dir}
    cp -p ${test_set}/${test}/bash.sh ${work_dir}/home/test
    chmod +x ${work_dir}/home/test/bash.sh
    if [ -x ${test_set}/${test}/prologue.sh ]
    then
        #cat ${test_set}/${test}/prologue.sh
        ${test_set}/${test}/prologue.sh ${test_set} ${test} ${work_dir}
    fi

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
    if [ $? == 0 ]
    then
        #echo podopts is ${podopts}
        podopts=$(echo ${podopts} | sed -e 's+ *--timeout=[0-9][0-9]* *++')
        echo podopts is ${podopts}
    fi

    echo "Run $test"

    #podman run -it --rm 
    #    --entrypoint '[ "/bin/bash", "--rcfile", "/root/.altrc" ]' 
    #    -v ${PWD}/output/${test}:/eabench 
    #    nl2terraform
    #    /eabench  (argument passed to entrypoint.sh)
    # podman run -it --rm --no-healthcheck -v ${PWD}/output/${test}:/eabench nl2terraform /eabench

    echo podman run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash
    podman run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash

)
