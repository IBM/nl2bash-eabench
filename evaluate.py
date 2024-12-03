#!/usr/bin/env python3

import os
import json
import fnmatch
import argparse
import subprocess

def create_results_directory( filename ):
    basename = os.path.splitext( os.path.basename(filename) )[0]
    directory = "./output" + "/" + basename
    try:
        os.makedirs( directory, exist_ok=True )
    except OSError as e:
        print("Unable to create output directory: {e}")
        exit(1)

    return directory

def save_outputs( filename, outputs ):
    basename = os.path.splitext( os.path.basename(filename) )[0]
    with open(f"output/{basename}_eval.json","w") as f:
        json.dump( outputs, f )

def read_json( filename, tnpat ):

    with open(filename,"r") as f:
        tests = json.load(f)

    select = []
    for test in tests:
        for pat in tnpat:
            if fnmatch.fnmatch( test["test"], pat ):
                select += [test]

    return select


def create_script_file( filename, script ):
    with open(filename,"w") as f:
        f.write(script)


def run_test( platform, path, test_id, script, results ):

    create_script_file( f"{results}/script.txt", script )

    command=f"./{path}/bin/run_test.py {platform} {path} {test_id} {results}"

    run = subprocess.run( command.split(), capture_output=True, text=True )

    #print("run.stdout: ",run.stdout)
    #print("run.stderr: ",run.stderr)

    if run.returncode == 0:
        #
        # Test was executed but what was the result?
        #
        try:
            with open(f"{results}/results_{test_id}.json", "r") as f:
                result = json.load(f)
        except OSError as e:
            print(f"Unable to find output from {path}/{test_id} in {results}")
            exit(1)

        output = {
            "test" : test_id,
            "path" : path,
            "result" : result["result"],
            "returncode" : result["returncode"],
            "script" : script,
            "stdout" : result["stdout"],
            "stderr" : result["stderr"]
        }
    else:
        #
        # Test runner failed to run the test
        #
        output = {
            "test" : test_id,
            "path" : path,
            "result" : "Abort",
            "returncode" : run.returncode,
            "script" : script,
            "stdout" : f"Failed to execute {path}/{test_id}",
            "stderr" : run.stderr
        }
    return output

def getargs():
    ap = argparse.ArgumentParser(
        description="Test Runner",
        prefix_chars="+-",
        epilog=""
    )

    if "PLATFORM" in os.environ:
        platform = os.environ["PLATFORM"]
    else:
        platform = "podman"

    ap.add_argument( "filename", help="full path of JSON input file" )
    ap.add_argument( "testpat", nargs='*', default=["test*"], help="selected tests to run; otherwise all will be run" )
    ap.add_argument("--platform", choices=["docker", "podman"], default=platform, help="container platform")

    return ap.parse_args()


if __name__ == "__main__":

    args = getargs()
    filename = args.filename
    testpat  = args.testpat
    platform = args.platform

    results = create_results_directory( filename )

    tests = read_json( filename, testpat )

    outputs = []
    passed  = 0

    for test in tests:

        # Expected JSON input:
        #   {
        #       "test": "test050",
        #       "name": "Show full host name",
        #       "prompt": "What is the bash command to show the fully-qualified domain name of my host?",
        #       "script": "#!/bin/bash\nhostname -f",
        #       "path": "bash_1"
        #   }
        output = run_test( platform, test["path"], test["test"], test["script"], results )

        outputs += [ output ]

        tid  = test["test"]
        name = test["name"]
        pf   = output["result"]
        print(f"{pf}: {tid} - {name}")

        if pf == "Pass":
            passed += 1

    print(f"Code accuracy: {passed} of {len(tests)} passed")

    save_outputs( filename, outputs )

