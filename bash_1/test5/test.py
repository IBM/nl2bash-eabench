import subprocess
import os
import json

def main():
    previous_content = os.listdir()
    run_output = subprocess.run(["bash", "test5.sh"], capture_output=True, text=True)
    current_content = os.listdir()

    previous_content.remove("test.json")

    if run_output.stderr == "":
        try:
            if set(previous_content) == set(current_content):
                result = "Pass"
            else:
                result = "Fail"
        except:
            result = "Fail"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test5.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
