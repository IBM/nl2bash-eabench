import subprocess
import json
import re

def main():
    run_output = subprocess.run(["bash", "test43.sh"], capture_output=True, text=True)
    hostname_output = subprocess.run(["uname", "-n"], capture_output=True, text=True)

    if hostname_output.stderr != "":
        output = {
            "result": "Abort",
            "reason": "Error in executing ground truth code",
            "returncode": run_output.returncode,
            "stdout": run_output.stdout,
            "stderr": run_output.stderr
        }

        with open("output/results_test43.json", "w") as f:
            json.dump(output, f)

        return

    if run_output.stderr == "" and hostname_output.stdout in run_output.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test43.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()