# across-workflows

Repository of CWL workflows and [StreamFlow](https://streamflow.di.unito.it/) files.

## Installation

To run these worflows in a development environment, install the following pre-requisites.

### Python

StreamFlow requires a python version >= 3.8

### Install docker

See docker documentation, for example on Ubuntu: https://docs.docker.com/engine/install/ubuntu/

Then execute post-installation step to manager docker as a non-root user:
```bash
sudo usermod -aG docker $USER
```
logout and login again

### Install unzip

```bash
sudo apt install unzip
````

### Install pip

See pip documentation at https://pip.pypa.io/en/stable/installation/ for different installation methods.

For example:

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
export PATH=$HOME/.local/bin:$PATH
````

### Install StreamFlow

Run this command:

```bash
pip install streamflow
```

## Run a workflow

The [OPM Flow](https://opm-project.org/?page_id=19) workflow is performing the following steps:
* download a dataset at a given URL
* unzip the dataset
* run OPM flow in a docker container for a given input deck.

Input parameters providing the dataset URL and input deck to used are provided in [carbonSequestration/cwl/config.yaml](carbonSequestration/cwl/config.yaml):

To run this workflow, first clone this git repository:

```bash
git clone https://github.com/laurentganne/across-workflows.git
```

Then run the worflow using StreamFlow:

```bash
streamflow run across-workflows/carbonSequestration/opmFlow.yaml
```

Final logs will describe results are available in `flow_output` directory.
This workflow provides the following files in output:
* files generated by OPM flow
* OPM flow execution output in file `output_flow.log`:

```
{
    "results": [
        {
            "basename": "output",
            "class": "Directory",
            "dirname": "/home/user/flow_output/NweadI",
            "listing": [
                {
                    "basename": "SPE1CASE1.INFOSTEP",
                    "checksum": "sha1$21c30c90dd6f1ab53e4f3b1a31c33bac52692f20",
                    "class": "File",
                    "dirname": "/home/user/flow_output/NweadI/output",
                    "location": "file:///home/user/flow_output/NweadI/output/SPE1CASE1.INFOSTEP",
                    "nameext": ".INFOSTEP",
                    "nameroot": "SPE1CASE1",
                    "path": "/home/user/flow_output/NweadI/output/SPE1CASE1.INFOSTEP",
                    "size": 13104
                },

                [...]
        },
        {
            "basename": "output_flow.log",
            "checksum": "sha1$a2d95d37511e0d25a5617de342665d59a3d312e1",
            "class": "File",
            "dirname": "/home/user/flow_output/NweadI",
            "location": "file:///home/user/flow_output/NweadI/output_flow.log",
            "nameext": ".log",
            "nameroot": "output_flow",
            "path": "/home/user/flow_output/NweadI/output_flow.log",
            "size": 45161
        }
    ]
}
```