import sys
import paramiko

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

git_dir = "~/distributed-bitmap-engine"
git_url = "https://github.com/Puget-Sound-Bitmaps/distributed-bitmap-engine.git"

common_setup = [
    # Remove local copy if it exits.
    "rm -rf {dir}".format(dir=git_dir),
    # Clone a clean copy.
    "git clone -b {b} {url} {dir}".format(b=git_branch,url=git_url,dir=git_dir),
    # Run local setup script.
    "bash {dir}/scripts/setup.sh".format(dir=git_dir)
]

master_setup = common_setup + [
    # Run local startup script.
    "bash {dir}/scripts/startup.sh master".format(dir=git_dir)
]

slave_setup = common_setup + [
    # Run local startup script.
    "bash {dir}/scripts/startup.sh slave".format(dir=git_dir)
]

pkey = paramiko.RSAKey.from_private_key_file(servers.ssh_key)
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

print("-"*80)

# Slave Nodes
for username, hostname in servers.slave_list:
    print("Connecting to {} as {}.".format(hostname, username))
    client.connect(hostname = hostname, username = username, pkey = pkey )

    for command in slave_setup:
        print("Executing `{}`".format(command))
        stdin, stdout, stderr = client.exec_command(command)
        out = stdout.read().decode()
        err = stderr.read().decode()
        if len(out) > 0:
            print("Out:\n{}".format(out))
        if len(err) > 0:
            print("Err:\n{}".format(err))
    client.close()
    print("-"*80)

# Master Node
username, hostname = servers.master_node
print("Connecting to {} as {}.".format(hostname, username))
client.connect(hostname = hostname, username = username, pkey = pkey )

for command in master_setup:
    print("Executing `{}`".format(command))
    stdin, stdout, stderr = client.exec_command(command)
    out = stdout.read().decode()
    err = stderr.read().decode()
    if len(out) > 0:
        print("Out:\n{}".format(out))
    if len(err) > 0:
        print("Err:\n{}".format(err))
client.close()
