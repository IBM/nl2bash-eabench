import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test15.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and "d41d8cd98f00b204e9800998ecf8427e" in run_output.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test15.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()