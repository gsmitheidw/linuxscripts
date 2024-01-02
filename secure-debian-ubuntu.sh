# Some snippets to secure and harden a system:

# Optional Lynis install via git:
#cd /opt
#git clone --depth 1  https://github.com/CISOfy/lynis
#./lynis audit system

# antivirus
apt install clamav clamav-daemon -y
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam


apt install fail2ban git debsums chkrootkit sysstat libpam-tmpdir needrestart debsecan apt-listbugs arpwatch -y
# randomness/entropy
apt install rng-tools-debian haveged -y

# install lynis
# see lynis CIS apt repo...

# automation
# install ansible (if reqired)

# ensure jails don't get over-written
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# unpurged packages:
dpkg --list | grep ^rc | awk '{ print $2; }'
# purge:
apt purge `dpkg --list | grep ^rc | awk '{ print $2; }'`

# automatic updates:
apt install unattended-upgrades -y
systemctl start unattended-upgrades
systemctl enable unattended-upgrades
unattended-upgrades --dry-run --debug


