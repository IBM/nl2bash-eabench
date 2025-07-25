import subprocess
import os
import json
import re

def main():
    run_output = subprocess.run(["bash", "test21.sh"], capture_output=True, text=True)

    correct_output = subprocess.run(["bash", "fetch_available_space_overlay.sh"], capture_output=True, text=True)
    if correct_output.stderr != "":
        output = {
            "result": "Abort",
            "reason": "Could not execute correct script. Got error " + correct_output.stderr,
            "returncode": run_output.returncode,
            "stdout": run_output.stdout,
            "stderr": run_output.stderr
        }

        with open("output/results_test21.json", "w") as f:
            json.dump(output, f)

        return
    
    memories = list(map(int, re.findall(r"\d+", correct_output.stdout)))
    numbers = list(map(int, re.findall(r"\d+", run_output.stdout)))

    result = "Fail"

    for memory in memories:
        for number in numbers:
            if memory == 0:
                result = "Pass" if number==0 else "Fail"
                break
            if abs(number - memory) / memory < 0.01:
                result = "Pass"
                break
        if result == "Pass":
            break
    
    if run_output.stderr != "":
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test21.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
