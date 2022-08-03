#/bin/bash
# Webtrees Manual Upgrade (To Latest)

webtrees_root='/var/www/html'
cd $webtrees_root

touch webtrees/data/offline.txt

# Obtain the url for the latest release
url=$(curl -s https://api.github.com/repos/fisharebest/webtrees/releases/latest | grep browser_download_url | cut -d '"' -f 4)
wget $url

filename=$(echo $url | cut -b 65-82)

unzip -o $filename

rm webtrees/data/offline.txt 
