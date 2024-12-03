import subprocess
import json
import os

def main():
    os.chdir("test_dir")
    run_output = subprocess.run(["bash", "../test50.sh", "file1.txt", "dir1/"], capture_output=True, text=True)
    run_output2 = subprocess.run(["bash", "../test50.sh", "file2.txt", "dir2/"], capture_output=True, text=True)
    try:
        test_dir_content = os.listdir()
        dir1_content = os.listdir("dir1")
        dir2_content = os.listdir("dir2")

        if "file1.txt" not in test_dir_content and "file2.txt" not in test_dir_content and set(dir1_content) == {"file.txt", "file1.txt"} and set(dir2_content) == {"file.txt", "file2.txt"}:
            result = "Pass"
        else:
            result = "Fail"
    except:
        result = "Fail"

    if run_output.stderr != "":
        result = "Fail"
    
    os.chdir("..")

    output = {
        "result": result,
        "returncode": [run_output.returncode, run_output2.returncode],
        "stdout": [run_output.stdout, run_output2.stdout],
        "stderr": [run_output.stderr, run_output2.stderr]
    }

    with open("output/results_test50.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
