# Some snippets to secure and harden a system:

apt install fail2ban git -y
cd /opt
git clone --depth 1  https://github.com/CISOfy/lynis
#./lynis audit system

apt install clamav clamav-daemon -y
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam
