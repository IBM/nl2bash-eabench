import subprocess
import json

def main():
    run_output = subprocess.run(["bash", "test38.sh"], capture_output=True, text=True)

    output1 = subprocess.run(["ls", "-l", "dir"], capture_output=True, text=True)
    output2 = subprocess.run(["ls", "-l", "dir/dir1"], capture_output=True, text=True)
    
    dir1_permission = output1.stdout.split("\n")[1][:10]
    dir2_permission = output1.stdout.split("\n")[2][:10]
    dir3_permission = output2.stdout.split("\n")[1][:10]
    file_permission = output1.stdout.split("\n")[3][:10]

    if run_output.stderr == "" and dir1_permission == "drwxrw-rw-" and dir2_permission == "drwxrw-rw-" and dir3_permission == "drwxrw-rw-" and file_permission != "-rwxrw-rw-":
        result = "Pass"
    else:
        result = "Fail"

    output = {
        "result": result,
        "returncode": run_output.returncode,
        "stdout": run_output.stdout,
        "stderr": run_output.stderr
    }

    with open("output/results_test38.json", "w") as f:
        json.dump(output, f)


if __name__ == "__main__":
    main()
