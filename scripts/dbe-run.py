import sys, os, string, threading, paramiko, time
servers = __import__("servers")
slaves = sorted(list(servers.slave_nodes))
pkey = paramiko.RSAKey.from_private_key_file(servers.ssh_key)
git_dir = "/home/{username}/distributed-bitmap-engine"
username = "ubuntu"

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
    print("Firing slave thread {}".format(hostname))
    t.start()
    threads.append(t)

time.sleep(10)

for username, hostname in [servers.master_node]:
    t = threading.Thread(target=start, args=(hostname, username, "master"))
    print("Firing master thread")
    t.start()
    threads.append(t)

for t in threads:
    t.join()
