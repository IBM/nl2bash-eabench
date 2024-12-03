import subprocess
import os
import json

def main():
    run_output = subprocess.run(["bash", "test10.sh"], capture_output=True, text=True)

    correct_json = {"hello": "world"}

    txt_file_exist = True if "a.txt" in os.listdir() else False
    json_file_exist = True if "b.json" in os.listdir() else False

    if run_output.stderr == "" and not txt_file_exist and json_file_exist:
        try:
            with open("b.json") as f:
                data = json.load(f)
                if data == correct_json:
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

    with open("output/results_test10.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()

    