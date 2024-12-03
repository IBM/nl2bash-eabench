import subprocess
import os
import json

def main():
    run_output = subprocess.run(["bash", "test25.sh"], capture_output=True, text=True)

    files = [f"test{i}.txt" for i in range(1, 6)]

    all_files = os.listdir()
    
    result = "Pass"
    
    # Check if top 5 files are present or not.
    for file in files:
        if file not in run_output.stdout:
            result = "Fail"
            break

    # Check if any other file/directory is present or not
    for file in all_files:
        if file not in files and file in run_output.stdout:
            result = "Fail"
            break

    if run_output.stderr != "":
        result = "Fail"
    
    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test25.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
