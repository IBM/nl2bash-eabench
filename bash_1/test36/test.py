import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test36.sh"], capture_output=True, text=True)

    if  run_output.stderr == "" and "3b9520176d5655762603a2e96aecced1" in run_output.stdout:
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test36.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
