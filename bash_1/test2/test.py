import subprocess
import os
import json

def main():
    run_output = subprocess.run(["bash", "test2.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and "test.txt" in os.listdir("dir1") and "test.txt" in os.listdir("dir2"):
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test2.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()