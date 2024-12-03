import subprocess
import json
import re

def main():
    run_output = subprocess.run(["bash", "test44.sh"], capture_output=True, text=True)
    kernel_output = subprocess.run(["uname", "-s"], capture_output=True, text=True)
    version_output = subprocess.run(["uname", "-v"], capture_output=True, text=True)
    release_output = subprocess.run(["uname", "-r"], capture_output=True, text=True)

    if kernel_output.stderr != "" or release_output.stderr != "" or version_output.stderr != "":
        output = {
            "result": "Abort",
            "reason": "Error in executing ground truth code",
            "returncode": run_output.returncode,
            "stdout": run_output.stdout,
            "stderr": run_output.stderr
        }

        with open("output/results_test44.json", "w") as f:
            json.dump(output, f)

        return

    # kernel, release, version = required_output.stdout.split(" ")
    
    if run_output.stderr == "" and kernel_output.stdout.strip() in run_output.stdout and release_output.stdout.strip() in run_output.stdout and version_output.stdout.strip() in run_output.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test44.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
