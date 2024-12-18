# Introduction
Given recent advancement of Large Language Models (LLMs), the task of translating from natural language prompts to different programming languages (code generation) attracts immense attention for wide application in different domains. Specially code generation for Bash (NL2Bash) is widely used to generate Bash scripts for automating different tasks, such as performance monitoring, compilation, system administration, system diagnostics, etc. 

Execution-based Evaluation (EE) can validate the predicted code by comparing the execution output of model prediction and expected output in system. However, designing and implementing such an execution-based evaluation system for NL2Bash is not a trivial task. Our paper, [Tackling Execution-Based Evaluation for NL2Bash](https://arxiv.org/abs/2405.06807), presents the design and discusses the challenges of our benchmark for NL2Bash.

# Execution Accuracy Benchmarks
Execution Test Bench for evaluating LLMs on BASH script generation.
Current benchmarks:  
1. bash_1 - a set of 50 basic tests for BASH
2. bash_2 - a more system-oriented set of 50 tests for BASH 
3. bash_3 - a set of 50 tests for BASH which require more than a single line of scripting

### Installation
Install Docker or Podman, your choice

### Running
For each benchmark in [bash_1, bash_2, bash_3]:
1. Build the container of choice by
    ````{bash}
    ./{benchmark}/containers/podman_build.sh
      or 
    ./{benchmark}/containers/docker_build.sh
    ````
2. Generate JSON test file, output/{benchmark}.json, for the benchmark:  
    ````{bash}
    ./generate.py {benchmark}
    ```` 
    Scans each test under the benchmark to gather information needed for evaluation. This only needs to be done once.
3. For each test in {benchmark}.json, run the `prompt` thru your model and replace the `script` with its output.
    As generated, the output file has this format for each test:
    ````{json}
      [ {
            "test"   : "testX",
            "name"   : "short name for this test",
            "prompt" : "prompt for LLM",
            "script" : "replace this field with the output from your LLM",
            "path"   : "identifies the benchmark"
        }, ... ]
    ````
4. Run the evaluation:  
    ````{bash}
    ./evaluate.py {benchmark}.json  # defaults to using podman
      or 
    ./evaluate.py --platform docker {benchmark}.json
    ````
    Outputs one JSON file per test, output/{benchmark}/results_{testX}.json:  
    ````{json}
        {
            "result"     : "testX",
            "returncode" : {numeric return code, 0 is passing},
            "stdout"     : "standard output from script test",
            "stderr"     : "standard error from script test"
        }
    ````
    Also outputs a consolidated results file, output/{benchmark}_eval.json, containing an array of results:  
    ````{json}
        [ {
            "test"      : "testX",
            "path"      : "identifies the benchmark",
            "result"    : "Pass", (or "Fail")
            "returncode": 0,
            "script"    : "script that was tested",
            "stdout"    : "standard output",
            "stderr"    : "standard error"
          }, ... ]
    ````
### Notes
- Adding the flag `--gt` to generate.py will populate the `script` field with a "ground truth" script. This is useful for testing the compatibility of the evaluators in evaluate.py with your runtime environment. 
- Rather than using the `--platform` flag on evaluate.py, you can set the PLATFORM environment variable: `export PLATFORM=docker`
### Requires
python3 >= 3.7

### Tested on
    - Ubuntu 22.04 with Python3 3.10.12, docker 27.3.1, podman 3.4.4
    - Ubuntu 24.04 with Python3 3.12.3,  docker 27.3.1, podman 4.9.3

    - RedHat 8.10 with Python3 3.8.17, docker 27.3.1, podman 4.9.4
    - Redhat 9.4  with Python3 3.9.18, docker 27.3.1, podman 4.9.4

    - Windows 11 WSL 2 version 2.3.24.0
        - Ubuntu 24.04 with Python3 3.12.3, docker 27.3.1, podman 4.9.3
        - Oracle Linux 9.1 with Python3 3.9.14, docker 27.3.1, podman 4.9.4
            - had to set "setuid" on /usr/bin/newuidmap and /usr/bin/newgidmap
            - had to install bc
            - had to boot with systemd for docker
                - /etc/wsl.conf
                [boot]
                systemd=true

    - MacOS - untested

### Reference
Please cite the following paper should you use our work.

````{json}
@misc{vo2024executionbasedevaluationnaturallanguage,
      title={Execution-Based Evaluation of Natural Language to Bash and PowerShell for Incident Remediation}, 
      author={Ngoc Phuoc An Vo and Brent Paulovicks and Vadim Sheinin},
      year={2024},
      eprint={2405.06807},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2405.06807}, 
}
````


