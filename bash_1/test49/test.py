import subprocess
import json
import os

def main():
    run_output = subprocess.run(["bash", "test49.sh", "file1.txt"], capture_output=True, text=True)
    run_output2 = subprocess.run(["bash", "test49.sh", "file2.txt"], capture_output=True, text=True)

    if run_output.stderr == "" and "My name is Harry Potter\n" in run_output.stdout and "Hello Harry Potter, my name is Tom Marvolo Riddle\n" in run_output2.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": [run_output.returncode, run_output2.returncode],
        "stdout": [run_output.stdout, run_output2.stdout],
        "stderr": [run_output.stderr, run_output2.stderr]
    }

    with open("output/results_test49.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
