#!/usr/bin/env python3

import os
import json
import subprocess
import argparse

#
# run_test.py ${test_set} ${test} ${work_dir}
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

    # Rename the script file
    try:
        os.rename(f"{work_dir}/script.txt", f"{test_set}/{test_id}/{test_id}.sh" )
    except OSError as e:
        print(f"Could not move {work_dir}/script.txt to {test_set}/{test_id}/{test_id}.sh: {e}")
        exit(1)

    command = f"{platform} run --rm -v {work_dir}:/app/output:Z -v ./bash_1/{test_id}:/app/code:Z eabench_bash1"

    run = subprocess.run( command.split(), capture_output=True, text=True )
    if run.returncode != 0:
        output = {
            "result" : "Abort",
            "returncode" : run.returncode,
            "stdout" : run.stdout,
            "stderr" : run.stderr
        }

        with open(f"{work_dir}/results_{test_id}.json", "w") as f:
            json.dump(output, f)
    
    # Remove the script file created
    try:
        os.remove(f"{test_set}/{test_id}/{test_id}.sh")
    except:
        pass

    exit( run.returncode )

if __name__ == "__main__":
    main()

