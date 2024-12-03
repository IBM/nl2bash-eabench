import subprocess
import os
import json

def main():
    files = set(os.listdir("dir1"))
    txt_files = [file for file in files if file.endswith(".txt")]
    remaining_files = [file for file in files if not file.endswith(".txt")]

    run_output = subprocess.run(["bash", "test8.sh"], capture_output=True, text=True)

    txt_files_in_dir1 = True if len(set(txt_files).intersection(os.listdir("dir1"))) != 0 else False
    txt_files_in_dir2 = True if len(set(txt_files).difference(os.listdir("dir2"))) == 0 else False
    remaining_files_in_dir1 = True if len(set(remaining_files).difference(os.listdir("dir1"))) == 0 else False
    remaining_files_in_dir2 = True if len(set(remaining_files).intersection(os.listdir("dir2"))) != 0 else False

    if run_output.stderr == "" and not txt_files_in_dir1 and txt_files_in_dir2 and remaining_files_in_dir1 and not remaining_files_in_dir2:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test8.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    