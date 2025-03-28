import subprocess
import json
import re

def main():
    run_output = subprocess.run(["bash", "test42.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and "54321" in re.findall(r"\d+", run_output.stdout):
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test42.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
