import subprocess
import re
import json

def main():
    run_output = subprocess.run(["bash", "test34.sh"], capture_output=True, text=True)

    correct_output1 = "101a\n102b\n\n103c\n104d\n\n"
    correct_output2 = "101 a\n102 b\n\n103 c\n104 d\n\n"
    try:
        with open("file.txt") as f:
            data = f.read()

        if data == correct_output1 or data == correct_output2:
            result = "Pass"
        else:
            result = "Fail"
    except:
        result = "Fail"

    if run_output.stderr != "":
        result == "Fail"
    
    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test34.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
