import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test6.sh"], capture_output=True, text=True)

    check_cmd = 'if [ -x run.py ]; \nthen echo "true"; \nelse echo "false"; \nfi'
    check_output = subprocess.run(check_cmd, shell="bash", capture_output=True)
    if run_output.stderr == "" and "true" in check_output.stdout.decode("utf-8"):
        result = "Pass"
    else:
        result = "Fail"


    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test6.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    