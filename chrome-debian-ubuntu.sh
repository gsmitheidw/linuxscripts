#!/bin/bash
# Short script to install Google Chrome on Debian or related distros Ubuntu etc.
# Created mostly because surprisingly this isn't all in one place on Google (at time of writing)

wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
apt update; apt install google-chrome-stable -y 
