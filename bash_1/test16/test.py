import subprocess
import os
import json
import re

def main():
    run_output = subprocess.run(["bash", "test16.sh"], capture_output=True, text=True)

    correct_output = subprocess.run(["bash", "top_cpu_consumers.sh"], capture_output=True, text=True)
    if run_output.stderr == "":
        process_ids = correct_output.stdout.split("\n")[:-1]

        numbers = re.findall(r"\d+", run_output.stdout)

        result = "Pass"
        for id in process_ids:
            if id not in numbers:
                result = "Fail"
                break
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test16.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
