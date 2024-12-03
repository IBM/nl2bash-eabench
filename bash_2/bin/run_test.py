#!/usr/bin/env python3

import os
import json
import subprocess
import argparse

#
# run_test.sh ${test_set} ${test} ${work_dir}
#
def main():
    ap = argparse.ArgumentParser()

    ap.add_argument("platform")
    ap.add_argument("test_set")
    ap.add_argument("test_id")
    ap.add_argument("work_dir")

    args = ap.parse_args()

    platform = args.platform
    test_set = args.test_set
    test_id  = args.test_id
    work_dir = args.work_dir

    command = f"./{test_set}/bin/run_test.sh {platform} {test_set} {test_id} {work_dir}"

    run = subprocess.run( command.split(), capture_output=True, text=True )
    if run.returncode == 0:
        print("stdout: ",run.stdout)
        print("stderr: ",run.stderr)
        output = {
            "result" : "Pass",
            "returncode" : run.returncode,
            "stdout" : run.stdout,
            "stderr" : run.stderr
        }
    elif run.returncode == 2:
        output = {
            "result" : "Fail",
            "returncode" : run.returncode,
            "stdout" : run.stdout,
            "stderr" : run.stderr
        }
    else:
        output = {
            "result" : "Abort",
            "returncode" : run.returncode,
            "stdout" : run.stdout,
            "stderr" : run.stderr
        }

    with open(f"{work_dir}/results_{test_id}.json", "w") as f:
        json.dump(output, f)
    
    exit( run.returncode if output["result"] == "Abort" else 0 )

if __name__ == "__main__":
    main()

