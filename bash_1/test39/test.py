import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test39.sh"], capture_output=True, text=True)

    output = subprocess.run(["ls", "-l", "dir"], capture_output=True, text=True)
    
    dir_permission = output.stdout.split("\n")[1][:10]
    file1_permission = output.stdout.split("\n")[2][:10]
    file2_permission = output.stdout.split("\n")[3][:10]

    #dir_permission != "dr--r--r--" and file1_permission == "-rw-r--r--" and file1_permission == "-rw-r--r--":
    if run_output.stderr == "" and dir_permission != "drw-r--r--" and file1_permission == "-rw-r--r--" and file1_permission == "-rw-r--r--":
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test39.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
