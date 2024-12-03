import subprocess
import re
import json

def main():
    run_output = subprocess.run(["bash", "test32.sh"], capture_output=True, text=True)

    correct_output = "prefix_a\nprefix_b\n\nprefix_c\nprefix_d\n\n"
    try:
        with open("file.txt") as f:
            data = f.read()

        if data == correct_output:
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

    with open("output/results_test32.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
