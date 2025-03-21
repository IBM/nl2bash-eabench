import subprocess
import os
import json

def main():
    run_output = subprocess.run(["bash", "test1.sh"], capture_output=True,text=True)

    if run_output.stderr == "" and "test" in os.listdir():
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test1.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    
