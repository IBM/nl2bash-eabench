import subprocess
import json

def main():
    run_output = subprocess.run(["export USER=root ; bash test11.sh"], capture_output=True, shell=True, text=True)

    if run_output.stderr == "":
        try:
            with open("users.txt") as f:
                data = f.read()
                if data == "user1\nroot\n":
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

    with open("output/results_test11.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()