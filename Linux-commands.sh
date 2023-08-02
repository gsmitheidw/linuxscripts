# For those times you just can't remember the name of the command that you only use occasionally 
# These are snippets, not a script!

#find disk serial numbers (replace /devsda )
udevadm info --query=all --name=/dev/sda | grep ID_SCSI_SERIAL

# live bandwidth usage expressed graphically with ascii
nload
speedometer -r eth0 -t eth0
# general system monitoring
glances
# variants of top
atop
ntop
# from smartmontools - check smart status of drives and run health tests etc
smartctl
# grab disk temps using smartmontools
smartctl -a -d sat /dev/sda | grep Temp | awk -F " " '{print $10}'
# identify which disk is in which physical position in a chassis:
lsscsi
#example output:
#[0:0:0:0]    disk    ATA      ST91000640NS     AA0D  /dev/sda
#[0:0:1:0]    disk    ATA      ST91000640NS     AA0D  /dev/sdb
#[0:0:2:0]    disk    ATA      ST91000640NS     AA0D  /dev/sdc
#[0:0:3:0]    disk    ATA      ST91000640NS     AA0D  /dev/sdd
#[7:0:0:0]    disk    IBM      2145             0000  /dev/sdf
#[8:0:0:0]    disk    IBM      2145             0000  /dev/sde
apt install ledmon
# ledmon ledctl can identify disks with LED eg: ledctl locate=/dev/sda 
# but does not support all boards/controllers
# netcat needs no intro
netcat or nc
# top for interfaces
iftop
# live ncurses based network information you can drill down into
iptraf
# allocate a chunk of disk sparsely - faster than filling with zeros etc. 
fallocate
# get the UUID for drives/volumes for use in fstab etc instead of mountpoints which may change ports (such as usb drives)
blkid
lsblk
# info on cpu
lscpu
# last bad logins
lastb
# remove app incl configs
apt-get purge
# watch a process/output every 15 seconds
watch -n 15
# timer for something running
time command
# wordcount
wc
netstat -tulpn
# show my public ip 
wget http://ipinfo.io/ip -qO -
# watch current users
whowatch
# no-hangup for persistent processes 
nohup
# Add a btfs device to an existing mountpoint then mirror it on the fly with balance.
btrfs device add -f /dev/sdb /media/usb1/
btrfs balance start -dconvert=raid1 -mconvert=raid1 /media/usb1/
# defrag
btrfs filesystem defragment /media/usb1/
# df
btrfs fi df
#create btrfs snapshot
btrfs subvolume snapshot /mnt/edu /mnt/edu/snapshot-date-time
# use resolvconf to manage resolveconf.conf 
resolvconf -a eth0
# show iops
iostat (installed from sysstat package)
iostat -y 1 1 (for current, default is average since boot)
iostat -d -p sde -m # where sde is drive
iotop -botqqq -u backuppc --iter=5  # where proccess in this case is backuppc
# bbc iplayer
apt-get install get-iplayer
export S_COLORS=always #for iostat highlighting if version supports it
btrfs scrub start /mounted/path 
free -m
# grab a cleaned up list of ip addresses and corrsponding macs from arp:
arp -a | grep -v incomplete | awk -F " " '{printf $2 " " $4 "\n"}'  | tr '()' ' '
# allow run vlc to be run as root
sed -i 's/geteuid/getppid/' /usr/bin/vlc
# colourise logs
ccze logfile.log
cat /var/log/syslog | ccze -A | more
# create html output from colourised logs:
aha
# statistics on traffic over time
vnstat
# watch multiple logs:
multitail
# midnight commander
mc
# expect scripting
expect and send
# Grab a single file from most recent backup of hostname and sharename /home/user and pipe from stdout to backup.tar:
/usr/share/backuppc/bin/BackupPC_tarCreate -h hostname -n -1 -s /home/user /filetorestore.txt > backup.tar 
# get the weather with curl:
 curl wttr.in/dublin
# prepend dates to log files:
apt install moreutils
#then pipe into ts:
| ts 
# fail2ban for security
fail2ban
# Extract e-mail addresses from a text file, spaces surround the e-mail addresses, no other @ signs in the file assumed:
cat textfile.txt | awk -F " "  '{for(i=1; i<=NF; i++)if($i ~ /@/) print $i }'
# Unattended upgrades Debian 9:
apt install unattended-upgrades apt-listchanges
dpkg-reconfigure unattended-upgrades
vim /etc/apt/apt.conf.d/50unattended-upgrades
unattended-upgrade -d --dry-run
# useful apps
apt install nload vim curl wget lynx w3m cntlm htop glances `
tcpdump smartmontools ssmtp  vnstat netcat telnet mc uuid-dev `
zlib1g-dev gcc make autoconf automake pkg-config net-tools ccze `
sysstat vnstat iotop monit moreutils freeipmi screenfetch iptraf  `
whowatch expect ttyload multitail lsof pigz nmap rsync mtr mlocate cdpr
# process accounting
psacct or acct
# mkfifo  (named pipes)
mkfifo pipe2
#eg:
ls > pipe2
cat < pipe2 
# bash/readline shortcuts:
ALT + b and f - to back and forward by a word
CTRL + u or k - kill text back or forward from cursor
ALT + u and l - to-upper and to-lower case words (forward only)
CTRL + xx - jump to start of line and back again to original cursor position
# Hide users processes that are not their own (toggle 0,1,2):
mount -o remount,rw,hidepid=1 /proc
proc    /proc    proc    defaults,hidepid=1     0     0
autossh -o GatewayPorts=true -R 0.0.0.0:8889:127.0.0.1:8889 remotehost -p remoteport -l user -g -v -N
# tee to stdout and also run anoyther command from the pipe at the same time
last | grep user | awk -F " " '{print $3}' | sort | uniq -u  | tee >(wc -l)
# using "who" to identify a remote login and an ip address or hostname with a tty.
# kill this process to remove the remote login. In this example it is pts/5:
ps -t pts/5 | awk -F ' ' '{print $1}' | tail -1 | xargs kill -9
######### Proxmox time sync
##############################
apt install chrony
# This will remove systemd-timesyncd which is replaced by chrony in Proxmox 7+
echo server '192.168.1.1 iburst' > /etc/chrony/sources.d/local-ntp-server.sources
systemctl restart chronyd
#check it's working
journalctl --since -1h -u chrony
# Fixing timesync 401 errors following cluster time issues
# Clear rrd cache
killall pvestatd
systemctl stop rrdcached.service
rrdcached -P FLUSHALL
systemctl start rrdcached.service
systemctl start pvestatd.service
# sync hw clock
hwclock --systohc
##############################
