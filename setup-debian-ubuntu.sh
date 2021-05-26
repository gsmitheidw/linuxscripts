# Setting up new Linux system

# uncommment if proxy required:
#export http_proxy=''
#export https_proxy=''

# Install some apps
install_apps {

applications=$(dialog --checklist "Choose software" 10 40 3 \
        vim . on \
        screen . on \
        fail2ban . on \
        htop . on \
        curl . on \
        mc . on \
        lshw . on \
        moreutils . \
        git . off \
        aria2c . off \
        monit . off \
        ccze . off \
        ffmpeg . off \
        sysstat . off \
        httping . off \
        netcat . off  2>&1 > /dev/tty)

echo "apt install $applications -y"

# if screen installed:
dpkg -s screen &> /dev/null
if [ "$?" = "0" ];
then
echo GNU screen installed, downloading config to current user
wget -O - https://gist.githubusercontent.com/gsmitheidw/6ec6eb2dce79fde80f51c7e98f17a327/raw/027c87b77841d24b3cc4421fc621a5413b51afa2/.screenrc > ~/.screenrc
fi

}


# Setup unattended upgrades
setup_unattended {
apt install unattended-upgrades apt-listchanges
dpkg-reconfigure unattended-upgrades
vim /etc/apt/apt.conf.d/50unattended-upgrades
unattended-upgrade -d --dry-run
}



# call functions:
install_apps
#setup_unattended
