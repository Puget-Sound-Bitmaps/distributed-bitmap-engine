# Server Information
import servers

# SSH Package
import paramiko

git_dir = "/tmp/dbe"
git_branch = "deployment-scripts"
git_url = "https://github.com/Puget-Sound-Bitmaps/distributed-bitmap-engine.git"

common_setup = [
    # Remove local copy if it exits.
    "if [ -d '{dir}' ]; then rm -Rf {dir}; fi".format(dir=git_dir),
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

key = paramiko.RSAKey.from_private_key_file(servers.key)
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# Slave Nodes
for username, hostname in servers.slave_list:
    print("Connecting to {} as {}.".format(hostname, username))
    client.connect(hostname = hostname, username = username, pkey = key )

    for command in slave_setup:
        print("Executing `{}`".format(command))
        stdin , stdout, stderr = client.exec_command(command)
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
client.connect(hostname = hostname, username = username, pkey = key )

for command in master_setup:
    print("Executing `{}`".format(command))
    stdin , stdout, stderr = client.exec_command(command)
    out = stdout.read().decode()
    err = stderr.read().decode()
    if len(out) > 0:
        print("Out:\n{}".format(out))
    if len(err) > 0:
        print("Err:\n{}".format(err))
client.close()
