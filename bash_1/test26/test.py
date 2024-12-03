import subprocess
import os
import json

def main():
    try:
        with open("test26.sh", "a") as f:
            f.write("\npwd")
    except:
        output = {
            "result": "Abort",
            "reason": "Could not write to file test26.sh",
            "returncode": 0,
            "stdout": "",
            "stderr": ""
        }

        with open("output/results_test26.json", "w") as f:
            json.dump(output, f)

        return

    run_output = subprocess.run(["bash", "test26.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and run_output.stdout.endswith("/var\n"):
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test26.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
