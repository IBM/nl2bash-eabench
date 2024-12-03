import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test35.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and run_output.stdout == "Hello \n World\n":
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test35.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
