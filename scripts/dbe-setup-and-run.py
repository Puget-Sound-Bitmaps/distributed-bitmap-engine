import sys, os, string, threading, paramiko

#########
# SETUP #
#########

usage = "Usage:" +\
        "\n" +\
        "\tpython3 dbe-setup-and-run.py [config file] [git branch name]\n" +\
        "[config file] defaults to [servers.py]" +\
        " and " +\
        "[git branch name] defaults to [master]" +\
        "\n"

try:
    # First arg is node information filename. (e.g., servers.py)
    servers = __import__(sys.argv[1].replace('.py', ''))
except:
    try:
        import servers
        print("No config file specified, defaulting to servers.py.\n" +
              "Explicitly specifying the desired config file is recommended.\n" +
              usage)
    except:
        print("Could not import the configuration file.\n" + usage)
        sys.exit(1)

try:
    git_branch = sys.argv[2]
except:
    git_branch = "master"
    print("No branch specified, defaulting to master.\n" +
          "Explicitly specifying the desired branch is recommended.\n" +
          usage)

#############
# VARIABLES #
#############

git_dir = "/home/{username}/distributed-bitmap-engine"
git_url = "https://github.com/Puget-Sound-Bitmaps/distributed-bitmap-engine.git"

pkey = paramiko.RSAKey.from_private_key_file(servers.ssh_key)
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

slaves = sorted(list(servers.slave_nodes))

#########################
# CONFIGURE SLAVE NODES #
#########################

# Slave Nodes
for username, hostname in slaves:
    print("SLAVE: Connecting to {} as {}.".format(hostname, username))
    ssh.connect(hostname=hostname, username=username, pkey=pkey)

    slave_setup = [
        # Remove local copy if it exits.
        "rm -rf {dir}".format(dir=(git_dir.format(username=username))),

        "sudo apt-get --yes install git",

        # Clone a clean copy.
        "git clone --recurse-submodules -b {b} {url} {dir}".format(b=git_branch,url=git_url,dir=(git_dir.format(username=username))),

        # Run local setup script.
        "bash {dir}/scripts/setup.sh".format(dir=(git_dir.format(username=username))),

        # Ensure rpc is bound.
        "sudo rpcbind",

        # Build system.
        "cd {dir}/distributed-system && make".format(dir=(git_dir.format(username=username)))
    ]

    for command in slave_setup:
        print("Executing `{}`".format(command))

        stdin, stdout, stderr = ssh.exec_command(command)

        out = stdout.read().decode()
        err = stderr.read().decode()
        if len(out) > 0:
            print("Out:\n{}".format(out))
        if len(err) > 0:
            print("Err:\n{}".format(err))


    ssh.close()

    print("-"*80)

#########################
# CONFIGURE MASTER NODE #
#########################

# Master Node
username, hostname = servers.master_node
print("MASTER: Connecting to {} as {}.".format(hostname, username))
ssh.connect(hostname=hostname, username=username, pkey=pkey)

master_setup = [
    # Remove local copy if it exits.
    "rm -rf {dir}".format(dir=(git_dir.format(username=username))),

    "sudo apt-get --yes install git",

    # Clone a clean copy.
    "git clone --recurse-submodules -b {b} {url} {dir}".format(b=git_branch,url=git_url,dir=(git_dir.format(username=username))),

    # Run local setup script.
    "bash {dir}/scripts/setup.sh".format(dir=(git_dir.format(username=username))),

    # Ensure rpc is bound.
    "sudo rpcbind",

    # Build System
    "cd {dir}/distributed-system && make".format(dir=(git_dir.format(username=username)))
]

for command in master_setup:
    print("Executing `{}`".format(command))
    stdin, stdout, stderr = ssh.exec_command(command)
    out = stdout.read().decode()
    err = stderr.read().decode()
    if len(out) > 0:
        print("Out:\n{}".format(out))
    if len(err) > 0:
        print("Err:\n{}".format(err))

ssh.close()


print("\n" + ("-"*80) +  "STARTING SYSTEMS" + ("-"*80) + "\n")

outlock = threading.Lock()
start_cmd = "cd {dir}/distributed-system/bin && ./{type}"

def start(hostname, username, kind):
    sshT = paramiko.SSHClient()
    sshT.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    sshT.connect(hostname=hostname, username=username, pkey=pkey)

    if kind == "master":
        kind = "dbms 0"

    stdin, stdout, stderr = sshT.exec_command(start_cmd.format(dir=(git_dir.format(username=username)), type=kind))

    out = stdout.read().decode()
    err = stderr.read().decode()
    if len(out) > 0:
        print("Out:\n{}".format(out))
    if len(err) > 0:
        print("Err:\n{}".format(err))


threads = []

for username, hostname in slaves:
    t = threading.Thread(target=start, args=(hostname, username, "slave"))
    t.start()
    threads.append(t)

for username, hostname in [servers.master_node]:
    t = threading.Thread(target=start, args=(hostname, username, "master"))
    t.start()
    threads.append(t)

for t in threads:
    t.join()
