import subprocess
import os
import json

def main():
    files = set(os.listdir("dir1"))

    run_output = subprocess.run(["bash", "test7.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and len(os.listdir("dir1")) == 0 and len(files.difference(os.listdir("dir2"))) == 0:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test7.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()