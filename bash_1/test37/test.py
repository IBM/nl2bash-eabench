import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test37.sh"], capture_output=True, text=True)

    if run_output.stderr == "" and "51564e257b9e70a85cdc57f0c992c08d" in run_output.stdout and "804b146f6c0eaadafd5a928987439422" in run_output.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test37.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
