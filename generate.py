#!/usr/bin/env python3
#
# Gather up prompts into a single JSON file
#
import os
import sys
import re
import shutil
import argparse
import fnmatch
import json

def get_name( path, test ) -> str:
    with open(path+"/"+test+"/"+"name") as f:
        return f.read().rstrip()

def get_prompt( path, test ) -> str:
    with open(path+"/"+test+"/"+"prompt") as f:
        return f.read().rstrip()

def get_script( path, test ) -> str:
    if "bash" in path:
        file = "bash.sh"
    elif "pwsh" in path:
        file = "pwsh.ps1"
    elif "terraform" in path:
        file = "main.tf"
    else:
        print("No idea what type of script you're talking about: ",path)
        exit(1)

    with open(path+"/"+test+"/"+file) as f:
        return f.read().rstrip()

def load_tests( path, list, truth ):
    tests = []

    path = os.path.splitext( os.path.basename(path) )[0]

    for test in list:
        print(test + ": " + get_name(path,test))
        tests += [{
            "test"     : test,
            "name"     : get_name( path, test ),
            "prompt"   : get_prompt( path, test ),
            "script"   : get_script( path, test ) if truth else "",
            "path"     : path
        }]

    return tests

#
#
#
def save_tests( tests, path, filename ):

    if filename == None:
        basename = os.path.splitext( os.path.basename(path) )[0]
        filename = basename + ".json"

    try:
        os.makedirs( "output", exist_ok=True )
    except OSError as e:
        print(f"Unable to create output directory: {e}")
        exit(1)

    file = "output" + "/" + filename
    with open(file,"w") as f:
        json.dump( tests, f )

#
# Scan the "path" directory and build a list of tests
#
def build_test_list( tests_dir, tnpat ):

    tests = []
    for test in os.listdir(tests_dir):
        for pat in tnpat:
            if fnmatch.fnmatch( test, pat ):
                tests += [test]

    if len(tests) == 0:
        print("I didn't find any tests in "+tests_dir)
        exit(1)

    return sorted(tests)

#
# Process command line arguments
#
def getargs():
    ap = argparse.ArgumentParser(
        description="Generate test.json",
        prefix_chars="--",
        epilog=""
    )

    ap.add_argument( "path", nargs=1, help="path of tests directory" )
    ap.add_argument( "testpat", nargs='*', default=["test*"], help="selected tests to run; otherwise all will be run" )
    ap.add_argument("--gt", action="store_true", help="generate \"ground truth\" test")
    ap.add_argument("--save_filename", help="name of the output file")

    return ap.parse_args()


#
# Main
#
def main() -> int:

    args = getargs()

    path  = args.path[0]
    tnpat = args.testpat
    save  = args.save_filename
    truth = args.gt

    list = build_test_list( path, tnpat )

    tests = load_tests( path, list, truth )

    save_tests( tests, path, save )
    

if __name__ == "__main__":
    sys.exit( main() )
