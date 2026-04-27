# 🐧 Linux Command Cheat Sheet

### Miscellaneous & Essential Snippets
A collection of "how-to" commands and tools for quick reference.

---

## 🏗️ System & Hardware Information
| Command | Description |
| :--- | :--- |
| `lscpu` | Detailed information about the CPU architecture. |
| `lshw` | List all hardware. Use `lshw -C display` for GPU info. |
| `lsblk` | List block devices (view partitions/mount points). |
| `blkid` | Get UUIDs for drives/volumes (essential for `/etc/fstab`). |
| `free -m` | Show RAM usage in Megabytes. |
| `screenfetch` | Display system info with an ASCII logo. |
| `hwclock --systohc` | Sync hardware clock to system time. |

---

## 💾 Storage & Disk Management

### Drive Identification
* **Find Serial Numbers:**
    `udevadm info --query=all --name=/dev/sda | grep ID_SCSI_SERIAL`
* **Identify physical slot position:**
    `lsscsi`
* **Identify disk via LED (if supported):**
    `ledctl locate=/dev/sda`

### Disk Health & Performance
* **Check SMART status:** `smartctl -a /dev/sda`
* **Grab Disk Temp:**
    `smartctl -a -d sat /dev/sda | grep Temp | awk -F " " '{print $10}'`
* **IOPS Monitoring:**
    `iostat -y 1 1` (Current stats, requires `sysstat`)
    `iotop -botqqq -u [user] --iter=5` (Process-specific I/O)

### File Systems
* **Allocate sparse file:** `fallocate -l 10G test_file`
* **BTRFS Management:**
    * `btrfs device add -f /dev/sdb /media/usb1/` (Add device)
    * `btrfs balance start -dconvert=raid1 -mconvert=raid1 /media/usb1/` (Mirror/Balance)
    * `btrfs filesystem defragment /media/usb1/` (Defrag)
    * `btrfs scrub start /mounted/path` (Check integrity)
    * `btrfs subvolume snapshot /src /dest/snapshot-name` (Snapshot)

---

## 🌐 Networking

### Monitoring & Usage
* **Bandwidth (ASCII):** `nload` or `speedometer -r eth0 -t eth0`
* **Interface Top:** `iftop`
* **Deep Dive TUI:** `iptraf`
* **Traffic Stats over time:** `vnstat`
* **Public IP:** `wget http://ipinfo.io/ip -qO -`
* **Netstat (Listening ports):** `netstat -tulpn`

### Utils & Config
* **Clean ARP List:**
    `arp -a | grep -v incomplete | awk -F " " '{printf $2 " " $4 "\n"}' | tr '()' ' '`
* **Manage Resolv:** `resolvconf -a eth0`
* **Tunneling:**
    `autossh -o GatewayPorts=true -R 0.0.0.0:8889:127.0.0.1:8889 remotehost -p [port] -l [user] -g -v -N`

---

## 📊 System Monitoring & Processes

### "Top" Variants
* **Glances:** Comprehensive system overview (`glances`)
* **Atop:** Advanced system & process monitor (`atop`)
* **Ntop:** Network traffic probe (`ntop`)
* **Htop:** Interactive process viewer (`htop`)

### Process Management
* **Watch command output:** `watch -n 15 [command]`
* **Persistent process (no-hangup):** `nohup [command] &`
* **Identify/Kill remote login session:**
    `ps -t pts/5 | awk -F ' ' '{print $1}' | tail -1 | xargs kill -9`
* **Whowatch:** Real-time user/process monitoring.

---

## 📝 Logs & Text Processing

### Log Utilities
* **Colorize logs:** `ccze -A < /var/log/syslog`
* **Multi-log viewer:** `multitail`
* **Add timestamps to pipes:** `[command] | ts` (requires `moreutils`)
* **HTML Converter:** `aha` (converts ANSI color to HTML)

### Text Snippets
* **Extract Emails:**
    `cat file.txt | awk -F " " '{for(i=1; i<=NF; i++)if($i ~ /@/) print $i }'`
* **Count words/lines:** `wc`
* **Named Pipes:**
    `mkfifo pipe2; ls > pipe2` (then `cat < pipe2` in another terminal)

---

## 🛠️ Package Management & Security (Debian/Ubuntu)

* **Purge App (incl. configs):** `apt-get purge [package]`
* **Unattended Upgrades:**
    `dpkg-reconfigure unattended-upgrades`
* **Security:** `fail2ban`
* **Hide processes from other users:**
    `mount -o remount,rw,hidepid=1 /proc`
* **Process Accounting:** `psacct` (or `acct`)

---

## 🗃️ Specific Tools

* **BackupPC Restore Snippet:**
    `/usr/share/backuppc/bin/BackupPC_tarCreate -h hostname -n -1 -s /home/user /file.txt > backup.tar`
* **Proxmox Time Sync (Chrony):**
    `echo server '192.168.1.1 iburst' > /etc/chrony/sources.d/local.sources`
* **CLI Fun:**
    * `curl wttr.in/dublin` (Weather)
    * `glow` (Markdown renderer)
    * `chafa` (Images to ANSI)
    * `mc` (Midnight Commander)

---

## ⌨️ Bash / Readline Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `ALT + B / F` | Move cursor back/forward by one word. |
| `CTRL + U` | Delete text from cursor to **start** of line. |
| `CTRL + K` | Delete text from cursor to **end** of line. |
| `ALT + U / L` | Uppercase / Lowercase word forward. |
| `CTRL + X + X` | Toggle cursor between current position and start of line. |
