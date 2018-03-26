#!/bin/bash

echo "Configuring System for Distributed Bitmap Engine"

UPDATEFILE="/home/ubuntu/.dbe.checked-updates"
DEPENDFILE="/home/ubuntu/.dbe.checked-dependencies"

# Touch with `-a` ensures files exit without altering modification time.
touch -a $UPDATEFILE
touch -a $DEPENDFILE

# We only run updates if it has been at least one day since we last checked.
if test `find $UPDATEFILE -mmin +1440`
then
    echo "Ensuring System is Up to Date"
    sudo apt-get --yes update
    sudo apt-get --yes upgrade
    sudo apt-get --yes dist-upgrade
    sudo apt-get --yes auto-remove
    sudo apt-get --yes auto-clean
    touch $UPDATEFILE
else
    echo "Assuming System is Up to Date"
fi

# We only check dependencies if it has been at least one hour since we last checked.
if test `find $DEPENDFILE -mmin +60`
then
    echo "Ensuring System Has Dependencies"
    sudo apt-get --yes install default-jdk  # Java
    sudo apt-get --yes install python3      # Python
    sudo apt-get --yes install gcc          # C Compiler
    sudo apt-get --yes install libc-dev-bin # rpcgen
    sudo apt-get --yes install libssl-dev   # OpenSSL
    touch $DEPENDFILE
else
    echo "Assuming System Has Dependencies"
fi
