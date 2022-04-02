#!/bin/bash

mv userscript.sh /usr/local/bin/userscript
chmod 755 /usr/local/bin/userscript
mkdir /usr/local/man/man1
mv userscript.1.gz /usr/local/man/man1/
mandb

