import subprocess
import json
import os

def main():
    files_in_current_directory = os.listdir()
    run_output = subprocess.run(["bash", "test47.sh"], capture_output=True, text=True)

    try:
        files_in_current_directory_after_execution = os.listdir()
        files_in_dir = os.listdir("dir")

        if files_in_current_directory_after_execution == files_in_current_directory and set(files_in_dir) == {"dir1", "file1.txt", "dir2"}:
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

    with open("output/results_test47.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
