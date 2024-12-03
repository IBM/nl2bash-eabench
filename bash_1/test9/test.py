import subprocess
import os
import json

def main():
    files = set(os.listdir("dir1"))
    txt_files = [file for file in files if file.endswith(".txt")]
    remaining_files = [file for file in files if not file.endswith(".txt")]

    run_output = subprocess.run(["bash", "test9.sh"], capture_output=True, text=True)

    all_files_in_dir1 = True if set(files) == set(os.listdir("dir1")) else False
    txt_files_in_dir2 = True if len(set(txt_files).difference(os.listdir("dir2"))) == 0 else False
    remaining_files_in_dir2 = True if len(set(remaining_files).intersection(os.listdir("dir2"))) != 0 else False

    if run_output.stderr == "" and all_files_in_dir1 and txt_files_in_dir2 and not remaining_files_in_dir2:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test9.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    