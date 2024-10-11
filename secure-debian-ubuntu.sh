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
curl -fsSL https://packages.cisofy.com/keys/cisofy-software-public.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cisofy-software-public.gpg
echo "deb [arch=amd64,arm64 signed-by=/etc/apt/trusted.gpg.d/cisofy-software-public.gpg] https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
apt install apt-transport-https
echo 'Acquire::Languages "none";' | sudo tee /etc/apt/apt.conf.d/99disable-translations
echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
apt update&&apt install lynis -y

touch /etc/apt/preferences.d/lynis
cat <<EOF > /etc/apt/preferences.d/lynis
Package: lynis
Pin: origin packages.cisofy.com
Pin-Priority: 600
EOF

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


