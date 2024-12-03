import subprocess
import json
import os

def main():
    files_in_current_directory = sorted( os.listdir() )
    run_output = subprocess.run(["bash", "test46.sh"], capture_output=True, text=True)

    try:
        files_in_current_directory_after_execution = sorted( os.listdir() )
        files_in_dir = sorted( os.listdir("dir") )

        if files_in_current_directory_after_execution == files_in_current_directory and files_in_dir == ["dir1", "dir2"]:
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

    with open("output/results_test46.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
