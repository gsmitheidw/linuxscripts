#!/bin/bash

# install script
cp userscript.sh /usr/local/bin/userscript
chmod 755 /usr/local/bin/userscript

cp clearusers.sh /usr/local/bin/clearusers
chmod 755 /usr/local/bin/clearusers

# install man page for script
mkdir -p /usr/local/man/man1
cp userscript.1.gz /usr/local/man/man1/
mandb -q

# pre-requisite packages
apt install -y putty-tools zip dialog

#EOF
