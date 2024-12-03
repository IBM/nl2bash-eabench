import subprocess
import os
import json
import re

def main():
    run_output = subprocess.run(["bash", "test18.sh"], capture_output=True, text=True)

    correct_output = subprocess.run(["bash", "fetch_available_memory.sh"], capture_output=True, text=True)
    if run_output.stderr == "":
        memories = list(map(float, re.findall(r'-?\d+\.?\d*', correct_output.stdout)))
        
        #numbers = list(map(int, re.findall(r'-?\d+\.?\d*', run_output.stdout)))
        numbers = list(map(float, re.findall(r'-?\d+\.?\d*', run_output.stdout)))

        result = "Fail"

        for memory in memories:
            for number in numbers:
                if abs(number - memory) / memory < 0.1:
                    result = "Pass"
                    break
            if result == "Pass":
                break
        
        if len(run_output.stderr) != 0:
            result = "Fail"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test18.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
