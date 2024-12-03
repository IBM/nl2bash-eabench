import subprocess
import re
import json

def main():
    run_output = subprocess.run(["bash", "test33.sh"], capture_output=True, text=True)

    correct_output1 = "1a\n2b\n3\n4c\n5d\n6\n"
    correct_output2 = "1 a\n2 b\n3 \n4 c\n5 d\n6 \n"
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
        result = "Fail"
    
    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test33.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
