"""
    Kill every dbms, master and slave process on the given machines.
"""

import sys, paramiko
# TODO: make a script utility file for all scripts
servers = __import__(sys.argv[1].replace('.py', ''))
from servers import slave_nodes, master_node, ssh_key

pkey = paramiko.RSAKey.from_private_key_file(ssh_key)
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

def connect_and_run(username, hostname, commands):
    global ssh, pkey
    ssh.connect(hostname=hostname, username=username, pkey=pkey)
    for c in commands:
        stdin, stdout, stderr = ssh.exec_command(c)
        out = stdout.read().decode()
        err = stderr.read().decode()
        if len(out) > 0:
            print("Out:\n{}".format(out))
        if len(err) > 0:
            print("Err:\n{}".format(err))

master_commands = ['pkill master', 'pkill dbms']
# kill slave node processes
for username, hostname in slave_nodes:
    connect_and_run(username, hostname, ['pkill slave'])
print("All slaves killed")
# kill master node processes
connect_and_run(master_node[0], master_node[1], master_commands)
print("DBMS/Master killed")
ssh.close()
