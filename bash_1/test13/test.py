import subprocess
import os
import json
import re

def main():
    run_output = subprocess.run(["bash", "test13.sh"], capture_output=True, text=True)

    numbers = re.findall(r"\d+", run_output.stdout)

    if run_output.stderr == "" and  "5" in numbers or "8" in numbers:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test13.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    