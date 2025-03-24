#/bin/bash
#
# Debugging tool
#   > cd ~/nl2bash-eabench
#   > ./bash_3/bin/run-it.sh testX
#   (now run testX container components)
#
print_usage() {
    echo "run-it.sh [-p "podman"|"docker"] [<test>]"
    echo $*
    exit 1
}

platform="podman"

while getopts "p:" flag
do
    case ${flag} in
        p) platform="$OPTARG";;
        *) print_usage "Invalid option: -$OPTARG";;
    esac
done
shift $((OPTIND-1))

if [ $# -ne 1 ]
then
    print_usage "Missing argument: <test>"
fi

if [ ${platform} != "podman" ] && [ ${platform} != "docker" ]
then
    print_usage "Invalid platform: ${platform}"
fi

test=$1
test_set="bash_3"
container="eabench_bash3"
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

    echo "Run $test: $(cat ${test_set}/${test}/name)"


    if [ ${platform} == "podman" ]
    then
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

        #podman run -it --rm 
        #    --entrypoint '[ "/bin/bash", "--rcfile", "/root/.altrc" ]' 
        #    -v ${PWD}/output/${test}:/eabench 
        #    nl2terraform
        #    /eabench  (argument passed to entrypoint.sh)
        # podman run -it --rm --no-healthcheck -v ${PWD}/output/${test}:/eabench nl2terraform /eabench

        #echo podman run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash
        podman run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash
    else
        userargs="--workdir=/home/test"
        mntargs="--volume $(pwd)/${work_dir}/home:/home:Z"

        echo docker run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash
        docker run -it --rm ${userargs} ${userns} ${mntargs} ${logargs} ${podopts} ${container} /bin/bash
    fi

)
