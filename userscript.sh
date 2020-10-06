#!/bin/bash
# Create users with ssh key auth (only no passwords), by G. Smith Feb 2014-2020
# Requires users.txt containing list of user ids and
# the following binaries installed: ssh zip puttygen shred
#
# Note switches for adduser differ on Redhat based systems to Debian based and may need amending.

nonroot="gsmith"

# Stop script on error
set -e

# Cycle through user accounts list 

for username in `cat users.txt`
        do
        # Create user account
        adduser --force-badname --disabled-password --home /home/$username --gecos user,x,x,x,x --shell /bin/bash $username
        # Generate ssh key as each user
        su - -c "ssh-keygen -q -f ~/.ssh/id_rsa -N '' -C $username" $username
        su - -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys" $username
        # Copy private key per user to temp directory
        su - -c "cp ~/.ssh/id_rsa /tmp/id_rsa.$username" $username
        su - -c "puttygen ~/.ssh/id_rsa -o /tmp/id_rsa.$username.ppk" $username
done

# Archive the student private keys in openssh format for delivery
zip -r /home/$nonroot/user_private_keys_`date +"%d-%m-%y"`.zip /tmp/id_rsa.*
# Allow collection of keys for non-root user to download. 
# Alternatively this can be copied to a collection point with rclone or scp etc
chmod 644 /home/$nonroot/user_private_keys_`date +"%d-%m-%y"`.zip

# Clean up cached private keys from tmp folder
shred -u -f /tmp/id_rsa.*

# Make a backup of users.txt
mv --backup=t users.txt users.`date +"%Hh-%Mm-%d-%m-%y"`.txt


echo "done!"
