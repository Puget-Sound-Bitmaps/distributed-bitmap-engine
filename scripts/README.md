# Distributed Bitmap Engine

## Scripts

This is a collection of scripts designed to facilitate setting up new nodes,
ensuring every node has an up-to-date version of the project, locally building
the system, and starting up the system for testing.

### Setup

In order to use the provided scripts, you will need to create configuration
files used in the connecting process. These files will resemble the following:
```python
ssh_key = "/home/ubuntu/.ssh/key-name.pem"

master_node = ("ubuntu", "0.1.2.3")

slave_nodes = {
    ("ubuntu", "4.5.6.7"),
    ("ubuntu", "8.9.0.1")
}
```
We are (currently) assuming that all of the nodes are accessible using a single
`.pem` key-file, and that there is a single master node. There may there must
be at least one slave node, but there is no set limit on the number of slave
nodes. The nodes are specified as a tuple with the user-name as the first
component and the IP address as the second. You may create multiple such
configuration files so as to facilitate testing multiple system setups (e.g.,
varying the number of nodes).

You will also need to install `paramiko` either through `pip` (or `pip3`) or your preferred
python module manager.

### Usage

From your computer, you will run the `dbe-setup-and-run.py` script which will
call the other scripts as needed. `dbe-setup-and-run.py` will run `setup.sh` and
`startup.sh` on each of the nodes. This will first ensure the nodes have all
necessary requirements and then build and run the system.

A prototypical usage will be:
```shell
$ python3 dbe-setup-and-run.py servers.py master
```
Where `servers.py` is your configuration file (described under Setup, above) and
`master` is the desired branch.

### Notes

Currently, we are assuming that all nodes are running Ubuntu so that we can use
`apt` to install necessary packages. Further work would be needed to detect
the distribution on a system and then use the appropriate package manager.

The scripts require that the user being used have super-use privileges.
For instance, installing via `apt` usually requires `sudo` as does `rpcbind`.
