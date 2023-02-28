#/bin/bash
# Webtrees Manual Upgrade (To Latest)

type curl >/dev/null 2>&1 || { echo >&2 "Require curl but it's not installed.  Aborting."; exit 1; }
type wget >/dev/null 2>&1 || { echo >&2 "Require wget but it's not installed.  Aborting."; exit 1; }

reqspace='200'
freespace=$(df -m "/" | awk 'END{print $4}') 
if [[ freespace -le reqspace ]]
then
		echo "Not enough space to proceed"
		exit 1
fi

echo "Starting upgrade in 5 seconds..."
sleep 5
webtrees_root="/var/www/html"
cd $webtrees_root
touch $webtrees_root/webtrees/data/offline.txt


# Obtain the url for the latest release
url=$(curl -s https://api.github.com/repos/fisharebest/webtrees/releases/latest | grep browser_download_url | cut -d '"' -f 4)
wget $url

filename=$(basename "$url")

unzip -o $filename

rm $webtrees_root/webtrees/data/offline.txt 


