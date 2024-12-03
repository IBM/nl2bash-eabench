import subprocess
import os
import json

def main():
    os.chdir("TestDir")
    run_output = subprocess.run(["bash", "../test12.sh"], capture_output=True, text=True)

    py_files = ["test1.py", "test2.py"]
    non_py_files = ["test3.txt"]

    if run_output.stderr == "":
        result = "Pass"

        for file in py_files:
            try:
                with open(file) as f:
                    data = f.read()
                    if not (data == "# FileLine of text here\n" or data == "Line of text here\n# File\n"):
                        result = "Fail"
            except:
                result = "Fail"


        for file in non_py_files:
            try:
                with open(file) as f:
                    data = f.read()
                    if not data == "# File\n":
                        result = "Fail"
            except:
                result = "Fail"
    else:
        result = "Fail"

    os.chdir("..")

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test12.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    