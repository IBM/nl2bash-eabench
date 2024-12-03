import subprocess
import json
import os

def main():
    files_in_current_directory = os.listdir()
    run_output = subprocess.run(["bash", "test48.sh"], capture_output=True, text=True)

    try:
        files_in_current_directory_after_execution = os.listdir()

        if "dir" not in files_in_current_directory_after_execution and  set(files_in_current_directory) == set(files_in_current_directory_after_execution + ["dir"]) :
            result = "Pass"
        else:
            result = "Fail"
    except:
        result = "Fail"

    if run_output.stderr != "":
        result = "Fail"
    
    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test48.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
