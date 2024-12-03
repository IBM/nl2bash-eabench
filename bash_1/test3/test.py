import subprocess
import os
import json

def main():
    run_output = subprocess.run(["bash", "test3.sh"], capture_output=True, text=True)

    if run_output.stderr == "":
        try:
            if "test.json" in os.listdir():
                with open("test.json") as f:
                    data = json.load(f)
                    test_data = {"name": "test"}
                    if test_data == data:
                        result = "Pass"
                    else:
                        result = "Fail"
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

    with open("output/results_test3.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
